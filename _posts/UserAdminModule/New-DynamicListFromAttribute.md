---
layout: post
title: New-DynamicListFromAttribute.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/new-dynamiclistfromattribute/
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

Create a Dynamic Distribution Group (DDG) based on an attribute value.

#### Detailed Description

Creates a new Dynamic Distribution Group using an OPATH recipient filter that matches a specified attribute/value. Accepts either AD-style names (extensionAttribute1..15) or Exchange-style names (CustomAttribute1..15). Supports -Force to replace an existing group and -UseWildcard to use -like matching.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-DynamicListFromAttribute -Name 'DDG-Attr1-Yes' -AttributeName extensionAttribute1 -AttributeValue 'Yes'
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function New-DynamicListFromAttribute {
    <#
    .SYNOPSIS
    Create a Dynamic Distribution Group (DDG) based on an attribute value.

    .DESCRIPTION
    Creates a new Dynamic Distribution Group using an OPATH recipient filter that matches a specified attribute/value.
    Accepts either AD-style names (extensionAttribute1..15) or Exchange-style names (CustomAttribute1..15).
    Supports -Force to replace an existing group and -UseWildcard to use -like matching.

    .PARAMETER Name
    Name of the dynamic group to create.

    .PARAMETER AttributeName
    The attribute to test (e.g. extensionAttribute1 or CustomAttribute1).

    .PARAMETER AttributeValue
    The attribute value to match. If using -UseWildcard, you should supply a wildcard pattern (for example '*foo*').

    .PARAMETER RecipientTypeDetails
    Which recipient types to include (default 'UserMailbox').

    .PARAMETER AdditionalFilter
    Optional extra OPATH clause to AND onto the filter.

    .PARAMETER Force
    Replace an existing dynamic group of the same name.

    .PARAMETER UseWildcard
    Use -like instead of -eq for the attribute test.

    .PARAMETER Alias
    Optional mail alias to assign to the new group.

    .PARAMETER PrimarySmtpAddress
    Optional primary SMTP address for the new group.

    .EXAMPLE
    New-DynamicListFromAttribute -Name 'DDG-Attr1-Yes' -AttributeName extensionAttribute1 -AttributeValue 'Yes'

    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
            'extensionAttribute1','extensionAttribute2','extensionAttribute3','extensionAttribute4','extensionAttribute5',
            'extensionAttribute6','extensionAttribute7','extensionAttribute8','extensionAttribute9','extensionAttribute10',
            'extensionAttribute11','extensionAttribute12','extensionAttribute13','extensionAttribute14','extensionAttribute15',
            'CustomAttribute1','CustomAttribute2','CustomAttribute3','CustomAttribute4','CustomAttribute5',
            'CustomAttribute6','CustomAttribute7','CustomAttribute8','CustomAttribute9','CustomAttribute10',
            'CustomAttribute11','CustomAttribute12','CustomAttribute13','CustomAttribute14','CustomAttribute15'
        )]
        [string]$AttributeName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ if ($_ -is [string] -and ($_.Trim().Length -gt 0)) { return $true } if ($_ -is [bool]) { return $true } throw 'AttributeValue must be a non-empty string or boolean.' })]
        [Object]$AttributeValue,

        [Parameter()]
        [ValidateSet('UserMailbox','MailUser','MailContact','SharedMailbox','RoomMailbox','EquipmentMailbox')]
        [string]$RecipientTypeDetails = 'UserMailbox',

        [Parameter()]
        [string]$AdditionalFilter,

    
    [Parameter()]
    [ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')]
    [string]
    $PrimarySmtpAddress,

    [Parameter()]
    [ValidatePattern('^[a-zA-Z0-9_.-]+$')]
    [string]
    $Alias,

    [Parameter()]
    [ValidatePattern('^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')]
    [string]
    $Domain,

    # EmailAddresses parameter removed per request; only PrimarySmtpAddress is supported

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [switch]$UseWildcard
    )

    begin {
        # Normalize attribute name to Exchange OPATH attribute if extensionAttributeN was provided
        if ($AttributeName -match '^extensionAttribute(\d{1,2})$') {
            $num = $matches[1]
            $filterAttribute = "CustomAttribute$($num)"
        }
        else {
            $filterAttribute = $AttributeName
        }

        # Normalize the attribute value to a string for OPATH and escape single quotes
        if ($AttributeValue -is [bool]) { $rawValue = $AttributeValue.ToString() } else { $rawValue = [string]$AttributeValue }
        $escapedValue = $rawValue -replace "'", "''"

        # Choose operator
        $operator = if ($UseWildcard) { '-like' } else { '-eq' }

        # If UseWildcard is set but the value doesn't contain a wildcard, wrap it
        if ($UseWildcard -and ($escapedValue -notmatch '[\*%]')) { $escapedValue = "*$escapedValue*" }

        # Build the basic recipient filter using OPATH syntax
        $typeClause = "(RecipientTypeDetails -eq '$RecipientTypeDetails')"
        $attrClause = "($filterAttribute $operator '$escapedValue')"
        $recipientFilter = "($typeClause -and $attrClause)"

        if ($AdditionalFilter) {
            # Ensure additional clause is parenthesized and append
            $recipientFilter = "($recipientFilter -and ($AdditionalFilter))"
        }

        Write-Verbose "Using recipient filter: $recipientFilter"

        # If Alias and Domain provided but PrimarySmtpAddress not, generate it
        if (-not $PrimarySmtpAddress -and $Alias -and $Domain) {
            $gen = "$($Alias)@$($Domain)"
            if ($gen -match '^[^@\s]+@[^@\s]+\.[^@\s]+$') {
                $PrimarySmtpAddress = $gen
                Write-Verbose "Generated PrimarySmtpAddress from Alias and Domain: $PrimarySmtpAddress"

                # PrimarySmtpAddress generated from Alias+Domain if requested; EmailAddresses are not supported
            }
            else {
                Write-Warning "Generated PrimarySmtpAddress '$gen' did not pass basic validation; skipping generation."
            }
        }
    # EmailAddresses handling removed to avoid complex proxy/address manipulation
    }

    process {
        try {
            # Check for existing dynamic group
            $existing = Get-DynamicDistributionGroup -Identity $Name -ErrorAction SilentlyContinue

            if ($existing) {
                if ($Force) {
                    $actionDesc = "Remove existing dynamic distribution group '$Name'"
                    if ($PSCmdlet.ShouldProcess($Name, $actionDesc)) {
                        Remove-DynamicDistributionGroup -Identity $Name -Confirm:$false -ErrorAction Stop
                        Write-Verbose "Removed existing dynamic group '$Name'."
                    }
                }
                else {
                    throw "A dynamic distribution group named '$Name' already exists. Use -Force to replace it."
                }
            }

            # Create group (splat alias/addresses where supported)
            $actionDesc = "Create dynamic distribution group '$Name'"
            if ($PSCmdlet.ShouldProcess($Name, "$actionDesc` with filter: $recipientFilter")) {
                $newParams = @{ Name = $Name; RecipientFilter = $recipientFilter }
                if ($Alias) { $newParams.Alias = $Alias }
                # New-DynamicDistributionGroup may accept PrimarySmtpAddress/EmailAddresses depending on environment; try passing them
                if ($PrimarySmtpAddress) { $newParams.PrimarySmtpAddress = $PrimarySmtpAddress }
                if ($EmailAddresses) { $newParams.EmailAddresses = $EmailAddresses }

                $created = New-DynamicDistributionGroup @newParams -ErrorAction Stop
                Write-Verbose "Created dynamic group '$Name' with filter $recipientFilter."

                # ManagedBy handling removed; set ManagedBy manually with Set-DynamicDistributionGroup if required

                # Optionally set primary SMTP and proxy addresses
                if ($created) {
                        # Prepare parameters for Set-DynamicDistributionGroup (only PrimarySmtpAddress supported)
                        $setParams = @{}
                        if ($PrimarySmtpAddress) { $setParams.PrimarySmtpAddress = $PrimarySmtpAddress }

                    if ($setParams.Count -gt 0) {
                        $addrDesc = $setParams.Values -join ', '
                        $addrAction = "Set primary SMTP on '$Name' to: $addrDesc"
                        if ($PSCmdlet.ShouldProcess($Name, $addrAction)) {
                            try {
                                Set-DynamicDistributionGroup -Identity $created.Identity @setParams -ErrorAction Stop
                                Write-Verbose "Set primary SMTP for '$Name' to: $addrDesc"
                            }
                            catch {
                                Write-Warning "Failed to set primary SMTP on '$Name': $($_.Exception.Message)"
                            }
                        }
                    }
                }

                return $created
            }
        }
        catch {
            Write-Error "Failed to create dynamic group '$Name': $($_.Exception.Message)"
            return $null
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/New-DynamicListFromAttribute.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-DynamicListFromAttribute.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

