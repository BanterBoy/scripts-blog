---
layout: post
title: Get-O365SharedMailboxPermissions.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-O365SharedMailboxPermissions/
categories:
- UserAdminModule
- Exchange
tags:
- PowerShell
- User Admin Module
- O 365 Shared Mailbox Permissions
description: Retrieves permissions for Office 365 shared mailboxes.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Retrieves permissions for Office 365 shared mailboxes.

#### Detailed Description

The Get-O365SharedMailboxPermissions function retrieves permissions for Office 365 shared mailboxes. It queries the mailbox permissions for the specified shared mailbox owners and returns the relevant information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-O365SharedMailboxPermissions -SharedMailboxIdentity shared@contoso.com
```

Retrieves permissions for the shared mailbox with the identity 'shared@contoso.com'.

**Example 2**

```powershell
'shared1@contoso.com', 'shared2@contoso.com' | Get-O365SharedMailboxPermissions
```

Retrieves permissions for the shared mailboxes with the identities 'shared1@contoso.com' and 'shared2@contoso.com'.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves permissions for Office 365 shared mailboxes.

.DESCRIPTION
    The Get-O365SharedMailboxPermissions function retrieves permissions for Office 365 shared mailboxes. It queries the mailbox permissions for the specified shared mailbox owners and returns the relevant information.

.PARAMETER SharedMailboxIdentity
    Specifies the identity (name or email address) of the shared mailbox whose permissions you want to query. This parameter can accept multiple values and can be piped. If not specified, the function will retrieve permissions for all shared mailboxes.

.INPUTS
    None. You cannot pipe objects to this function.

.OUTPUTS
    System.String
    The function returns a string containing the shared mailbox permissions information.

.EXAMPLE
    Get-O365SharedMailboxPermissions -SharedMailboxIdentity shared@contoso.com
    Retrieves permissions for the shared mailbox with the identity 'shared@contoso.com'.

.EXAMPLE
    'shared1@contoso.com', 'shared2@contoso.com' | Get-O365SharedMailboxPermissions
    Retrieves permissions for the shared mailboxes with the identities 'shared1@contoso.com' and 'shared2@contoso.com'.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-O365SharedMailboxPermissions {

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
            HelpMessage = 'Enter the identity for the shared mailbox you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$SharedMailboxIdentity
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$SharedMailboxIdentity", "Querying shared mailbox permissions for")) {
            foreach ($Mailbox in $SharedMailboxIdentity) {
                try {
                    # Full Access permissions
                    $FullAccessPermissions = Get-MailboxPermission -Identity $Mailbox -ErrorAction Stop | Where-Object { $_.IsInherited -eq $false -and $_.AccessRights -contains 'FullAccess' }
                    foreach ($Permission in $FullAccessPermissions) {
                        [PSCustomObject]@{
                            MailboxIdentity   = $Mailbox
                            PermissionType    = 'FullAccess'
                            User              = $Permission.User.DisplayName
                            UserType          = $Permission.User.UserType
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send As permissions
                    $SendAsPermissions = Get-RecipientPermission -Identity $Mailbox -ErrorAction SilentlyContinue | Where-Object { $_.Trustee -ne $null -and $_.AccessRights -contains 'SendAs' }
                    foreach ($Permission in $SendAsPermissions) {
                        [PSCustomObject]@{
                            MailboxIdentity   = $Mailbox
                            PermissionType    = 'SendAs'
                            User              = $Permission.Trustee
                            UserType          = 'Unknown'
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send on Behalf permissions
                    $MailboxObj = Get-Mailbox -Identity $Mailbox -ErrorAction SilentlyContinue
                    if ($MailboxObj -and $MailboxObj.GrantSendOnBehalfTo) {
                        foreach ($User in $MailboxObj.GrantSendOnBehalfTo) {
                            [PSCustomObject]@{
                                MailboxIdentity   = $Mailbox
                                PermissionType    = 'SendOnBehalf'
                                User              = $User
                                UserType          = 'Unknown'
                                AccessRights      = 'Send on Behalf'
                            }
                        }
                    }
                } catch {
                    Write-Warning "Could not retrieve permissions for mailbox: $Mailbox. $_"
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-O365SharedMailboxPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-O365SharedMailboxPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

