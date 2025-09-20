---
layout: post
title: Get-AdminGroupsWithComputers.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-AdminGroupsWithComputers/
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

Retrieves Active Directory groups matching a filter (default "*admin*") and checks for computer accounts as members.

#### Detailed Description

This function queries Active Directory for groups that match a specified name filter and examines their members to identify computer accounts. It can return:

- A detailed list of groups with counts of computer members.

- A minimal view showing only group names and members.

- A summary report with overall counts and the names of groups containing computers.

The function supports parameter sets:

- List (default): Returns group details with optional computer members.

- Summary: Returns only a summary object with statistics and group names containing computers.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-AdminGroupsWithComputers
```

Returns all groups with "*admin*" in the name and their counts of computer members.

**Example 2**

```powershell
PS C:\> Get-AdminGroupsWithComputers -IncludeMembers
```

Returns all groups with "*admin*" in the name and the full list of computer members.

**Example 3**

```powershell
PS C:\> Get-AdminGroupsWithComputers -Minimal -IncludeMembers
```

Returns a simplified view with just GroupName and ComputerMembers.

**Example 4**

```powershell
PS C:\> Get-AdminGroupsWithComputers -Summary
```

Returns only a summary with total counts and the names of groups containing computer accounts.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author  : Luke's Automation Helper (ChatGPT) Requires: ActiveDirectory module (RSAT). Version : 1.2

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-AdminGroupsWithComputers {
<#
.SYNOPSIS
    Retrieves Active Directory groups matching a filter (default "*admin*") and checks for computer accounts as members.

.DESCRIPTION
    This function queries Active Directory for groups that match a specified name filter and examines their members 
    to identify computer accounts. It can return:
        - A detailed list of groups with counts of computer members.
        - A minimal view showing only group names and members.
        - A summary report with overall counts and the names of groups containing computers.

    The function supports parameter sets:
        - List (default): Returns group details with optional computer members.
        - Summary: Returns only a summary object with statistics and group names containing computers.

.PARAMETER Domain
    The Active Directory domain to query.
    Defaults to the current domain of the user.

.PARAMETER GroupNameFilter
    A string filter for matching group names.
    Default is "*admin*".

.PARAMETER IncludeMembers
    When used in List mode, includes the names of computer accounts in the output.

.PARAMETER Minimal
    When used in List mode, returns only the group name and computer members (if requested) for a simpler view.

.PARAMETER Summary
    Switches to Summary mode.
    Returns only the number of groups scanned, the number of groups containing computers, the total number of computer accounts, 
    and the list of group names that contain computer accounts.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers

    Returns all groups with "*admin*" in the name and their counts of computer members.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -IncludeMembers

    Returns all groups with "*admin*" in the name and the full list of computer members.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -Minimal -IncludeMembers

    Returns a simplified view with just GroupName and ComputerMembers.

.EXAMPLE
    PS C:\> Get-AdminGroupsWithComputers -Summary

    Returns only a summary with total counts and the names of groups containing computer accounts.

.NOTES
    Author  : Luke's Automation Helper (ChatGPT)
    Requires: ActiveDirectory module (RSAT).
    Version : 1.2

#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Summary', Mandatory = $false)]
        [string]$Domain = (Get-ADDomain).DNSRoot,

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Summary', Mandatory = $false)]
        [string]$GroupNameFilter = "*admin*",

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$IncludeMembers,

        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$Minimal,

        [Parameter(ParameterSetName = 'Summary', Mandatory = $true)]
        [switch]$Summary
    )

    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Throw "The ActiveDirectory module is not installed or available."
    }

    $DomAdminGroups = Get-ADGroup -Filter { Name -like $GroupNameFilter } -Server $Domain
    $DomAdminGroupsCount = $DomAdminGroups.Count

    Write-Verbose "Scanning $DomAdminGroupsCount admin-related groups in $Domain for computer accounts as members..."

    $Results = @()
    [int]$TotalComputers = 0
    [int]$GroupsWithComputers = 0
    $GroupsWithComputersList = @()

    foreach ($DomAdminGroupsItem in $DomAdminGroups) {
        $GroupName = $DomAdminGroupsItem.Name
        $DistinguishedName = $DomAdminGroupsItem.DistinguishedName
        $ComputerNames = @()

        try {
            $ComputerNames = Get-ADGroupMember -Identity $DistinguishedName -Recursive -ErrorAction Stop |
                             Where-Object { $_.objectClass -eq "computer" } |
                             ForEach-Object { $_.Name }
        }
        catch {
            Write-Warning "Get-ADGroupMember failed for group '$GroupName': $($_.Exception.Message)"
            Write-Verbose "Attempting fallback via 'member' attribute..."

            try {
                $Members = (Get-ADGroup -Identity $DistinguishedName -Properties member -ErrorAction Stop).member
                if ($Members) {
                    $ComputerNames = $Members |
                        ForEach-Object {
                            try {
                                $obj = Get-ADObject -Identity $_ -ErrorAction SilentlyContinue
                                if ($obj.ObjectClass -eq 'computer') { $obj.Name }
                            } catch { }
                        }
                }
            }
            catch {
                Write-Warning "Fallback also failed for group '$GroupName': $($_.Exception.Message)"
            }
        }

        [int]$ComputerCount = $ComputerNames.Count
        $TotalComputers += $ComputerCount

        if ($ComputerCount -gt 0) {
            $GroupsWithComputers++
            $GroupsWithComputersList += $GroupName
        }

        if ($PSCmdlet.ParameterSetName -eq 'List') {
            if ($Minimal) {
                $Results += [PSCustomObject]@{
                    GroupName       = $GroupName
                    ComputerMembers = if ($IncludeMembers) { $ComputerNames } else { $null }
                }
            }
            else {
                $Results += [PSCustomObject]@{
                    GroupName         = $GroupName
                    DistinguishedName = $DistinguishedName
                    ComputerCount     = $ComputerCount
                    ComputerMembers   = if ($IncludeMembers) { $ComputerNames } else { $null }
                }
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Summary') {
        return [PSCustomObject]@{
            GroupsScanned        = $DomAdminGroupsCount
            GroupsWithComputers  = $GroupsWithComputers
            TotalComputers       = $TotalComputers
            GroupsList           = $GroupsWithComputersList
        }
    }
    else {
        return $Results
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-AdminGroupsWithComputers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AdminGroupsWithComputers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

