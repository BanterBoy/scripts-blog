---
layout: post
title: Preview-QuarantinedEmailMessage.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/preview-quarantinedemailmessage/
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

Retrieves a preview of a quarantined email message.

#### Detailed Description

The Get-QuarantineMessagePreview function retrieves a preview of a quarantined email message based on the provided Identity.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-QuarantineMessagePreview -Identity "12345"
```

Retrieves a preview of the quarantined email message with the Identity "12345".

**Example 2**

```powershell
"12345", "67890" | Get-QuarantineMessagePreview
```

Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates pipeline input.

**Example 3**

```powershell
$emails = "12345", "67890"
```

$emails | Get-QuarantineMessagePreview Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates the use of a variable to store multiple identities and pipeline input.

**Example 4**

```powershell
Get-QuarantineMessagePreview -Identity "12345" | Format-List
```

Retrieves a preview of the quarantined email message with the Identity "12345" and formats the output as a list.

**Example 5**

```powershell
Get-QuarantineMessagePreview -Identity "12345" | Select-Object -Property Body
```

Retrieves a preview of the quarantined email message with the Identity "12345" and selects only the Body property from the output.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- The function supports pipeline input.

- The function supports ShouldProcess.

- For more information, visit: https://github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves a preview of a quarantined email message.

.DESCRIPTION
    The Get-QuarantineMessagePreview function retrieves a preview of a quarantined email message based on the provided Identity.

.PARAMETER Identity
    Specifies the Identity of the email to preview. This parameter is mandatory.

.OUTPUTS
    Returns a PSCustomObject with the following properties:
    - Identity: The Identity of the email.
    - ReceivedTime: The time the email was received.
    - SenderAddress: The sender's email address.
    - RecipientAddress: The recipient's email address(es).
    - Subject: The subject of the email.
    - Body: The plain text body of the email.
    - IsHtml: Indicates whether the email body is HTML.
    - Cc: The CC recipients of the email.
    - Attachment: The attachments of the email.
    - Urls: The URLs found in the email body.

.NOTES
    - The function supports pipeline input.
    - The function supports ShouldProcess.
    - For more information, visit: https://github.com/BanterBoy

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345"

    Retrieves a preview of the quarantined email message with the Identity "12345".

.EXAMPLE
    "12345", "67890" | Get-QuarantineMessagePreview

    Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates pipeline input.

.EXAMPLE
    $emails = "12345", "67890"
    $emails | Get-QuarantineMessagePreview

    Retrieves a preview of the quarantined email messages with the Identities "12345" and "67890". This example demonstrates the use of a variable to store multiple identities and pipeline input.

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345" | Format-List

    Retrieves a preview of the quarantined email message with the Identity "12345" and formats the output as a list.

.EXAMPLE
    Get-QuarantineMessagePreview -Identity "12345" | Select-Object -Property Body

    Retrieves a preview of the quarantined email message with the Identity "12345" and selects only the Body property from the output.
#>

function Get-QuarantineMessagePreview {
    [CmdletBinding(DefaultParameterSetName = 'Default', 
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'Default', 
            Mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            HelpMessage = 'Enter the Identity of the email to preview')]
        [string]$Identity
    )

    process {
        if ($PSCmdlet.ShouldProcess($Identity, "Preview quarantine message")) {
            try {
                $emailContent = Preview-QuarantineMessage -Identity $Identity
                
                # Decode HTML entities
                $decodedBody = [System.Net.WebUtility]::HtmlDecode($emailContent.Body)
                
                # Remove CSS styles
                $decodedBody = [System.Text.RegularExpressions.Regex]::Replace($decodedBody, '<style[^>]*>.*?</style>', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

                # Remove HTML tags for human-readable format
                $plainTextBody = [System.Text.RegularExpressions.Regex]::Replace($decodedBody, '<[^>]*>', '')

                # Remove blank lines including lines with spaces
                $plainTextBody = $plainTextBody -split "`r`n" | Where-Object { $_ -notmatch '^\s*$' } | Out-String

                # Extract URLs
                $urls = [System.Text.RegularExpressions.Regex]::Matches($plainTextBody, '(https?://[^\s]+)').Value

                # Format RecipientAddress
                $recipientAddresses = ($emailContent.RecipientAddress -join ', ')

                [PSCustomObject]@{
                    Identity         = $Identity
                    ReceivedTime     = $emailContent.ReceivedTime
                    SenderAddress    = $emailContent.SenderAddress
                    RecipientAddress = $recipientAddresses
                    Subject          = $emailContent.Subject
                    Body             = $plainTextBody
                    IsHtml           = $emailContent.IsHtml
                    Cc               = $emailContent.Cc
                    Attachment       = $emailContent.Attachment
                    Urls             = $urls
                }
            }
            catch {
                Write-Error "Failed to retrieve email details for Identity $Identity. Error: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Preview-QuarantinedEmailMessage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Preview-QuarantinedEmailMessage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

