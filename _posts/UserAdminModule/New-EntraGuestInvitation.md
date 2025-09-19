---
layout: post
title: New-EntraGuestInvitation.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-EntraGuestInvitation/
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

Send Microsoft Entra ID guest invitations and optionally set user details and add to groups.

#### Detailed Description

New-EntraGuestInvitation invites an external user (B2B guest) to your tenant using Microsoft Graph (`New-MgInvitation`). It supports:

- ShouldProcess/WhatIf for safe execution

- Pipeline input (email strings or objects with a `Mail`/`Email` property)

- Custom invitation message with optional CC recipients

- Post-invite user updates (display name, first/last name, company, department, job title, address, phone, other emails)

- Optional group assignment

- Tab-completion for `InviteRedirectUrl` and `MessageLanguage`

- Optional waiting period to ensure the user object exists before applying updates

To complete an invitation using this command: 1. Connect to Microsoft Graph with the required scopes: Connect-MgGraph -Scopes User.Invite.All, User.ReadWrite.All, Group.ReadWrite.All 2. Run New-EntraGuestInvitation with at minimum `-InvitedUserEmailAddress` and `-InviteRedirectUrl`. 3. Optionally include a custom message (`-CustomMessageBody`, `-CcRecipients`) or suppress email with `-SuppressInvitationMessage`. 4. To immediately set profile details or add to groups, supply the relevant parameters and consider `-WaitForUser`. 5. Use `-PassThru` to return the user object for further automation.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Basic invite (redirect URL is set to https://myapps.microsoft.com by default)
```

New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -InvitedUserDisplayName "Guest User"

**Example 2**

```powershell
# Invite with a custom message and CC recipients (redirect URL is set to https://portal.office.com by default)
```

New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -CustomMessageBody "Welcome!" -CcRecipients "manager@contoso.com","owner@contoso.com"

**Example 3**

```powershell
# Invite and set full profile details, waiting for the user object to materialize, then return the user (redirect URL is set to https://myapps.microsoft.com by default)
```

New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -DisplayName "Luke Leigh (Partner)" -GivenName "Luke" -Surname "Leigh" -CompanyName "Leigh Services" -Department "Consulting" -JobTitle "Contractor" -StreetAddress "63 Archer Avenue" -City "Southend-on-Sea" -State "Essex" -PostalCode "SS2 4QU" -Country "United Kingdom" -OtherMails "alt@example.com","billing@example.com" -WaitForUser -PassThru -Verbose

**Example 4**

```powershell
# Bulk invite from pipeline with department/title and pass-through (redirect URL is set to https://myapps.microsoft.com by default)
```

"guest1@example.com","guest2@example.com" | New-EntraGuestInvitation -InvitedUserDisplayName "Contractor" -Department "IT" -JobTitle "Contractor" -WaitForUser -PassThru

**Example 5**

```powershell
# Invite a user and add them to multiple groups after the user is resolvable (redirect URL is set to https://entra.microsoft.com by default)
```

New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -GroupId "11111111-1111-1111-1111-111111111111","22222222-2222-2222-2222-222222222222" -WaitForUser -PassThru

**Example 6**

```powershell
# Suppress sending the invitation email (no email sent) and still set profile details (redirect URL is set to https://myapps.microsoft.com by default)
```

New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -SuppressInvitationMessage -DisplayName "Guest (No Email)" -WaitForUser -PassThru

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Permissions: Requires Microsoft Graph scopes `User.Invite.All`, `User.ReadWrite.All` and `Group.ReadWrite.All` (if using `-GroupId`). Connect first: Connect-MgGraph -Scopes User.Invite.All, User.ReadWrite.All, Group.ReadWrite.All

Redirect URL logic:

- Basic invite: defaults to https://myapps.microsoft.com

- Custom message or CC: defaults to https://portal.office.com

- Group assignment: defaults to https://entra.microsoft.com

- You can override the URL by specifying -InviteRedirectUrl explicitly.

This function does not modify Exchange Online proxy addresses. To manage proxy addresses, use Exchange Online cmdlets separately.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Send Microsoft Entra ID guest invitations and optionally set user details and add to groups.

.DESCRIPTION
New-EntraGuestInvitation invites an external user (B2B guest) to your tenant using Microsoft Graph
(`New-MgInvitation`). It supports:
- ShouldProcess/WhatIf for safe execution
- Pipeline input (email strings or objects with a `Mail`/`Email` property)
- Custom invitation message with optional CC recipients
- Post-invite user updates (display name, first/last name, company, department, job title, address, phone, other emails)
- Optional group assignment
- Tab-completion for `InviteRedirectUrl` and `MessageLanguage`
- Optional waiting period to ensure the user object exists before applying updates

To complete an invitation using this command:
1. Connect to Microsoft Graph with the required scopes:
     Connect-MgGraph -Scopes User.Invite.All, User.ReadWrite.All, Group.ReadWrite.All
2. Run New-EntraGuestInvitation with at minimum `-InvitedUserEmailAddress` and `-InviteRedirectUrl`.
3. Optionally include a custom message (`-CustomMessageBody`, `-CcRecipients`) or suppress email with `-SuppressInvitationMessage`.
4. To immediately set profile details or add to groups, supply the relevant parameters and consider `-WaitForUser`.
5. Use `-PassThru` to return the user object for further automation.

.PARAMETER InvitedUserEmailAddress
The primary email address for the external user to invite. Accepts pipeline input and the aliases `Mail`, `Email`, `UserEmail`.


.PARAMETER InviteRedirectUrl
The URL users land on after they accept the invitation. Tab-completes common Microsoft destinations.

.PARAMETER InvitedUserDisplayName
Display name presented in the invitation email and used as the initial guest display name.

.PARAMETER MessageLanguage
Language code for the invitation message (tab-complete suggestions provided). Default: `en-GB`.

.PARAMETER CustomMessageBody
Optional custom message text included in the invitation email.

.PARAMETER CcRecipients
Optional list of email addresses to CC on the invitation.

.PARAMETER SuppressInvitationMessage
Switch to suppress sending the invitation email (omit the switch to send the email).

.PARAMETER DisplayName
Display name to set on the guest user after creation.

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

.PARAMETER GroupId
One or more Microsoft 365 group/object IDs to which the invited user will be added after creation.

.PARAMETER WaitForUser
Switch to wait for the invited user object to become available before applying updates or adding to groups.

.PARAMETER WaitTimeoutSec
Total time to wait for the user to appear when `-WaitForUser` is used. Default: 60. Range: 5–300.

.PARAMETER WaitIntervalSec
Polling interval when waiting for the user to appear. Default: 2. Range: 1–30.

.PARAMETER PassThru
Return the resulting user object (or invitation info as a fallback) for chaining.

.INPUTS
System.String. You can pipe email addresses directly to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns the user object when `-PassThru` is specified; otherwise, no output.

.EXAMPLE

# Basic invite (redirect URL is set to https://myapps.microsoft.com by default)
New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -InvitedUserDisplayName "Guest User"

.EXAMPLE

# Invite with a custom message and CC recipients (redirect URL is set to https://portal.office.com by default)
New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -CustomMessageBody "Welcome!" -CcRecipients "manager@contoso.com","owner@contoso.com"

.EXAMPLE

# Invite and set full profile details, waiting for the user object to materialize, then return the user (redirect URL is set to https://myapps.microsoft.com by default)
New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -DisplayName "Luke Leigh (Partner)" -GivenName "Luke" -Surname "Leigh" -CompanyName "Leigh Services" -Department "Consulting" -JobTitle "Contractor" -StreetAddress "63 Archer Avenue" -City "Southend-on-Sea" -State "Essex" -PostalCode "SS2 4QU" -Country "United Kingdom" -OtherMails "alt@example.com","billing@example.com" -WaitForUser -PassThru -Verbose

.EXAMPLE

# Bulk invite from pipeline with department/title and pass-through (redirect URL is set to https://myapps.microsoft.com by default)
"guest1@example.com","guest2@example.com" | New-EntraGuestInvitation -InvitedUserDisplayName "Contractor" -Department "IT" -JobTitle "Contractor" -WaitForUser -PassThru

.EXAMPLE

# Invite a user and add them to multiple groups after the user is resolvable (redirect URL is set to https://entra.microsoft.com by default)
New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -GroupId "11111111-1111-1111-1111-111111111111","22222222-2222-2222-2222-222222222222" -WaitForUser -PassThru

.EXAMPLE

# Suppress sending the invitation email (no email sent) and still set profile details (redirect URL is set to https://myapps.microsoft.com by default)
New-EntraGuestInvitation -InvitedUserEmailAddress "guest@example.com" -SuppressInvitationMessage -DisplayName "Guest (No Email)" -WaitForUser -PassThru

.NOTES
Permissions: Requires Microsoft Graph scopes `User.Invite.All`, `User.ReadWrite.All` and `Group.ReadWrite.All` (if using `-GroupId`).
Connect first:
    Connect-MgGraph -Scopes User.Invite.All, User.ReadWrite.All, Group.ReadWrite.All

Redirect URL logic:
- Basic invite: defaults to https://myapps.microsoft.com
- Custom message or CC: defaults to https://portal.office.com
- Group assignment: defaults to https://entra.microsoft.com
- You can override the URL by specifying -InviteRedirectUrl explicitly.

This function does not modify Exchange Online proxy addresses. To manage proxy addresses, use Exchange Online cmdlets separately.

.LINK
https://learn.microsoft.com/graph/api/invitation-post
https://learn.microsoft.com/powershell/microsoftgraph/overview
#>
function New-EntraGuestInvitation {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType([pscustomobject])]
    param (
        # Primary email to invite; can also be provided from pipeline (as string) or by property name (e.g., Mail)
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Mail','Email','UserEmail')]
        [ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')]
        [string] $InvitedUserEmailAddress,

        # Where the invited user will be redirected after accepting invite
        [Parameter(Position=1)]
        [ValidateNotNullOrEmpty()]
        [string] $InviteRedirectUrl,

        # Optional invitation message settings
        [Parameter()]
        [string] $InvitedUserDisplayName,

        [Parameter()]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $langs = 'en-GB','en-US','de-DE','fr-FR','es-ES','it-IT','nl-NL','sv-SE','pt-PT','pt-BR'
            $langs | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string] $MessageLanguage = 'en-GB',

        [Parameter()]
        [string] $CustomMessageBody,

        [Parameter()]
        [string[]] $CcRecipients,

        # Use -SuppressInvitationMessage to not send email; default is to send email
        [Parameter()]
        [switch] $SuppressInvitationMessage,

        # Post-invite user property updates
        [Parameter()]
        [string] $DisplayName,

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

        # Optionally add the invited user to groups
        [Parameter()]
        [string[]] $GroupId,

        # Return the invited/updated user object
        [Parameter()]
        [switch] $PassThru,

        # Wait for user object to appear so that post-invite updates/groups can be applied
        [Parameter()]
        [switch] $WaitForUser,

        [Parameter()]
        [ValidateRange(5,300)]
        [int] $WaitTimeoutSec = 60,

        [Parameter()]
        [ValidateRange(1,30)]
        [int] $WaitIntervalSec = 2
    )

    begin {
        $sendInvitationMessage = -not $SuppressInvitationMessage.IsPresent
    }

    process {
        # Set static default URL if not provided
        $redirectUrl = $InviteRedirectUrl
        if (-not $redirectUrl) {
            if ($CustomMessageBody -or $CcRecipients) {
                $redirectUrl = 'https://portal.office.com'
            } elseif ($GroupId) {
                $redirectUrl = 'https://entra.microsoft.com'
            } else {
                $redirectUrl = 'https://myapps.microsoft.com'
            }
        }

        # Build invitation body
        $body = @{
            invitedUserEmailAddress = $InvitedUserEmailAddress
            inviteRedirectUrl       = $redirectUrl
            sendInvitationMessage   = $sendInvitationMessage
            messageLanguage         = $MessageLanguage
        }
        if ($InvitedUserDisplayName) { $body.invitedUserDisplayName = $InvitedUserDisplayName }

        if ($CustomMessageBody -or $CcRecipients) {
            $msg = @{}
            if ($CustomMessageBody) { $msg.customizedMessageBody = $CustomMessageBody }
            if ($CcRecipients) {
                $msg.ccRecipients = @()
                foreach ($addr in $CcRecipients) {
                    if ($addr) { $msg.ccRecipients += @{ emailAddress = @{ address = $addr } } }
                }
            }
            if ($msg.Count -gt 0) { $body.invitedUserMessageInfo = $msg }
        }

        $target = $InvitedUserEmailAddress
        if ($PSCmdlet.ShouldProcess($target, "Send guest invitation")) {
            try {
                $invite = New-MgInvitation -BodyParameter $body -ErrorAction Stop
                Write-Verbose ("Invitation created for {0}" -f $InvitedUserEmailAddress)
            } catch {
                Write-Error ("Failed to create invitation for {0}: {1}" -f $InvitedUserEmailAddress, $_)
                return
            }

            # Try resolve the created guest user by email
            $user = $null
            $userId = $null
            $resolveUser = {
                try {
                    Get-MgUser -Filter "userType eq 'Guest' and mail eq '$InvitedUserEmailAddress'" -Property id,mail,userPrincipalName,displayName -ErrorAction Stop
                } catch {
                    $null
                }
            }
            $user = & $resolveUser
            if (-not $user -and ($WaitForUser -or $DisplayName -or $GivenName -or $Surname -or $Department -or $JobTitle -or $CompanyName -or $MobilePhone -or $StreetAddress -or $City -or $State -or $PostalCode -or $Country -or $OtherMails -or $GroupId)) {
                $deadline = [DateTime]::UtcNow.AddSeconds($WaitTimeoutSec)
                while (-not $user -and [DateTime]::UtcNow -lt $deadline) {
                    Start-Sleep -Seconds $WaitIntervalSec
                    $user = & $resolveUser
                }
            }
            if (-not $user) {
                Write-Verbose ("User not resolvable for {0} within wait window; skipping post-invite updates and group assignment." -f $InvitedUserEmailAddress)
            } else {
                $userId = $user.id
            }

            # Post-invite updates if we have an id and any properties provided
            $updateParams = @{}
            if ($DisplayName)   { $updateParams.DisplayName   = $DisplayName }
            if ($GivenName)     { $updateParams.GivenName     = $GivenName }
            if ($Surname)       { $updateParams.Surname       = $Surname }
            if ($Department)    { $updateParams.Department    = $Department }
            if ($JobTitle)      { $updateParams.JobTitle      = $JobTitle }
            if ($CompanyName)   { $updateParams.CompanyName   = $CompanyName }
            if ($MobilePhone)   { $updateParams.MobilePhone   = $MobilePhone }
            if ($StreetAddress) { $updateParams.StreetAddress = $StreetAddress }
            if ($City)          { $updateParams.City          = $City }
            if ($State)         { $updateParams.State         = $State }
            if ($PostalCode)    { $updateParams.PostalCode    = $PostalCode }
            if ($Country)       { $updateParams.Country       = $Country }
            if ($OtherMails)    { $updateParams.OtherMails    = @($OtherMails | Where-Object { $_ -and $_.Trim() } | Select-Object -Unique) }

            if ($userId -and $updateParams.Count -gt 0) {
                if ($PSCmdlet.ShouldProcess($userId, "Update invited guest properties")) {
                    try {
                        Update-MgUser -UserId $userId @updateParams -ErrorAction Stop
                        Write-Verbose ("Updated invited user {0}" -f $userId)
                    } catch {
                        Write-Error ("Failed to update invited user {0}: {1}" -f $userId, $_)
                    }
                }
            }

            # Group assignment
            if ($userId -and $GroupId) {
                foreach ($gid in $GroupId) {
                    if (-not $gid) { continue }
                    if ($PSCmdlet.ShouldProcess($gid, "Add invited user to group")) {
                        try {
                            $ref = @{ '@odata.id' = "https://graph.microsoft.com/v1.0/directoryObjects/$userId" }
                            New-MgGroupMemberByRef -GroupId $gid -BodyParameter $ref -ErrorAction Stop | Out-Null
                            Write-Verbose ("Added user {0} to group {1}" -f $userId, $gid)
                        } catch {
                            Write-Error ("Failed adding user {0} to group {1}: {2}" -f $userId, $gid, $_)
                        }
                    }
                }
            }

            if ($PassThru) {
                try {
                    $props = 'id','displayName','givenName','surname','userPrincipalName','mail','otherMails','jobTitle','companyName','department','streetAddress','city','state','postalCode','country'
                    if (-not $userId) {
                        $userId = (Get-MgUser -Filter "userType eq 'Guest' and mail eq '$InvitedUserEmailAddress'" -Property id).id
                    }
                    if ($userId) {
                        Get-MgUser -UserId $userId -Property $props | Select-Object -Property $props
                    } else {
                        # Fallback to invitation info if user lookup failed
                        [pscustomobject]@{
                            InvitationId = $invite.Id
                            InvitedUserEmailAddress = $InvitedUserEmailAddress
                            Status = 'Invited'
                        }
                    }
                } catch {
                    Write-Error ("Failed to fetch invited user details for {0}: {1}" -f $InvitedUserEmailAddress, $_)
                }
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/New-EntraGuestInvitation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-EntraGuestInvitation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

