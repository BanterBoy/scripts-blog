---
layout: post
title: Copy-DistributionGroupMembers.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/copy-distributiongroupmembers/
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

Copies missing members from one Distribution Group to another and optionally removes extra members.

#### Detailed Description

This function retrieves all members of the source Distribution Group and compares them to the members of the destination Distribution Group. Any members that are not already in the destination group are added. The function accepts the source group identity via pipeline input and takes the destination group as a parameter.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DistributionGroup -Identity "SourceGroup" | Copy-DistributionGroupMembers -DestinationGroup "DestinationGroup"
```

This example retrieves the group "SourceGroup" and pipes its identity into the function to add any missing members to "DestinationGroup".

**Example 2**

```powershell
Get-DistributionGroup -Identity "SourceGroup" | Copy-DistributionGroupMembers -DestinationGroup "DestinationGroup" -RemoveExtraMembers
```

This example retrieves the group "SourceGroup" and pipes its identity into the function to add any missing members to "DestinationGroup" and remove any extra members from "DestinationGroup".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

For Active Directory groups, replace Get-DistributionGroupMember / Add-DistributionGroupMember with Get-ADGroupMember / Add-ADGroupMember accordingly.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Copies missing members from one Distribution Group to another and optionally removes extra members.

.DESCRIPTION
    This function retrieves all members of the source Distribution Group and compares them to the members 
    of the destination Distribution Group. Any members that are not already in the destination group are added.
    The function accepts the source group identity via pipeline input and takes the destination group as a parameter.

.PARAMETER SourceGroup
    The identity of the source Distribution Group. Accepts pipeline input.

.PARAMETER DestinationGroup
    The identity of the destination Distribution Group.

.PARAMETER RemoveExtraMembers
    Switch to remove members from the destination group that are not in the source group.

.EXAMPLE
    Get-DistributionGroup -Identity "SourceGroup" | Copy-DistributionGroupMembers -DestinationGroup "DestinationGroup"

    This example retrieves the group "SourceGroup" and pipes its identity into the function to add any missing 
    members to "DestinationGroup".

.EXAMPLE
    Get-DistributionGroup -Identity "SourceGroup" | Copy-DistributionGroupMembers -DestinationGroup "DestinationGroup" -RemoveExtraMembers

    This example retrieves the group "SourceGroup" and pipes its identity into the function to add any missing 
    members to "DestinationGroup" and remove any extra members from "DestinationGroup".

.NOTES
    For Active Directory groups, replace Get-DistributionGroupMember / Add-DistributionGroupMember with 
    Get-ADGroupMember / Add-ADGroupMember accordingly.
#>

function Copy-DistributionGroupMembers {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Accepts pipeline input for the source group identity (e.g. group name, alias or distinguished name)
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$SourceGroup,
        
        # Destination group identity (e.g. group name, alias or distinguished name)
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$DestinationGroup,

        # Switch to remove members from the destination group that are not in the source group
        [Parameter(Mandatory = $false)]
        [switch]$RemoveExtraMembers
    )

    begin {
        $results = @()
        # Retrieve the current members of the destination group for a quick lookup.
        try {
            $destinationMembers = Get-DistributionGroupMember -Identity $DestinationGroup -ErrorAction Stop
            $destinationEmails = $destinationMembers | ForEach-Object {
                $_.PrimarySmtpAddress.ToString().ToLower()
            }
        }
        catch {
            Write-Error "Failed to retrieve members of destination group '$DestinationGroup'. Error: $_"
            return
        }
    }

    process {
        # Retrieve members of the source group
        try {
            $sourceMembers = Get-DistributionGroupMember -Identity $SourceGroup -ErrorAction Stop
            $sourceEmails = $sourceMembers | ForEach-Object {
                $_.PrimarySmtpAddress.ToString().ToLower()
            }
        }
        catch {
            Write-Error "Failed to retrieve members of source group '$SourceGroup'. Error: $_"
            return
        }

        foreach ($member in $sourceMembers) {
            $memberEmail = $member.PrimarySmtpAddress.ToString().ToLower()

            if (-not $memberEmail) {
                Write-Verbose "Skipping member '$($member.Name)' as no PrimarySmtpAddress was found."
                continue
            }

            # Add the member if not already present in the destination group
            if (-not ($destinationEmails -contains $memberEmail)) {
                if ($PSCmdlet.ShouldProcess("$DestinationGroup", "Add $($member.Name) ($memberEmail)")) {
                    try {
                        Add-DistributionGroupMember -Identity $DestinationGroup -Member $member.Identity -ErrorAction Stop
                        Write-Verbose "Added '$($member.Name)' to '$DestinationGroup'."
                        $results += [PSCustomObject]@{
                            Action = "Added"
                            Member = $member.Name
                            Email  = $memberEmail
                        }
                    }
                    catch {
                        Write-Warning "Failed to add '$($member.Name)' to '$DestinationGroup'. Error: $_"
                    }
                }
            }
            else {
                Write-Verbose "'$($member.Name)' is already a member of '$DestinationGroup'."
            }
        }

        if ($RemoveExtraMembers) {
            foreach ($member in $destinationMembers) {
                $memberEmail = $member.PrimarySmtpAddress.ToString().ToLower()

                if (-not ($sourceEmails -contains $memberEmail)) {
                    if ($PSCmdlet.ShouldProcess("$DestinationGroup", "Remove $($member.Name) ($memberEmail)")) {
                        try {
                            Remove-DistributionGroupMember -Identity $DestinationGroup -Member $member.Identity -ErrorAction Stop
                            Write-Verbose "Removed '$($member.Name)' from '$DestinationGroup'."
                            $results += [PSCustomObject]@{
                                Action = "Removed"
                                Member = $member.Name
                                Email  = $memberEmail
                            }
                        }
                        catch {
                            Write-Warning "Failed to remove '$($member.Name)' from '$DestinationGroup'. Error: $_"
                        }
                    }
                }
            }
        }
    }

    end {
        $results
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Copy-DistributionGroupMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-DistributionGroupMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

