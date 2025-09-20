---
layout: post
title: Set-O365MailboxPermissions.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-O365MailboxPermissions/
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

Sets or removes permissions for a user on an Office 365 mailbox (Exchange Online).

#### Detailed Description

This function allows you to set or remove FullAccess or SendAs permissions for a user on an Office 365 mailbox using Exchange Online cmdlets. It supports adding, updating, or removing these permissions only.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-O365MailboxPermissions -Owner 'owner@domain.com' -User 'user@domain.com' -AccessLevel FullAccess -Verbose
```

This example grants FullAccess permission to 'user@domain.com' on the mailbox owned by 'owner@domain.com'.

**Example 2**

```powershell
Set-O365MailboxPermissions -Owner 'owner@domain.com' -User 'user@domain.com' -AccessLevel SendAs -Remove -Verbose
```

This example removes the SendAs permission for 'user@domain.com' on the mailbox owned by 'owner@domain.com'.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Last Edit: 2025-09-04

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-O365MailboxPermissions {
    <#
    .SYNOPSIS
        Sets or removes permissions for a user on an Office 365 mailbox (Exchange Online).

    .DESCRIPTION
        This function allows you to set or remove FullAccess or SendAs permissions for a user on an Office 365 mailbox using Exchange Online cmdlets. It supports adding, updating, or removing these permissions only.

    .PARAMETER Owner
        The UserPrincipalName of the mailbox owner whose mailbox you want to modify. This parameter can be piped.

    .PARAMETER User
        The UserPrincipalName of the user who will be granted access to the mailbox. This parameter can be piped.

    .PARAMETER AccessLevel
        The access level to grant to the user. Valid values are FullAccess, SendAs. This parameter can be piped.

    .PARAMETER Update
        Update the permissions for the user named in User. If this parameter is not used, the permissions for the user named in User will be added.

    .PARAMETER Remove
        Remove the permissions for the user named in User. If this parameter is used, the permissions for the user named in User will be removed.

    .EXAMPLE
        Set-O365MailboxPermissions -Owner 'owner@domain.com' -User 'user@domain.com' -AccessLevel FullAccess -Verbose
        This example grants FullAccess permission to 'user@domain.com' on the mailbox owned by 'owner@domain.com'.

    .EXAMPLE
        Set-O365MailboxPermissions -Owner 'owner@domain.com' -User 'user@domain.com' -AccessLevel SendAs -Remove -Verbose
        This example removes the SendAs permission for 'user@domain.com' on the mailbox owned by 'owner@domain.com'.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2025-09-04

    .LINK
        http://scripts.lukeleigh.com/
    #>

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
            HelpMessage = 'Enter the UserPrincipalName for the mailbox owner whose mailbox you want to modify. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string]$Owner,

        [Parameter(ParameterSetName = 'Default',    
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the user who will be granted access to the mailbox. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string]$User,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the access level to grant to the user. Valid values are FullAccess, SendAs. This parameter can be piped.')]
        [ValidateSet('FullAccess', 'SendAs')]
        [string]$AccessLevel,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Update the permissions for the user named in User. This parameter can be piped. If this parameter is not used, the permissions for the user named in User will be added.')]
        [bool]$Update = $false,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Remove the permissions for the user named in User. This parameter can be piped. If this parameter is used, the permissions for the user named in User will be removed.')]
        [bool]$Remove = $false
    )

    begin {
        Write-Verbose "Starting Set-O365MailboxPermissions function"
    }

    process {
        if ($PSCmdlet.ShouldProcess("$Owner", "Set permissions for $User to $AccessLevel")) {
            try {
                if ($Remove -eq $true) {
                    Write-Verbose "Removing $AccessLevel permissions for $User on $Owner's mailbox"
                    if ($AccessLevel -eq 'FullAccess') {
                        Remove-MailboxPermission -Identity $Owner -User $User -AccessRights FullAccess -Confirm:$false -ErrorAction Stop
                    } elseif ($AccessLevel -eq 'SendAs') {
                        Remove-RecipientPermission -Identity $Owner -Trustee $User -AccessRights SendAs -Confirm:$false -ErrorAction Stop
                    }
                    Write-Verbose "Removed $AccessLevel permissions for $User on $Owner's mailbox"
                    [PSCustomObject]@{
                        MailboxOwner = $Owner
                        User         = $User
                        AccessLevel  = $AccessLevel
                        Action       = 'Removed'
                        Success      = $true
                    }
                    return
                }

                if ($Update -eq $true) {
                    Write-Verbose "Updating $AccessLevel permissions for $User on $Owner's mailbox"
                    if ($AccessLevel -eq 'FullAccess') {
                        Add-MailboxPermission -Identity $Owner -User $User -AccessRights FullAccess -AutoMapping $false -Confirm:$false -ErrorAction Stop
                    } elseif ($AccessLevel -eq 'SendAs') {
                        Add-RecipientPermission -Identity $Owner -Trustee $User -AccessRights SendAs -Confirm:$false -ErrorAction Stop
                    }
                    Write-Verbose "Updated $AccessLevel permissions for $User on $Owner's mailbox"
                    [PSCustomObject]@{
                        MailboxOwner = $Owner
                        User         = $User
                        AccessLevel  = $AccessLevel
                        Action       = 'Updated'
                        Success      = $true
                    }
                    return
                }

                Write-Verbose "Adding $AccessLevel permissions for $User on $Owner's mailbox"
                if ($AccessLevel -eq 'FullAccess') {
                    Add-MailboxPermission -Identity $Owner -User $User -AccessRights FullAccess -AutoMapping $false -Confirm:$false -ErrorAction Stop
                } elseif ($AccessLevel -eq 'SendAs') {
                    Add-RecipientPermission -Identity $Owner -Trustee $User -AccessRights SendAs -Confirm:$false -ErrorAction Stop
                }
                Write-Verbose "Added $AccessLevel permissions for $User on $Owner's mailbox"
                [PSCustomObject]@{
                    MailboxOwner = $Owner
                    User         = $User
                    AccessLevel  = $AccessLevel
                    Action       = 'Added'
                    Success      = $true
                }
            } catch {
                Write-Warning "Failed to set $AccessLevel permissions for $User on $Owner's mailbox. $_"
                [PSCustomObject]@{
                    MailboxOwner = $Owner
                    User         = $User
                    AccessLevel  = $AccessLevel
                    Action       = if ($Remove) { 'Remove' } elseif ($Update) { 'Update' } else { 'Add' }
                    Success      = $false
                    Error        = $_
                }
            }
        }
    }

    end {
        Write-Verbose "Ending Set-O365MailboxPermissions function"
    }
}

# Example usage:
# Import-Csv -Path 'path_to_your_csv_file.csv' | Set-O365MailboxPermissions -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Set-O365MailboxPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-O365MailboxPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

