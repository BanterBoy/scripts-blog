---
layout: post
title: Set-OOHmessage.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-OOHmessage/
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

Sets the out-of-office (OOH) message for a mailbox in Exchange Online.

#### Detailed Description

The Set-OOHMessage function sets the out-of-office (OOH) message for a specified mailbox in Exchange Online. The OOH message can be enabled, disabled, or scheduled with specific start and end times.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -Verbose
```

This example enables the OOH message for the specified mailbox with the provided internal and external messages.

**Example 2**

```powershell
Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose
```

This example schedules the OOH message for the specified mailbox with the provided internal and external messages and start and end times.

**Example 3**

```powershell
Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Disabled" -Verbose
```

This example disables the OOH message for the specified mailbox.

**Example 4**

```powershell
# Generate the OOH message and save it to a file
```

$OOHMessagePath = New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X" -Verbose # Read the generated message from the file $InternalMessage = Get-Content -Path $OOHMessagePath -Raw $ExternalMessage = $InternalMessage # Assuming the same message for both internal and external # Set the OOH message in Office 365 Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -Verbose # If scheduling is needed, use the following: Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose

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
    Sets the out-of-office (OOH) message for a mailbox in Exchange Online.

.DESCRIPTION
    The Set-OOHMessage function sets the out-of-office (OOH) message for a specified mailbox in Exchange Online. The OOH message can be enabled, disabled, or scheduled with specific start and end times.

.PARAMETER Identity
    The identity of the mailbox for which to set the OOH message.

.PARAMETER AutoReplyState
    Specifies the auto-reply state. Valid values are "Enabled", "Disabled", and "Scheduled".

.PARAMETER InternalMessage
    The internal OOH message.

.PARAMETER ExternalMessage
    The external OOH message.

.PARAMETER StartTime
    The start time for the scheduled OOH message.

.PARAMETER EndTime
    The end time for the scheduled OOH message.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -Verbose

    This example enables the OOH message for the specified mailbox with the provided internal and external messages.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage "I am out of the office." -ExternalMessage "I am out of the office." -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose

    This example schedules the OOH message for the specified mailbox with the provided internal and external messages and start and end times.

.EXAMPLE
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Disabled" -Verbose

    This example disables the OOH message for the specified mailbox.

.EXAMPLE
    # Generate the OOH message and save it to a file
    $OOHMessagePath = New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X" -Verbose

    # Read the generated message from the file
    $InternalMessage = Get-Content -Path $OOHMessagePath -Raw
    $ExternalMessage = $InternalMessage # Assuming the same message for both internal and external

    # Set the OOH message in Office 365
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -Verbose

    # If scheduling is needed, use the following:
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Scheduled" -InternalMessage $InternalMessage -ExternalMessage $ExternalMessage -StartTime (Get-Date).AddDays(1) -EndTime (Get-Date).AddDays(7) -Verbose

.NOTES
    Author: Your Name
    Date: Today's Date

#>

function Set-OOHMessage {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Enabled')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Enabled", "Disabled", "Scheduled")]
        [string]$AutoReplyState,

        [Parameter(Mandatory = $true, ParameterSetName = 'Enabled')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [string]$InternalMessage,

        [Parameter(Mandatory = $true, ParameterSetName = 'Enabled')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [string]$ExternalMessage,

        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTime,

        [Parameter(Mandatory = $true, ParameterSetName = 'Scheduled')]
        [ValidateNotNullOrEmpty()]
        [datetime]$EndTime
    )

    begin {
        Write-Verbose "Starting Set-OOHMessage function."
    }

    process {
        if ($PSCmdlet.ShouldProcess($Identity, "Set AutoReplyState to $AutoReplyState")) {
            try {
                $parameters = @{
                    Identity       = $Identity
                    AutoReplyState = $AutoReplyState
                }

                if ($AutoReplyState -ne "Disabled") {
                    $parameters += @{
                        InternalMessage = $InternalMessage
                        ExternalMessage = $ExternalMessage
                    }
                }

                if ($AutoReplyState -eq "Scheduled") {
                    $parameters += @{
                        StartTime = $StartTime
                        EndTime   = $EndTime
                    }
                }

                Write-Verbose "Setting auto-reply configuration for $Identity with state $AutoReplyState."
                Set-MailboxAutoReplyConfiguration @parameters
                Write-Verbose "Auto-reply configuration set successfully for $Identity."
            }
            catch {
                Write-Error "Failed to set auto-reply configuration for {$Identity}: $_"
            }
        }
    }

    end {
        Write-Verbose "Set-OOHMessage function execution completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Set-OOHmessage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-OOHmessage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

