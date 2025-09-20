---
layout: post
title: Get-MailboxContent.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-MailboxContent/
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

Retrieves email messages from a specified mailbox.

#### Detailed Description

This script connects to a specified mailbox and retrieves email messages based on the provided filters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-MailboxContent -Mailbox "user@example.com" -SenderAddress "sender@example.com" -Subject "Project Update" -StartReceivedDate "2024-01-01" -EndReceivedDate "2024-01-31" -Verbose
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves email messages from a specified mailbox.

.DESCRIPTION
    This script connects to a specified mailbox and retrieves email messages based on the provided filters.

.PARAMETER Mailbox
    The email address of the mailbox to retrieve messages from.

.PARAMETER SenderAddress
    The email address of the sender to filter messages by.

.PARAMETER RecipientAddress
    The email address of the recipient to filter messages by.

.PARAMETER Subject
    The subject to filter messages by.

.PARAMETER StartReceivedDate
    The start date to filter messages by.

.PARAMETER EndReceivedDate
    The end date to filter messages by.

.PARAMETER Credential
    The credentials to use for authentication.

.EXAMPLE
    Get-MailboxContent -Mailbox "user@example.com" -SenderAddress "sender@example.com" -Subject "Project Update" -StartReceivedDate "2024-01-01" -EndReceivedDate "2024-01-31" -Verbose
#>

function Get-MailboxContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Mailbox,

        [Parameter(Mandatory = $false)]
        [string]$SenderAddress,

        [Parameter(Mandatory = $false)]
        [string]$RecipientAddress,

        [Parameter(Mandatory = $false)]
        [string]$Subject,

        [Parameter(Mandatory = $false)]
        [datetime]$StartReceivedDate,

        [Parameter(Mandatory = $false)]
        [datetime]$EndReceivedDate
    )

    begin {
        Write-Verbose "Connecting to Microsoft Graph..."
        if (-not (Get-MgContext)) {
            Connect-MgGraph -Scopes "Mail.Read"
        }
    }

    process {
        # Build OData filter string for Get-MgUserMessage
        $filter = @()
        if ($SenderAddress) { $filter += "from/emailAddress/address eq '$SenderAddress'" }
        if ($RecipientAddress) { $filter += "toRecipients/any(t: t/emailAddress/address eq '$RecipientAddress')" }
        if ($Subject) { $filter += "contains(subject,'$Subject')" }
        if ($StartReceivedDate) { $filter += "receivedDateTime ge $($StartReceivedDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))" }
        if ($EndReceivedDate) { $filter += "receivedDateTime le $($EndReceivedDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))" }

        $searchFilter = $filter -join " and "
        Write-Verbose "Search filter constructed: $searchFilter"

        try {
            $params = @{ UserId = $Mailbox; Top = 50; }
            if ($searchFilter) { $params['Filter'] = $searchFilter }
            $messages = Get-MgUserMessage @params
        }
        catch {
            Write-Error "Failed to retrieve messages: $_"
            return
        }

        $result = @()
        foreach ($email in $messages) {
            $result += [PSCustomObject]@{
                Date    = $email.ReceivedDateTime
                From    = $email.From.EmailAddress.Address
                To      = ($email.ToRecipients | ForEach-Object { $_.EmailAddress.Address }) -join ", "
                Subject = $email.Subject
                Body    = $email.Body.Content
            }
        }
        $result
    }
}

# Example usage (uncomment the following line to use the function directly):
# Get-MailboxContent -Mailbox "user@example.com" -SenderAddress "sender@example.com" -Subject "Project Update" -StartReceivedDate "2024-01-01" -EndReceivedDate "2024-01-31" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-MailboxContent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MailboxContent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

