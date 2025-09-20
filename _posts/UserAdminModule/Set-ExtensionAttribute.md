---
layout: post
title: Set-ExtensionAttribute.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Set-ExtensionAttribute/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- Extension Attribute
description: No synopsis provided.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-ExtensionAttribute {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = "Provide a user object or SamAccountName"
        )]
        [Alias("SamAccountName")]
        [ValidateScript({
            if ($_ -is [string]) { return $true }
            if ($_ -is [Microsoft.ActiveDirectory.Management.ADUser]) { return $true }
            throw 'User must be a SamAccountName (string) or an ADUser object.'
        })]
        [Object]$User,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        # Accept extensionAttribute1..15 or CustomAttribute1..15 (case-insensitive)
        if ($_ -is [string] -and ($_ -match '^(?i:extensionAttribute([1-9]|1[0-5])|CustomAttribute([1-9]|1[0-5]))$')) { return $true }
        throw 'Attribute must be extensionAttribute1..15 or CustomAttribute1..15.'
    })]
    [string]$Attribute,

    [Parameter(Mandatory = $true)]
    [AllowNull()]
    [ValidateScript({
        # Allow null (to clear), booleans, arrays, or non-empty strings
        if ($null -eq $_) { return $true }
        if ($_ -is [bool]) { return $true }
        if ($_ -is [Array]) { return $true }
        if ($_ -is [string] -and ($_.Trim().Length -gt 0)) { return $true }
        throw 'Value must be $null, a boolean, a non-empty string, or an array.'
    })]
    [Object]$Value
    )

    begin {
        Import-Module ActiveDirectory -ErrorAction Stop
    }

    process {
        try {
            # Normalize attribute name: accept CustomAttributeN or extensionAttributeN and map to extensionAttributeN for AD
            if ($Attribute -match '^CustomAttribute(\d{1,2})$') {
                $num = $matches[1]
                $normalizedAttr = "extensionAttribute$num"
            }
            elseif ($Attribute -match '^extensionAttribute(\d{1,2})$') {
                $normalizedAttr = $Attribute
            }
            else {
                throw "Unsupported attribute name '$Attribute'. Use extensionAttributeN or CustomAttributeN."
            }

            # Resolve AD user object
            if ($User -is [string]) {
                $adUser = Get-ADUser -Identity $User -Properties $normalizedAttr -ErrorAction Stop
            }
            elseif ($User -is [Microsoft.ActiveDirectory.Management.ADUser]) {
                # If the supplied ADUser doesn't have the requested property, re-fetch to ensure it's present
                if (-not ($User.PSObject.Properties.Name -contains $normalizedAttr)) {
                    $adUser = Get-ADUser -Identity $User.SamAccountName -Properties $normalizedAttr -ErrorAction Stop
                }
                else { $adUser = $User }
            }
            else {
                throw "Unsupported input type: $($User.GetType().Name)"
            }

            # Coerce value to a string suitable for extensionAttribute storage (AD extension attributes are strings)
            if ($null -eq $Value) {
                $storeValue = $null
            }
            elseif ($Value -is [bool]) {
                $storeValue = $Value.ToString()
            }
            elseif ($Value -is [Array]) {
                # Join arrays to a single string (comma-separated)
                $storeValue = ($Value -join ',')
            }
            else {
                $storeValue = [string]$Value
            }

            $update = @{ $normalizedAttr = $storeValue }

            if ($PSCmdlet.ShouldProcess($adUser.SamAccountName, "Set $normalizedAttr to '$storeValue'")) {
                Set-ADUser -Identity $adUser.DistinguishedName -Replace $update -ErrorAction Stop
                Write-Verbose "Updated $($adUser.SamAccountName): $normalizedAttr = $storeValue"

                # Change applied. No object is returned so caller can verify against the desired domain/controller.
            }
        }
        catch {
            Write-Warning "Failed to update $($User): $($_.Exception.Message)"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Set-ExtensionAttribute.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-ExtensionAttribute.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

