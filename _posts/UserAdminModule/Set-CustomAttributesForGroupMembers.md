---
layout: post
title: Set-CustomAttributesForGroupMembers.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-CustomAttributesForGroupMembers/
categories:
  - UserAdminModule
  - ADFunctions
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

Sets custom extension attributes for all members of an AD group.

#### Detailed Description

This function updates extensionAttribute1-15 for all user members of a specified Active Directory group. Only attributes provided as parameters will be updated.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-CustomAttributesForGroupMembers -GroupName "HR Users" -extensionAttribute1 "Contractor" -extensionAttribute5 "2025"
```

**Example 2**

```powershell
"HR Users" | Set-CustomAttributesForGroupMembers -extensionAttribute2 "Remote"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires ActiveDirectory module and appropriate permissions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Sets custom extension attributes for all members of an AD group.

.DESCRIPTION
    This function updates extensionAttribute1-15 for all user members of a specified Active Directory group.
    Only attributes provided as parameters will be updated.

.PARAMETER GroupName
    The name (SamAccountName or distinguished name) of the AD group whose members will be updated.

.PARAMETER extensionAttribute1-15
    Values to set for the corresponding extension attributes.

.EXAMPLE
    Set-CustomAttributesForGroupMembers -GroupName "HR Users" -extensionAttribute1 "Contractor" -extensionAttribute5 "2025"

.EXAMPLE
    "HR Users" | Set-CustomAttributesForGroupMembers -extensionAttribute2 "Remote"

.NOTES
    Requires ActiveDirectory module and appropriate permissions.
#>
function Set-CustomAttributesForGroupMembers {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[\w\-\s,=]+$')]
        [string]$GroupName,

        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute1,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute2,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute3,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute4,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute5,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute6,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute7,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute8,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute9,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute10,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute11,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute12,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute13,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute14,
        [Parameter(Mandatory=$false)]
        [ValidateLength(0, 256)]
        [string]$extensionAttribute15
    )

    process {
        try {
            $members = Get-ADGroupMember -Identity $GroupName -Recursive -ErrorAction Stop | Where-Object { $_.objectClass -eq 'user' }
        } catch {
            Write-Error "Failed to get members for group '$GroupName': $_"
            return
        }

        foreach ($user in $members) {
            $attributes = @{}
            for ($i = 1; $i -le 15; $i++) {
                $attrValue = Get-Variable -Name "extensionAttribute$i" -ValueOnly -ErrorAction SilentlyContinue
                if ($attrValue) {
                    $attributes["extensionAttribute$i"] = $attrValue
                }
            }

            if ($attributes.Count -gt 0) {
                try {
                    if ($PSCmdlet.ShouldProcess($user.SamAccountName, "Set extension attributes")) {
                        Set-ADUser -Identity $user.SamAccountName -Replace $attributes -ErrorAction Stop
                        Write-Verbose "Updated $($user.SamAccountName) with attributes: $($attributes.Keys -join ', ')"
                        Write-Output $user.SamAccountName
                    }
                } catch {
                    Write-Error "Failed to update user '$($user.SamAccountName)': $_"
                }
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Set-CustomAttributesForGroupMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-CustomAttributesForGroupMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

