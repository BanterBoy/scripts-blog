---
layout: post
title: Get-OOHMessage.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-OOHMessage/
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

Retrieves the current Out of Office (OOH) settings for a mailbox in Exchange Online.

#### Detailed Description

This function queries Exchange Online for the specified mailbox and returns the auto-reply state, internal and external messages, and scheduling details.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-OOHMessage -Identity "user@example.com"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-OOHMessage {
    <#
    .SYNOPSIS
        Retrieves the current Out of Office (OOH) settings for a mailbox in Exchange Online.

    .DESCRIPTION
        This function queries Exchange Online for the specified mailbox and returns the auto-reply state, internal and external messages, and scheduling details.

    .PARAMETER Identity
        The identity (email address or alias) of the mailbox to check.

    .EXAMPLE
        Get-OOHMessage -Identity "user@example.com"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Identity
    )

    try {
        $config = Get-MailboxAutoReplyConfiguration -Identity $Identity
        [PSCustomObject]@{
            Identity         = $config.Identity
            AutoReplyState   = $config.AutoReplyState
            InternalMessage  = $config.InternalMessage
            ExternalMessage  = $config.ExternalMessage
            StartTime        = $config.StartTime
            EndTime          = $config.EndTime
            Enabled          = $config.AutoReplyState -ne 'Disabled'
        }
    }
    catch {
        Write-Error \"Failed to retrieve OOH settings for ${$Identity}: $_\"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-OOHMessage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-OOHMessage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

