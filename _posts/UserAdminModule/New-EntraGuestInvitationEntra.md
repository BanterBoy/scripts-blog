---
layout: post
title: New-EntraGuestInvitationEntra.ps1
date: 2025-09-19
permalink: /useradminmodule/azure/new-entraguestinvitationentra/
categories:
  - UserAdminModule
  - Azure
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

Send Microsoft Entra ID guest invitations and set user details and group membership using the Microsoft Entra module.

#### Detailed Description

New-EntraGuestInvitationEntra invites an external user (B2B guest) to your tenant using the Microsoft Entra module (`New-EntraInvitation`). After the invitation, it waits for the user object to appear, then updates profile details (PII, company, address, etc.) and adds the user to groups as needed. Supports:

- ShouldProcess/WhatIf for safe execution

- Pipeline input (email strings)

- Custom invitation message

- Post-invite user updates (display name, first/last name, company, department, job title, address, phone, other emails)

- Optional group assignment

- Optional pass-through of the resulting user object

To use this command: 1. Ensure the Microsoft.Entra.SignIns module is installed and imported. 2. Connect to Microsoft Entra with the required permissions. 3. Run New-EntraGuestInvitationEntra with at minimum `-InvitedUserEmailAddress` and `-InviteRedirectUrl`. 4. Optionally include profile details, custom message, or group assignment. 5. Use `-PassThru` to return the user object for further automation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Basic invite
```

New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com"

**Example 2**

```powershell
# Invite with custom message and display name
```

New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://portal.office.com" -CustomMessageBody "Welcome!" -InvitedUserDisplayName "Guest User"

**Example 3**

```powershell
# Invite and set full profile details, then return the user object
```

New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com" -InvitedUserDisplayName "Luke Leigh (Partner)" -GivenName "Luke" -Surname "Leigh" -CompanyName "Leigh Services" -Department "Consulting" -JobTitle "Contractor" -StreetAddress "63 Archer Avenue" -City "Southend-on-Sea" -State "Essex" -PostalCode "SS2 4QU" -Country "United Kingdom" -OtherMails "alt@example.com","billing@example.com" -PassThru -Verbose

**Example 4**

```powershell
# Bulk invite from pipeline with department/title and pass-through
```

"guest1@example.com","guest2@example.com" | New-EntraGuestInvitationEntra -InviteRedirectUrl "https://myapps.microsoft.com" -Department "IT" -JobTitle "Contractor" -PassThru

**Example 5**

```powershell
# Invite a user and add them to multiple groups after the user is resolvable
```

New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://entra.microsoft.com" -GroupId "11111111-1111-1111-1111-111111111111","22222222-2222-2222-2222-222222222222" -PassThru

**Example 6**

```powershell
# Suppress sending the invitation email and set profile details (not supported in Entra module, but you can skip CustomMessageBody)
```

New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com" -InvitedUserDisplayName "Guest (No Email)" -PassThru

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Permissions: Requires Microsoft Entra permissions to invite users and update user properties/groups. Module: Microsoft.Entra.SignIns Connect first: Connect-Entra -Scopes "User.Invite.All","User.ReadWrite.All","Group.ReadWrite.All"

This function does not modify Exchange Online proxy addresses. To manage proxy addresses, use Exchange Online cmdlets separately.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
    Send Microsoft Entra ID guest invitations and set user details and group membership using the Microsoft Entra module.

    .DESCRIPTION
    New-EntraGuestInvitationEntra invites an external user (B2B guest) to your tenant using the Microsoft Entra module (`New-EntraInvitation`).
    After the invitation, it waits for the user object to appear, then updates profile details (PII, company, address, etc.) and adds the user to groups as needed.
    Supports:
    - ShouldProcess/WhatIf for safe execution
    - Pipeline input (email strings)
    - Custom invitation message
    - Post-invite user updates (display name, first/last name, company, department, job title, address, phone, other emails)
    - Optional group assignment
    - Optional pass-through of the resulting user object

    To use this command:
    1. Ensure the Microsoft.Entra.SignIns module is installed and imported.
    2. Connect to Microsoft Entra with the required permissions.
    3. Run New-EntraGuestInvitationEntra with at minimum `-InvitedUserEmailAddress` and `-InviteRedirectUrl`.
    4. Optionally include profile details, custom message, or group assignment.
    5. Use `-PassThru` to return the user object for further automation.

    .PARAMETER InvitedUserEmailAddress
    The primary email address for the external user to invite. Accepts pipeline input.

    .PARAMETER InviteRedirectUrl
    The URL users land on after they accept the invitation.

    .PARAMETER InvitedUserDisplayName
    Display name to set on the guest user after creation.

    .PARAMETER CustomMessageBody
    Optional custom message text included in the invitation email.

    .PARAMETER GroupId
    One or more Azure AD group object IDs (security or Microsoft 365 group) to which the invited user will be added after creation. Uses Add-EntraGroupMember for assignment.

    .PARAMETER GivenName
    First name to set on the guest user after creation.

    .PARAMETER Surname
    Last name to set on the guest user after creation.

    .PARAMETER Department
    Department for the guest user.

    .PARAMETER JobTitle
    Job title for the guest user.

    .PARAMETER CompanyName
    Company/organization name for the guest user.

    .PARAMETER MobilePhone
    Mobile phone number for the guest user.

    .PARAMETER StreetAddress
    Street address for the guest user.

    .PARAMETER City
    City for the guest user.

    .PARAMETER State
    State/Province for the guest user.

    .PARAMETER PostalCode
    ZIP/Postal code for the guest user.

    .PARAMETER Country
    Country/Region for the guest user.

    .PARAMETER OtherMails
    Array of additional email addresses to store in the `otherMails` attribute.

    .PARAMETER PassThru
    Return the resulting user object (or invitation info as a fallback) for chaining.

    .INPUTS
    System.String. You can pipe email addresses directly to this function.

    .OUTPUTS
    System.Management.Automation.PSCustomObject. Returns the user object when `-PassThru` is specified; otherwise, no output.

    .EXAMPLE
    # Basic invite
    New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com"

    .EXAMPLE
    # Invite with custom message and display name
    New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://portal.office.com" -CustomMessageBody "Welcome!" -InvitedUserDisplayName "Guest User"

    .EXAMPLE
    # Invite and set full profile details, then return the user object
    New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com" -InvitedUserDisplayName "Luke Leigh (Partner)" -GivenName "Luke" -Surname "Leigh" -CompanyName "Leigh Services" -Department "Consulting" -JobTitle "Contractor" -StreetAddress "63 Archer Avenue" -City "Southend-on-Sea" -State "Essex" -PostalCode "SS2 4QU" -Country "United Kingdom" -OtherMails "alt@example.com","billing@example.com" -PassThru -Verbose

    .EXAMPLE
    # Bulk invite from pipeline with department/title and pass-through
    "guest1@example.com","guest2@example.com" | New-EntraGuestInvitationEntra -InviteRedirectUrl "https://myapps.microsoft.com" -Department "IT" -JobTitle "Contractor" -PassThru

    .EXAMPLE
    # Invite a user and add them to multiple groups after the user is resolvable
    New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://entra.microsoft.com" -GroupId "11111111-1111-1111-1111-111111111111","22222222-2222-2222-2222-222222222222" -PassThru

    .EXAMPLE
    # Suppress sending the invitation email and set profile details (not supported in Entra module, but you can skip CustomMessageBody)
    New-EntraGuestInvitationEntra -InvitedUserEmailAddress "guest@example.com" -InviteRedirectUrl "https://myapps.microsoft.com" -InvitedUserDisplayName "Guest (No Email)" -PassThru

    .NOTES
    Permissions: Requires Microsoft Entra permissions to invite users and update user properties/groups.
    Module: Microsoft.Entra.SignIns
    Connect first:
        Connect-Entra -Scopes "User.Invite.All","User.ReadWrite.All","Group.ReadWrite.All"

    This function does not modify Exchange Online proxy addresses. To manage proxy addresses, use Exchange Online cmdlets separately.

    .LINK
    https://learn.microsoft.com/powershell/module/microsoft.entra.signins/new-entraInvitation
    https://learn.microsoft.com/powershell/module/microsoft.entra.signins/update-entrauser
    https://learn.microsoft.com/powershell/module/microsoft.entra.signins/add-entrausertogroup
#>
function New-EntraGuestInvitationEntra {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType([pscustomobject])]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string] $InvitedUserEmailAddress,

        [Parameter(Mandatory=$true, Position=1)]
        [string] $InviteRedirectUrl,

        [Parameter()]
        [string] $InvitedUserDisplayName,

        [Parameter()]
        [string] $CustomMessageBody,

        [Parameter()]
        [string[]] $GroupId,

        [Parameter()]
        [string] $GivenName,
        [Parameter()]
        [string] $Surname,
        [Parameter()]
        [string] $Department,
        [Parameter()]
        [string] $JobTitle,
        [Parameter()]
        [string] $CompanyName,
        [Parameter()]
        [string] $MobilePhone,
        [Parameter()]
        [string] $StreetAddress,
        [Parameter()]
        [string] $City,
        [Parameter()]
        [string] $State,
        [Parameter()]
        [string] $PostalCode,
        [Parameter()]
        [string] $Country,
        [Parameter()]
        [string[]] $OtherMails,

        [Parameter()]
        [switch] $PassThru
    )

    process {
        $body = @{
            InvitedUserEmailAddress = $InvitedUserEmailAddress
            InviteRedirectUrl = $InviteRedirectUrl
        }
        if ($InvitedUserDisplayName) { $body.InvitedUserDisplayName = $InvitedUserDisplayName }
        if ($CustomMessageBody) {
            $body.InvitedUserMessageInfo = @{ CustomizedMessageBody = $CustomMessageBody }
        }

        if ($PSCmdlet.ShouldProcess($InvitedUserEmailAddress, "Send guest invitation (Entra module)")) {
            try {
                $invite = New-EntraInvitation @body -ErrorAction Stop
                Write-Verbose ("Invitation created for {0} (Entra module)" -f $InvitedUserEmailAddress)
            } catch {
                Write-Error ("Failed to create invitation for {0} (Entra module): {1}" -f $InvitedUserEmailAddress, $_)
                return
            }

            # Wait for user to exist
            $user = $null
            $deadline = (Get-Date).AddSeconds(60)
            while (-not $user -and (Get-Date) -lt $deadline) {
                Start-Sleep -Seconds 2
                $user = Get-EntraUser -Filter "mail eq '$InvitedUserEmailAddress'" -ErrorAction SilentlyContinue
            }
            if (-not $user) {
                Write-Warning "Invited user not found after waiting. Skipping profile/group updates."
                if ($PassThru) { $invite }
                return
            }

            # Update user profile details
            $updateParams = @{}
            if ($InvitedUserDisplayName) { $updateParams.DisplayName = $InvitedUserDisplayName }
            if ($GivenName) { $updateParams.GivenName = $GivenName }
            if ($Surname) { $updateParams.Surname = $Surname }
            if ($Department) { $updateParams.Department = $Department }
            if ($JobTitle) { $updateParams.JobTitle = $JobTitle }
            if ($CompanyName) { $updateParams.CompanyName = $CompanyName }
            if ($MobilePhone) { $updateParams.MobilePhone = $MobilePhone }
            if ($StreetAddress) { $updateParams.StreetAddress = $StreetAddress }
            if ($City) { $updateParams.City = $City }
            if ($State) { $updateParams.State = $State }
            if ($PostalCode) { $updateParams.PostalCode = $PostalCode }
            if ($Country) { $updateParams.Country = $Country }
            if ($OtherMails) { $updateParams.OtherMails = $OtherMails }

            if ($updateParams.Count -gt 0) {
                try {
                    Update-EntraUser -UserId $user.Id @updateParams -ErrorAction Stop
                    Write-Verbose ("Updated invited user {0} profile details" -f $user.Id)
                } catch {
                    Write-Error ("Failed to update invited user {0} profile: {1}" -f $user.Id, $_)
                }
            }

            # Group assignment
            if ($GroupId) {
                foreach ($gid in $GroupId) {
                    try {
                        Add-EntraGroupMember -GroupId $gid -MemberId $user.Id -ErrorAction Stop
                        Write-Verbose ("Added user {0} to group {1}" -f $user.Id, $gid)
                    } catch {
                        Write-Error ("Failed to add user {0} to group {1}: {2}" -f $user.Id, $gid, $_)
                    }
                }
            }

            if ($PassThru) {
                Get-EntraUser -UserId $user.Id
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/New-EntraGuestInvitationEntra.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-EntraGuestInvitationEntra.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

