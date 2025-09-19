---
layout: post
title: New-OOHMessage.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-OOHMessage/
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

Generates an out of office message in HTML or plain text format and saves it to a file or returns it directly.

#### Detailed Description

The New-OOHMessage function generates an out of office message in HTML or plain text format with the specified return date, contact email, closing remark, and sender name. The generated message can be saved to a file or returned directly for use with Set-OOHMessage.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$msg = New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X" -PassThru
```

Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $msg -ExternalMessage $msg

**Example 2**

```powershell
New-OOHMessage -permanent -contactEmail "contact@example.com" -closingRemark "Best regards." -senderName "John Doe" -RelatesTo "Project X" -Format Text -PassThru | Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $_ -ExternalMessage $_
```

**Example 3**

```powershell
New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X"
```

# Returns file path object as before

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Website: https://blog.lukeleigh.com Twitter: https://twitter.com/luke_leighs

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Generates an out of office message in HTML or plain text format and saves it to a file or returns it directly.

.DESCRIPTION
    The New-OOHMessage function generates an out of office message in HTML or plain text format with the specified return date, contact email, closing remark, and sender name. The generated message can be saved to a file or returned directly for use with Set-OOHMessage.

.PARAMETER returnDate
    The return date of the sender in the format of "Day Month Year" (e.g., "31 December 2022"). Mandatory for temporary messages.

.PARAMETER contactEmail
    The email address to contact if the email relates to the specified subject.

.PARAMETER closingRemark
    The closing remark to include in the message.

.PARAMETER senderName
    The name of the sender.

.PARAMETER outputDirectory
    The directory to save the generated message file. The default value is the system temporary directory.

.PARAMETER RelatesTo
    The subject the email relates to. Mandatory for temporary messages.

.PARAMETER permanent
    Indicates that the out of office message is permanent. When set, the return date and subject are not required.

.PARAMETER FileName
    Custom filename for the message. If not set, uses default pattern.

.PARAMETER Format
    Output format for the message. Valid values are "HTML" (default) or "Text".

.PARAMETER PassThru
    If set, returns the message content directly instead of saving to a file. Useful for piping to Set-OOHMessage.

.EXAMPLE
    $msg = New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X" -PassThru
    Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $msg -ExternalMessage $msg

.EXAMPLE
    New-OOHMessage -permanent -contactEmail "contact@example.com" -closingRemark "Best regards." -senderName "John Doe" -RelatesTo "Project X" -Format Text -PassThru | Set-OOHMessage -Identity "user@example.com" -AutoReplyState "Enabled" -InternalMessage $_ -ExternalMessage $_

.EXAMPLE
    New-OOHMessage -returnDate "31 December 2022" -contactEmail "contact@example.com" -closingRemark "Thank you for your understanding." -senderName "John Doe" -RelatesTo "Project X"
    # Returns file path object as before

.NOTES
    Author: Luke Leigh
    Website: https://blog.lukeleigh.com
    Twitter: https://twitter.com/luke_leighs
#>

function New-OOHMessage {
    [CmdletBinding(DefaultParameterSetName = 'Temporary')]
    param (
        [string]$returnDate,
        [string]$contactEmail,
        [Parameter(Mandatory = $true, HelpMessage = "The closing remark to include in the message.")]
        [ValidateNotNullOrEmpty()]
        [string]$closingRemark,
        [Parameter(Mandatory = $true, HelpMessage = "The name of the sender.")]
        [ValidateNotNullOrEmpty()]
        [string]$senderName,
        [string]$RelatesTo,
        [Parameter(ParameterSetName = 'Permanent', HelpMessage = "Indicates that the out of office message is permanent.")]
        [switch]$permanent,
        [Parameter(Mandatory = $false, HelpMessage = "The directory to save the generated message file. The default value is the system temporary directory.")]
        [ValidateScript({ Test-Path $_ })]
        [string]$outputDirectory = $Env:Temp,
        [Parameter(Mandatory = $false, HelpMessage = "Custom filename for the message. If not set, uses default pattern.")]
        [string]$FileName,
        [Parameter(Mandatory = $false, HelpMessage = "Output format for the message. Valid values are 'HTML' (default) or 'Text'.")]
        [ValidateSet('HTML','Text')]
        [string]$Format = 'HTML',
        [Parameter(Mandatory = $false, HelpMessage = "If set, returns the message content directly instead of saving to a file.")]
        [switch]$PassThru,
        [Parameter(Mandatory = $false, HelpMessage = "If set, uses this custom message instead of the generated template.")]
        [string]$CustomMessage
    )

    begin {
        Write-Verbose "Starting New-OOHMessage function."
    }

    process {
        try {
            # Escape user input for HTML
            function Escape-HTML {
                param([string]$Text)
                $Text -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' -replace '"', '&quot;' -replace "'", '&#39;'
            }

            # Manual validation for template scenario
            if (-not $CustomMessage) {
                if ($permanent) {
                    if (-not $contactEmail) {
                        throw "contactEmail is required for permanent message template."
                    }
                } else {
                    if (-not $returnDate) {
                        throw "returnDate is required for temporary message template."
                    }
                    if (-not $RelatesTo) {
                        throw "RelatesTo is required for temporary message template."
                    }
                    if (-not $contactEmail) {
                        throw "contactEmail is required for temporary message template."
                    }
                }
                # Validate patterns
                if ($returnDate -and ($returnDate -notmatch '^\d{1,2} (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$')) {
                    throw "returnDate must be in the format 'Day Month Year' (e.g., '31 December 2022')."
                }
                if ($contactEmail -and ($contactEmail -notmatch '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')) {
                    throw "contactEmail must be a valid email address."
                }
            }

            $safeContactEmail = Escape-HTML $contactEmail
            $safeClosingRemark = Escape-HTML $closingRemark
            $safeSenderName = Escape-HTML $senderName
            $safeRelatesTo = if ($RelatesTo) { Escape-HTML $RelatesTo } else { '' }
            $safeReturnDate = if ($returnDate) { Escape-HTML $returnDate } else { '' }

            if ($CustomMessage) {
                if ($Format -eq 'Text') {
                    $outputContent = "$CustomMessage`r`n$closingRemark`r`n$senderName"
                } else {
                    $safeCustomMessage = Escape-HTML $CustomMessage
                    $outputContent = @"
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; font-size: 13px; }
        .message { margin-bottom: 20px; }
        .closing { font-style: italic; }
        .signature { font-weight: bold; }
    </style>
</head>
<body>
    <div class="message">$safeCustomMessage</div>
    <div class="closing">$safeClosingRemark</div>
    <div class="signature">$safeSenderName</div>
</body>
</html>
"@
                }
            } else {
                if ($Format -eq 'Text') {
                    $message = if ($permanent) {
                        "Thank you for your email. I am no longer with the Rail Delivery Group. Please direct any queries to $contactEmail."
                    } else {
                        "Thank you for your email. I am currently on leave and will return on $returnDate. I will respond to your email upon my return. If your email relates to $RelatesTo, please contact $contactEmail."
                    }
                    $outputContent = "$message`r`n$closingRemark`r`n$senderName"
                } else {
                    $message = if ($permanent) {
                        "Thank you for your email. I am no longer with the Rail Delivery Group. Please direct any queries to $safeContactEmail."
                    } else {
                        "Thank you for your email. I am currently on leave and will return on $safeReturnDate. I will respond to your email upon my return. If your email relates to $safeRelatesTo, please contact $safeContactEmail."
                    }
                    $outputContent = @"
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; font-size: 13px; }
        .message { margin-bottom: 20px; }
        .closing { font-style: italic; }
        .signature { font-weight: bold; }
    </style>
</head>
<body>
    <div class="message">$message</div>
    <div class="closing">$safeClosingRemark</div>
    <div class="signature">$safeSenderName</div>
</body>
</html>
"@
                }
            }

            if ($PassThru) {
                return $outputContent
            } else {
                # Generate the filename
                if ($FileName) {
                    $filename = $FileName
                } else {
                    $dateStr = Get-Date -Format "yyyyMMdd"
                    $nameStr = $safeSenderName -replace '\s', ''
                    $ext = ($Format -eq 'Text') ? 'txt' : 'html'
                    $filename = "OOHMessage_${dateStr}_${nameStr}.$ext"
                }
                $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $filename

                # Write the content to the specified file with UTF8 encoding
                Write-Verbose "Saving the message content to $outputFilePath."
                $outputContent | Out-File -FilePath $outputFilePath -Encoding UTF8 -Force

                Write-Information "Out of office message saved successfully to $outputFilePath."
                return [PSCustomObject]@{
                    FilePath = $outputFilePath
                    Success = $true
                }
            }
        }
        catch {
            Write-Error "Failed to create out of office message: $_"
            return [PSCustomObject]@{
                FilePath = $null
                Success = $false
                Error = $_
            }
        }
    }

    end {
        Write-Verbose "New-OOHMessage function execution completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/New-OOHMessage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-OOHMessage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

