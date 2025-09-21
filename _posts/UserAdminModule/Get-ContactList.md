---
layout: post
title: Get-ContactList.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/get-contactlist/
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

Retrieves contact information for members of specified distribution groups.

#### Detailed Description

The Get-ContactList function retrieves contact information for members of one or more distribution groups. It returns a list of properties for each member, including their group name, group description, group SamAccountName, group managed by, group primary SMTP address, member name, member SamAccountName, member display name, member title, member company, member manager, member identity, member primary SMTP address, member external email address, member Windows email address, and member recipient type details.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ContactList -GroupName "Group1", "Group2"
```

Retrieves contact information for members of "Group1" and "Group2" distribution groups.

**Example 2**

```powershell
"Group1", "Group2" | Get-ContactList
```

Retrieves contact information for members of "Group1" and "Group2" distribution groups using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the Get-DistributionGroup and Get-DistributionGroupMember cmdlets.

- The function supports the Confirm and WhatIf parameters.

- For more information, visit the help URI: http://scripts.lukeleigh.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves contact information for members of specified distribution groups.

.DESCRIPTION
The Get-ContactList function retrieves contact information for members of one or more distribution groups. It returns a list of properties for each member, including their group name, group description, group SamAccountName, group managed by, group primary SMTP address, member name, member SamAccountName, member display name, member title, member company, member manager, member identity, member primary SMTP address, member external email address, member Windows email address, and member recipient type details.

.PARAMETER GroupName
Specifies the name(s) of the distribution group(s) to export. This parameter is mandatory and can accept multiple values.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject. The function outputs a PSObject for each member of the specified distribution group(s), containing the properties described above.

.NOTES
- This function requires the Get-DistributionGroup and Get-DistributionGroupMember cmdlets.
- The function supports the Confirm and WhatIf parameters.
- For more information, visit the help URI: http://scripts.lukeleigh.com/

.EXAMPLE
Get-ContactList -GroupName "Group1", "Group2"
Retrieves contact information for members of "Group1" and "Group2" distribution groups.

.EXAMPLE
"Group1", "Group2" | Get-ContactList
Retrieves contact information for members of "Group1" and "Group2" distribution groups using pipeline input.

#>

function Get-ContactList {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the name/s of the Distribution Group/s to export.')]
        [string[]]$GroupName
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $DistributionGroups = Get-DistributionGroup -Filter " Name -like '$GroupName' "  | Select-Object -Property Name, DisplayName, GroupType, PrimarySmtpAddress
            foreach ($DistributionGroup in $DistributionGroups) { 
                $Group = Get-DistributionGroup $($DistributionGroup.Name) | Select-Object -Property *
                $Members = Get-DistributionGroupMember -Identity $Group.Name
                foreach ($Member in $Members) {
                    try {
                        $properties = [ordered]@{
                            GroupName               = $Group.DisplayName
                            GroupDescription        = $Group.Description
                            GroupSamAccountName     = $Group.SamAccountName
                            GroupManagedBy          = $Group.ManagedBy
                            GroupPrimarySmtpAddress = $Group.PrimarySmtpAddress
                            MemberName              = $Member.Name
                            MemberSamAccountName    = $Member.SamAccountName
                            DisplayName             = $Member.DisplayName
                            Title                   = $Member.Title
                            Company                 = $Member.Company
                            Manager                 = $Member.Manager
                            Identity                = $Member.Identity
                            PrimarySmtpAddress      = $Member.PrimarySmtpAddress
                            ExternalEmailAddress    = $Member.ExternalEmailAddress
                            WindowsEmailAddress     = $Member.WindowsEmailAddress
                            RecipientTypeDetails    = $Member.RecipientTypeDetails
                        }
                    }
                    catch [System.Exception] {
                        Write-Error -Message $_
                    }
                    finally {
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                    }
                }
            }
        }
    }

    end {
    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-ContactList.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ContactList.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

