---
layout: post
title: Get-ADGroupNesting.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
<#

  This script retrieves an AD group with 2 additional properties:
  - NestedGroupMembershipCount
  - MaxNestingLevel

  This helps us to understand the maximum nesting levels of groups and the recursive group membership count.

  Original script written by M Ali.
   - Token Bloat Troubleshooting by Analyzing Group Nesting in AD
     http://blogs.msdn.com/b/adpowershell/archive/2009/09/05/token-bloat-troubleshooting-by-analyzing-group-nesting-in-ad.aspx

  Usage:
    Get-ADGroupNesting.ps1 CarAnnounce
    Get-ADGroupNesting.ps1 CarAnnounce -showtree

    When used with the ShowTree parameter, the script displays the recursive group membership tree along with emitting the ADGroup object.
    When using a group name that contains a space use single quotes around the name.

#>

#-------------------------------------------------------------

Param (
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "DN or ObjectGUID of the AD Group."
    )]
    [string]$groupIdentity,
    [switch]$showTree
)

$global:numberOfRecursiveGroupMemberships = 0
$lastGroupAtALevelFlags = @()

# Import the Active Directory Module
Import-Module ActiveDirectory -WarningAction SilentlyContinue
if ($Error.Count -eq 0) {
    Write-Host "Successfully loaded Active Directory Powershell's module" -ForeGroundColor Green
}
else {
    Write-Host "Error while loading Active Directory Powershell's module : $Error" -ForeGroundColor Red
    exit
}

function Get-GroupNesting ([string] $identity, [int] $level, [hashtable] $groupsVisitedBeforeThisOne, [bool] $lastGroupOfTheLevel) {
    $group = $null
    $group = Get-ADGroup -Identity $identity -Properties "memberOf"
    if ($lastGroupAtALevelFlags.Count -le $level) {
        $lastGroupAtALevelFlags = $lastGroupAtALevelFlags + 0
    }
    if ($null -ne $group) {
        if ($showTree) {
            for ($i = 0; $i -lt $level - 1; $i++) {
                if ($lastGroupAtALevelFlags[$i] -ne 0) {
                    Write-Host -ForegroundColor Yellow -NoNewline "  "
                }
                else {
                    Write-Host -ForegroundColor Yellow -NoNewline "� "
                }
            }
            if ($level -ne 0) {
                if ($lastGroupOfTheLevel) {
                    Write-Host -ForegroundColor Yellow -NoNewline "+-"
                }
                else {
                    Write-Host -ForegroundColor Yellow -NoNewline "+-"
                }
            }
            Write-Host -ForegroundColor Yellow $group.Name
        }
        $groupsVisitedBeforeThisOne.Add($group.distinguishedName, $null)
        $global:numberOfRecursiveGroupMemberships ++
        $groupMemberShipCount = $group.memberOf.Count
        if ($groupMemberShipCount -gt 0) {
            $maxMemberGroupLevel = 0
            $count = 0
            foreach ($groupDN in $group.memberOf) {
                $count++
                $lastGroupOfThisLevel = $false
                if ($count -eq $groupMemberShipCount) { $lastGroupOfThisLevel = $true; $lastGroupAtALevelFlags[$level] = 1 }
                if (-not $groupsVisitedBeforeThisOne.Contains($groupDN)) {
                    #prevent cyclic dependancies
                    $memberGroupLevel = Get-GroupNesting -Identity $groupDN -Level $($level + 1) -GroupsVisitedBeforeThisOne $groupsVisitedBeforeThisOne -lastGroupOfTheLevel $lastGroupOfThisLevel
                    if ($memberGroupLevel -gt $maxMemberGroupLevel) { $maxMemberGroupLevel = $memberGroupLevel }
                }
            }
            $level = $maxMemberGroupLevel
        }
        else {
            #we've reached the top level group, return it's height
            return $level
        }
        return $level
    }
}
$global:numberOfRecursiveGroupMemberships = 0
$groupObj = $null
$groupObj = Get-ADGroup -Identity $groupIdentity
if ($groupObj) {
    [int]$maxNestingLevel = Get-GroupNesting -Identity $groupIdentity -Level 0 -GroupsVisitedBeforeThisOne @{} -lastGroupOfTheLevel $false
    Add-Member -InputObject $groupObj -MemberType NoteProperty  -Name MaxNestingLevel -Value $maxNestingLevel -Force
    Add-Member -InputObject $groupObj -MemberType NoteProperty  -Name NestedGroupMembershipCount -Value $($global:numberOfRecursiveGroupMemberships - 1) -Force
    $groupObj
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-ADGroupNesting.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADGroupNesting.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
