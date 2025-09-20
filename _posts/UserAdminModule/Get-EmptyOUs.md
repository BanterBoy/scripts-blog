---
layout: post
title: Get-EmptyOUs.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/get-emptyous/
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

Retrieves and optionally removes empty Active Directory Organizational Units (OUs).

#### Detailed Description

The Get-EmptyOUs function retrieves all organizational units (OUs) in Active Directory and checks if they are empty. It can optionally remove the empty OUs if specified.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-EmptyOUs -RemoveOUs $false
```

Retrieves and lists the distinguished names (DNs) of the empty OUs without removing them.

**Example 2**

```powershell
Get-EmptyOUs -RemoveOUs $true -OUsToKeep "OU=TestOU,DC=example,DC=com"
```

Retrieves and removes the empty OUs, excluding the OU with the specified distinguished name.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Active Directory module to be installed. It should be run with appropriate permissions to manage OUs in Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves and optionally removes empty Active Directory Organizational Units (OUs).

.DESCRIPTION
    The Get-EmptyOUs function retrieves all organizational units (OUs) in Active Directory and checks if they are empty.
    It can optionally remove the empty OUs if specified.

.PARAMETER RemoveOUs
    Specifies whether to remove the empty OUs. If set to $true, the empty OUs will be removed. If set to $false, the empty OUs will be listed but not removed. Default is $false.

.PARAMETER OUsToKeep
    Specifies an array of distinguished names (DNs) of OUs to exclude from removal. These OUs will be skipped even if they are empty.

.OUTPUTS
    If RemoveOUs is set to $false, the function outputs the distinguished names (DNs) of the empty OUs.
    If RemoveOUs is set to $true, the function outputs the total number of empty OUs removed and the total number of empty OUs found.

.EXAMPLE
    Get-EmptyOUs -RemoveOUs $false
    Retrieves and lists the distinguished names (DNs) of the empty OUs without removing them.

.EXAMPLE
    Get-EmptyOUs -RemoveOUs $true -OUsToKeep "OU=TestOU,DC=example,DC=com"
    Retrieves and removes the empty OUs, excluding the OU with the specified distinguished name.

.NOTES
    This function requires the Active Directory module to be installed. It should be run with appropriate permissions to manage OUs in Active Directory.
#>

function Get-EmptyOUs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [bool]$RemoveOUs = $false,
        [Parameter(Mandatory = $false)]
        [string[]]$OUsToKeep = @()
    )

    # Rest of the code...
}
function Get-EmptyOUs {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [bool]$RemoveOUs = $false,
        [Parameter(Mandatory = $false)]
        [string[]]$OUsToKeep = @()
    )


    function Get-AdOrganizationalUnits {
        Get-ADObject -Filter "ObjectClass -eq 'organizationalUnit'" | Where-Object { $_.DistinguishedName -notlike '*LostAndFound*' }
    }
    
    function Get-EmptyAdOrganizationalUnits($ad_ous) {
        $aOuDns = @()
        foreach ($o in $ad_ous) {
            $sDn = $o.DistinguishedName
            if ($sDn -like '*OU=*') {
                $sOuDn = $sDn.Substring($sDn.IndexOf('OU='))
                $aOuDns += $sOuDn
            }
        }
    
        $a0CountOus = $aOuDns | Group-Object | Where-Object { $_.Count -eq 1 } | ForEach-Object { $_.Name }
        return $a0CountOus
    }
    
    function IsAdOrganizationalUnitEmpty($ou_dn) {
        $child_objects = Get-ADObject -Filter "ObjectClass -ne 'organizationalUnit'" -SearchBase $ou_dn -SearchScope OneLevel -Properties ObjectClass
        $child_ous = Get-ADObject -Filter "ObjectClass -eq 'organizationalUnit'" -SearchBase $ou_dn -SearchScope OneLevel -Properties ObjectClass
        return ($child_objects.Count -eq 0 -and $child_ous.Count -eq 0)
    }
    
    function RemoveAdOrganizationalUnit($ou_dn) {
        Set-ADOrganizationalUnit -Identity $ou_dn -ProtectedFromAccidentalDeletion $false -confirm:$false
        Remove-AdOrganizationalUnit -Identity $ou_dn -confirm:$false
    }

    $ad_ous = Get-AdOrganizationalUnits
    $a0CountOus = Get-EmptyAdOrganizationalUnits $ad_ous
    $empty_ous = 0
    $ous_removed = 0
    foreach ($sOu in $a0CountOus) {
        if (IsAdOrganizationalUnitEmpty $sOu) {
            $ou_dn = (Get-AdObject -Filter { DistinguishedName -eq $sOu }).DistinguishedName
            if ($OUsToKeep -notcontains $ou_dn) {
                if ($RemoveOUs) {
                    RemoveAdOrganizationalUnit $ou_dn
                    $ous_removed++
                }
                else {
                    Write-Output $ou_dn
                }
                $empty_ous++
            }
        }
    }

    if ($empty_ous -gt 0) {
        Write-Output '-------------------'
        Write-Output "Total Empty OUs Removed: $ous_removed"
        Write-Output "Total Empty OUs: $empty_ous"
    }
    else {
        Write-Output 'No empty OUs found.'
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-EmptyOUs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-EmptyOUs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

