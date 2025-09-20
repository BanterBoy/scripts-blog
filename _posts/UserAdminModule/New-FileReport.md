---
layout: post
title: New-FileReport.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/New-FileReport/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- File Report
description: Creates an HTML report.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Creates an HTML report.

#### Detailed Description

This function creates an HTML report that displays information about old files, including the number of files found, the newest and oldest file ages, and a table of the files with their last write time and file name. The report also includes a summary message.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> $OldFiles = Get-ChildItem -Path C:\Logs -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
```

PS C:\> $Summary = "Old log files have been cleaned up." PS C:\> New-FileReport -OldFiles $OldFiles -Summary $Summary -SaveReport This example creates an HTML report that displays information about old log files in the C:\Logs directory that were last modified more than 30 days ago. The report includes a summary message and is saved to the user's temporary folder.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-FileReport {

    <#
    .SYNOPSIS
        Creates an HTML report.

    .DESCRIPTION
        This function creates an HTML report that displays information about old files, including the number of files found, the newest and oldest file ages, and a table of the files with their last write time and file name. The report also includes a summary message.

    .PARAMETER OldFiles
        Specifies an array of old files to include in the report.

    .PARAMETER Summary
        Specifies a summary message to include in the report.

    .PARAMETER SaveReport
        Saves the report to the user's temporary folder if this switch is specified.

    .EXAMPLE
        PS C:\> $OldFiles = Get-ChildItem -Path C:\Logs -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
        PS C:\> $Summary = "Old log files have been cleaned up."
        PS C:\> New-FileReport -OldFiles $OldFiles -Summary $Summary -SaveReport

        This example creates an HTML report that displays information about old log files in the C:\Logs directory that were last modified more than 30 days ago. The report includes a summary message and is saved to the user's temporary folder.

    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$OldFiles,
        [Parameter(Mandatory = $true)]
        [string]$Summary,
        [switch]$SaveReport
    )

    $OldestFileAge = (Get-Date) - ($OldFiles | Sort-Object -Property LastWriteTime | Select-Object -First 1).LastWriteTime
    $NewestFileAge = (Get-Date) - ($OldFiles | Sort-Object -Property LastWriteTime | Select-Object -Last 1).LastWriteTime
    $OldestFileAgeDays = $OldestFileAge.Days
    $NewestFileAgeDays = $NewestFileAge.Days

    $Report = @"
<!DOCTYPE html>
<html>
<head>
    <style>
        h1 {
            color: blue;
            font-family: Calibri;
            font-size: 20px;
        }

        p {
            color: black;
            font-family: Calibri;
            font-size: 15px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            text-align: left;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div style="background-color:white;black:white;padding:20px;">
        <h1>Old Files Cleanup Report</h1>
        <hr>
        <p>Found $($OldFiles.Count) files</p>
        <p>The newest file is $NewestFileAgeDays days old</p>
        <p>The oldest file is $OldestFileAgeDays days old</p>
        <table>
            <tr>
                <th>Last Write Time</th>
                <th>File Name</th>
            </tr>
            $($OldFiles | Sort-Object -Property LastWriteTime | ForEach-Object -Process { "<tr><td>$($_.LastWriteTime)</td><td>$($_.FullName)</td></tr>" })
        </table>
        <hr>
        <p><strong><span style="border: 1px solid black;padding:4px;color:red;"> $Summary</span></strong></p>
    </div>
</body>
</html>
"@

    return $Report
    if ($SaveReport) {
        $Report | Out-File -FilePath $Env:TEMP\Report.html -Force
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/New-FileReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-FileReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

