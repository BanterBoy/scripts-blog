---
layout: post
title: New-AzureADDynamicGroup.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/azure/new-azureaddynamicgroup/
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

Creates a new Azure AD dynamic group if it does not already exist.

#### Detailed Description

The `New-AzureADDynamicGroup` function connects to Microsoft Graph using the required permissions and checks if a group with the specified name already exists in Azure AD. If the group does not exist, it creates a new dynamic group with the provided membership rule. If the group already exists, it outputs a message indicating so.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-AzureADDynamicGroup -GroupName "DynamicGroup1" -MembershipRule "(user.department -eq 'Sales')"
```

This example creates a new Azure AD dynamic group named "DynamicGroup1" with a membership rule that includes users whose department is "Sales".

**Example 2**

```powershell
$GroupName = "Test Dynamic Group"
```

$MembershipRule = "(device.devicePhysicalIds -any _ -eq 'abc')" New-AzureADDynamicGroup -GroupName $GroupName -MembershipRule $MembershipRule This example creates a new Azure AD dynamic group named "Test Dynamic Group" with a membership rule that includes devices with a specific physical ID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the Microsoft Graph PowerShell module (`Microsoft.Graph`) to be installed and imported.

- The function uses the `Connect-MgGraph` cmdlet to authenticate with Microsoft Graph. Ensure you have the necessary permissions to create groups in Azure AD.

- The required permissions are:

- `Group.ReadWrite.All`

- `GroupMember.ReadWrite.All`

- `User.ReadWrite.All`

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates a new Azure AD dynamic group if it does not already exist.

.DESCRIPTION
The `New-AzureADDynamicGroup` function connects to Microsoft Graph using the required permissions and checks if a group with the specified name already exists in Azure AD. 
If the group does not exist, it creates a new dynamic group with the provided membership rule. If the group already exists, it outputs a message indicating so.

.PARAMETER GroupName
The name of the Azure AD group to create. This parameter is mandatory.

.PARAMETER MembershipRule
The membership rule that defines the dynamic membership criteria for the group. This parameter is mandatory.

.EXAMPLE
New-AzureADDynamicGroup -GroupName "DynamicGroup1" -MembershipRule "(user.department -eq 'Sales')"

This example creates a new Azure AD dynamic group named "DynamicGroup1" with a membership rule that includes users whose department is "Sales".

.EXAMPLE
$GroupName = "Test Dynamic Group"
$MembershipRule = "(device.devicePhysicalIds -any _ -eq 'abc')"
New-AzureADDynamicGroup -GroupName $GroupName -MembershipRule $MembershipRule

This example creates a new Azure AD dynamic group named "Test Dynamic Group" with a membership rule that includes devices with a specific physical ID.

.NOTES
- This function requires the Microsoft Graph PowerShell module (`Microsoft.Graph`) to be installed and imported.
- The function uses the `Connect-MgGraph` cmdlet to authenticate with Microsoft Graph. Ensure you have the necessary permissions to create groups in Azure AD.
- The required permissions are:
  - `Group.ReadWrite.All`
  - `GroupMember.ReadWrite.All`
  - `User.ReadWrite.All`

#>
function New-AzureADDynamicGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,

        [Parameter(Mandatory = $true)]
        [string]$MembershipRule
    )

    # Permissions for connection
    $RequiredScopes = @("Group.ReadWrite.All", "GroupMember.ReadWrite.All", "User.ReadWrite.All")
    Connect-MgGraph -Scopes $RequiredScopes

    # Check if the group already exists
    $group = Get-MgGroup -Filter "displayName eq '$GroupName'"

    if ($null -eq $group) {
        # Group does not exist, create it
        Write-Output "Group with name: $GroupName does not exist!"
        $GroupParam = @{
            DisplayName                   = $GroupName
            GroupTypes                    = @('DynamicMembership')
            SecurityEnabled               = $true
            IsAssignableToRole            = $false
            MailEnabled                   = $false
            membershipRuleProcessingState = 'On'
            MembershipRule                = $MembershipRule
            MailNickname                  = (New-Guid).Guid.Substring(0, 10)
            "Owners@odata.bind"           = @("https://graph.microsoft.com/v1.0/me")
        }

        New-MgGroup -BodyParameter $GroupParam
        Write-Output "Group created with name: $GroupName"
    }
    else {
        # Group already exists, show a message
        Write-Output "Group already exists with name: $GroupName"
    }
   
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/New-AzureADDynamicGroup.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-AzureADDynamicGroup.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

