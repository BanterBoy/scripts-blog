---
layout: post
title: Get-ADGroupMembers.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-adgroupmembers/
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

Get-ADGroupMembers

#### Detailed Description

This function exports the users within Active Directory groups that match a specified search string.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADGroupMembers -GroupName "Domain Admins"
```

Outputs a list of users in the Active Directory groups matching the search string.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: 05/07/2023 Version: 0001 Changelog:

- initial version

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Get-ADGroupMembers

.DESCRIPTION
    This function exports the users within Active Directory groups that match a specified search string.

.PARAMETER GroupName
    Specifies the name of the group to search for. This parameter supports wildcards.

.EXAMPLE
    Get-ADGroupMembers -GroupName "Domain Admins"
    Outputs a list of users in the Active Directory groups matching the search string.

.NOTES
    Author: Luke Leigh
    Date: 05/07/2023
    Version: 0001
    Changelog:
        - initial version

.INPUTS
    [string]GroupName
#>
#requires -PSEdition Desktop
function Get-ADGroupMembers {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [String]$GroupName = '*'
    )

    begin {
        # Update-FormatData -PrependPath "$PSScriptRoot\Get-ADGroupMembers.Format.ps1xml"
    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            $groups = Get-ADGroup -Filter "Name -like '$GroupName'"
            foreach ($group in $groups) {
                $groupMembers = Get-ADGroupMember -Identity $group.SamAccountName
                foreach ($member in $groupMembers) {
                    if ($member.objectClass -eq "user") {
                        $user = Get-ADUser -Identity $member.SamAccountName -Properties *
                        Write-Output $user
                    }
                }
            }
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADGroupMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADGroupMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

