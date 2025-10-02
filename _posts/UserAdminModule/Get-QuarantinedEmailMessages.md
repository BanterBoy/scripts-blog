---
layout: post
title: Get-QuarantinedEmailMessages.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/get-quarantinedemailmessages/
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

Retrieves and displays quarantined emails based on specified filters.

#### Detailed Description

The Get-QuarantinedEmailMessages function retrieves quarantined emails from a quarantine system based on specified filters such as recipient, sender, subject, received date, page size, page number, and quarantine types.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-QuarantinedEmailMessages -Recipient "user1@example.com" -EmailSender "specific.sender@example.com"
```

Retrieves and displays quarantined emails for the specified recipient and sender.

**Example 2**

```powershell
Get-QuarantinedEmailMessages -Recipient "user1@example.com" -Subject "Important Subject" -QuarantineTypes "Spam"
```

Retrieves and displays quarantined emails for the specified recipient, subject, and quarantine type.

**Example 3**

```powershell
Get-QuarantinedEmailMessages -Recipient "user1@example.com" -StartReceivedDate (Get-Date "2024-06-01") -EndReceivedDate (Get-Date "2024-06-09")
```

Retrieves and displays quarantined emails for the specified recipient and received date range.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Retrieves and displays quarantined emails based on specified filters.

.DESCRIPTION
    The Get-QuarantinedEmailMessages function retrieves quarantined emails from a quarantine system based on specified filters such as recipient, sender, subject, received date, page size, page number, and quarantine types.

.PARAMETER Recipient
    Specifies the recipient email addresses to filter the quarantined emails. Multiple recipients can be specified by providing an array of email addresses.

.PARAMETER EmailSender
    Specifies the sender email address to filter the quarantined emails. Wildcards (*) can be used to match any characters before and after the specified sender address.

.PARAMETER Subject
    Specifies the subject of the quarantined emails to filter. Wildcards (*) can be used to match any characters before and after the specified subject.

.PARAMETER StartReceivedDate
    Specifies the start date of the received time range to filter the quarantined emails. Only emails received on or after this date will be included.

.PARAMETER EndReceivedDate
    Specifies the end date of the received time range to filter the quarantined emails. Only emails received on or before this date will be included.

.PARAMETER PageSize
    Specifies the number of quarantined emails to retrieve per page. The default value is 100.

.PARAMETER Page
    Specifies the page number of the quarantined emails to retrieve. The default value is 1.

.PARAMETER QuarantineTypes
    Specifies the types of quarantined emails to filter. Valid values are "Bulk", "HighConfPhish", "Malware", "Phish", "Spam", "SPOMalware", and "TransportRule". Multiple types can be specified by providing an array of values.

.PARAMETER Released
    Shows only released emails if specified.

.EXAMPLE
    Get-QuarantinedEmailMessages -Recipient "user1@example.com" -EmailSender "specific.sender@example.com"

    Retrieves and displays quarantined emails for the specified recipient and sender.

.EXAMPLE
    Get-QuarantinedEmailMessages -Recipient "user1@example.com" -Subject "Important Subject" -QuarantineTypes "Spam"

    Retrieves and displays quarantined emails for the specified recipient, subject, and quarantine type.

.EXAMPLE
    Get-QuarantinedEmailMessages -Recipient "user1@example.com" -StartReceivedDate (Get-Date "2024-06-01") -EndReceivedDate (Get-Date "2024-06-09")

    Retrieves and displays quarantined emails for the specified recipient and received date range.

.NOTES
    Author: Your Name
    Date: Today's Date

#>

function Get-QuarantinedEmailMessages {
    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true, HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter recipient email addresses')]
        [string[]]$Recipient,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter email sender address')]
        [string]$EmailSender,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter email subject')]
        [string]$Subject,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter start received date')]
        [datetime]$StartReceivedDate,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter end received date')]
        [datetime]$EndReceivedDate,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter page size')]
        [int]$PageSize = 100,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter page number')]
        [int]$Page = 1,
        
        [Parameter(ParameterSetName = 'Default', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter quarantine types')]
        [ValidateSet("Bulk", "HighConfPhish", "Malware", "Phish", "Spam", "SPOMalware", "TransportRule")]
        [string[]]$QuarantineTypes,

        [Parameter(ParameterSetName = 'Default', Mandatory = $false, HelpMessage = 'Show only released emails')]
        [switch]$Released
    )

    $filterParams = @{}
    if ($Recipient) { $filterParams['RecipientAddress'] = $Recipient }
    if ($EmailSender) { $filterParams['SenderAddress'] = $EmailSender }
    if ($Subject) { $filterParams['Subject'] = $Subject }
    if ($StartReceivedDate) { $filterParams['StartReceivedDate'] = $StartReceivedDate }
    if ($EndReceivedDate) { $filterParams['EndReceivedDate'] = $EndReceivedDate }
    if ($PageSize) { $filterParams['PageSize'] = $PageSize }
    if ($Page) { $filterParams['Page'] = $Page }
    if ($QuarantineTypes) { $filterParams['QuarantineTypes'] = $QuarantineTypes }

    Write-Verbose "Starting to retrieve quarantined emails with the following filters: $($filterParams | Out-String)"

    if ($PSCmdlet.ShouldProcess("Quarantine messages", "Retrieve quarantine messages")) {
        try {
            $quarantinedEmails = Get-QuarantineMessage @filterParams
            Write-Verbose "Retrieved $($quarantinedEmails.Count) quarantined emails."
        }
        catch {
            Write-Error "Failed to retrieve quarantined emails. Error: $_"
            return
        }

        $emailInfo = $quarantinedEmails | Select-Object -Property ReceivedTime, Type, SenderAddress, RecipientAddress, Subject, Size, Expires, Identity, Released

        # Filter by release status if the Released switch is specified
        if ($Released) {
            $emailInfo = $emailInfo | Where-Object { $_.Released -eq $true }
        }

        Write-Verbose "Filtered email information ready for output."

        return $emailInfo | ForEach-Object {
            [PSCustomObject]@{
                ReceivedTime     = $_.ReceivedTime
                Type             = $_.Type
                SenderAddress    = $_.SenderAddress
                RecipientAddress = ($_.RecipientAddress -join ', ')
                Subject          = $_.Subject
                Size             = $_.Size
                Expires          = $_.Expires
                Identity         = $_.Identity
                Released         = $_.Released
            }
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-QuarantinedEmailMessages.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-QuarantinedEmailMessages.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

