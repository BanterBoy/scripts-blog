---
layout: post
title: Unblock-QuarantineMessage.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/unblock-quarantinemessage/
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

Unblocks a quarantined email message.

#### Detailed Description

This function releases a quarantined email message and optionally deletes it from the quarantine. It can also release the email to specific recipients.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Unblock-QuarantineMessage -Identity "12345"
```

Releases the quarantined email message with the message ID "12345".

**Example 2**

```powershell
Unblock-QuarantineMessage -Identity "12345" -DeleteAfterRelease
```

Releases and deletes the quarantined email message with the message ID "12345".

**Example 3**

```powershell
Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com"
```

Releases the quarantined email message with the message ID "12345" to the specified recipient.

**Example 4**

```powershell
Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com", "user2@example.com" -DeleteAfterRelease
```

Releases the quarantined email message with the message ID "12345" to the specified recipients and then deletes it from quarantine.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Unblocks a quarantined email message.

.DESCRIPTION
    This function releases a quarantined email message and optionally deletes it from the quarantine. It can also release the email to specific recipients.

.PARAMETER Identity
    The message ID of the quarantined email to release.

.PARAMETER Recipients
    Specifies one or more recipients to whom the email should be released.

.PARAMETER DeleteAfterRelease
    Indicates whether to delete the email from quarantine after releasing it.

.PARAMETER AllowSender
    Allows future messages from the sender.

.PARAMETER ReportFalsePositive
    Reports the message as a false positive.

.PARAMETER Force
    Forces the release of the message without any additional prompts.

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345"

    Releases the quarantined email message with the message ID "12345".

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -DeleteAfterRelease

    Releases and deletes the quarantined email message with the message ID "12345".

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com"

    Releases the quarantined email message with the message ID "12345" to the specified recipient.

.EXAMPLE
    Unblock-QuarantineMessage -Identity "12345" -Recipients "user1@example.com", "user2@example.com" -DeleteAfterRelease

    Releases the quarantined email message with the message ID "12345" to the specified recipients and then deletes it from quarantine.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Unblock-QuarantineMessage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Recipients,

        [Parameter(Mandatory = $false)]
        [switch]$DeleteAfterRelease,

        [Parameter(Mandatory = $false)]
        [switch]$AllowSender,

        [Parameter(Mandatory = $false)]
        [switch]$ReportFalsePositive,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    process {
        $releaseParams = @{
            Identity = $Identity
            Confirm  = $false
        }

        if ($AllowSender) { $releaseParams['AllowSender'] = $true }
        if ($ReportFalsePositive) { $releaseParams['ReportFalsePositive'] = $true }
        if ($Force) { $releaseParams['Force'] = $true }

        if ($PSCmdlet.ShouldProcess($Identity, "Release quarantine message")) {
            try {
                if ($Recipients) {
                    foreach ($Recipient in $Recipients) {
                        try {
                            $releaseParams['User'] = $Recipient
                            Release-QuarantineMessage @releaseParams
                            Write-Output "Message with ID $Identity has been released to $Recipient."
                        }
                        catch {
                            Write-Error "Failed to release message to $Recipient. Error: $_"
                        }
                    }
                }
                else {
                    try {
                        $releaseParams['ReleaseToAll'] = $true
                        Release-QuarantineMessage @releaseParams
                        Write-Output "Message with ID $Identity has been released to all recipients."
                    }
                    catch {
                        Write-Error "Failed to release message to all recipients. Error: $_"
                    }
                }

                if ($DeleteAfterRelease -and $PSCmdlet.ShouldProcess($Identity, "Delete quarantine message")) {
                    try {
                        Delete-QuarantineMessage -Identity $Identity -Confirm:$false
                        Write-Output "Message with ID $Identity has been deleted from quarantine."
                    }
                    catch {
                        Write-Error "Failed to delete message from quarantine. Error: $_"
                    }
                }
            }
            catch {
                Write-Error "Failed to process message with ID $Identity. Error: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Unblock-QuarantineMessage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Unblock-QuarantineMessage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

