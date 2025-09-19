---
layout: post
title: Get-O365MailboxPermissions.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-O365MailboxPermissions/
categories:
  - UserAdminModule
  - Exchange
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

Retrieves mailbox permissions for Office 365 mailboxes.

#### Detailed Description

The Get-O365MailboxPermissions function retrieves mailbox permissions for Office 365 mailboxes. It queries the mailbox permissions for the specified mailbox owners and returns the relevant information.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-O365MailboxPermissions -UserPrincipalName user1@contoso.com
```

Retrieves mailbox permissions for the mailbox owner with the UserPrincipalName 'user1@contoso.com'.

**Example 2**

```powershell
'user1@contoso.com', 'user2@contoso.com' | Get-O365MailboxPermissions
```

Retrieves mailbox permissions for the mailbox owners with the UserPrincipalNames 'user1@contoso.com' and 'user2@contoso.com'.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves mailbox permissions for Office 365 mailboxes.

.DESCRIPTION
    The Get-O365MailboxPermissions function retrieves mailbox permissions for Office 365 mailboxes. It queries the mailbox permissions for the specified mailbox owners and returns the relevant information.

.PARAMETER UserPrincipalName
    Specifies the UserPrincipalName for the mailbox owner whose mailbox permissions you want to query. This parameter can accept multiple values and can be piped. If not specified, the function will retrieve mailbox permissions for all mailbox owners.

.INPUTS
    None. You cannot pipe objects to this function.

.OUTPUTS
    System.String
    The function returns a string containing the mailbox permissions information.

.EXAMPLE
    Get-O365MailboxPermissions -UserPrincipalName user1@contoso.com
    Retrieves mailbox permissions for the mailbox owner with the UserPrincipalName 'user1@contoso.com'.

.EXAMPLE
    'user1@contoso.com', 'user2@contoso.com' | Get-O365MailboxPermissions
    Retrieves mailbox permissions for the mailbox owners with the UserPrincipalNames 'user1@contoso.com' and 'user2@contoso.com'.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-O365MailboxPermissions {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,

            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the mailbox owner whose mailbox you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserPrincipalName
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Querying mailbox permissions for")) {
            foreach ($User in $UserPrincipalName) {
                try {
                    # Full Access permissions
                    $FullAccessPermissions = Get-MailboxPermission -Identity $User -ErrorAction Stop | Where-Object { $_.IsInherited -eq $false -and $_.AccessRights -contains 'FullAccess' }
                    foreach ($Permission in $FullAccessPermissions) {
                        $userDisplay = $Permission.User.DisplayName
                        if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                            $userDisplay = $Permission.User
                        }
                        [PSCustomObject]@{
                            MailboxOwner      = $User
                            PermissionType    = 'FullAccess'
                            User              = $userDisplay
                            UserType          = $Permission.User.UserType
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send As permissions
                    $SendAsPermissions = Get-RecipientPermission -Identity $User -ErrorAction SilentlyContinue | Where-Object { $_.Trustee -ne $null -and $_.AccessRights -contains 'SendAs' }
                    foreach ($Permission in $SendAsPermissions) {
                        $userDisplay = $Permission.Trustee
                        if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                            $userDisplay = $Permission.Trustee
                        }
                        [PSCustomObject]@{
                            MailboxOwner      = $User
                            PermissionType    = 'SendAs'
                            User              = $userDisplay
                            UserType          = 'Unknown'
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send on Behalf permissions
                    $MailboxObj = Get-Mailbox -Identity $User -ErrorAction SilentlyContinue
                    if ($MailboxObj -and $MailboxObj.GrantSendOnBehalfTo) {
                        foreach ($Delegate in $MailboxObj.GrantSendOnBehalfTo) {
                            $userDisplay = $Delegate
                            if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                                $userDisplay = $Delegate
                            }
                            [PSCustomObject]@{
                                MailboxOwner      = $User
                                PermissionType    = 'SendOnBehalf'
                                User              = $userDisplay
                                UserType          = 'Unknown'
                                AccessRights      = 'Send on Behalf'
                            }
                        }
                    }
                } catch {
                    Write-Warning "Could not retrieve permissions for mailbox: $User. $_"
                }
            }
        }
    }

    end {
        
    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-O365MailboxPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-O365MailboxPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

