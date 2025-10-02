---
layout: post
title: Get-OldFiles.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/get-oldfiles/
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

Gets files that are older than a specified number of days.

#### Detailed Description

The Get-OldFiles function gets files that are older than a specified number of days. It accepts a mandatory parameter Path, which specifies the path to search for files. It also accepts an optional parameter Days, which specifies the number of days to look back for files. By default, it looks back 1 day. The function also accepts an optional parameter FileName, which specifies the name of the file to search for. By default, it searches for all files. The function also accepts optional switches Recurse and Summarize, which specify whether to search recursively and whether to summarize the results, respectively.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-OldFiles -Path "C:\Logs" -Days 7 -FileName "*.log" -Recurse -Summarize
```

Found 10 *.log files older than 7 days with a total size of 1.23 GB This example gets all *.log files in the C:\Logs directory and its subdirectories that are older than 7 days. It summarizes the results by displaying the number of files found and their total size.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-OldFiles {

    <#
    .SYNOPSIS
        Gets files that are older than a specified number of days.

    .DESCRIPTION
        The Get-OldFiles function gets files that are older than a specified number of days. It accepts a mandatory parameter Path, which specifies the path to search for files. It also accepts an optional parameter Days, which specifies the number of days to look back for files. By default, it looks back 1 day. The function also accepts an optional parameter FileName, which specifies the name of the file to search for. By default, it searches for all files. The function also accepts optional switches Recurse and Summarize, which specify whether to search recursively and whether to summarize the results, respectively.

    .PARAMETER Path
        Specifies the path to search for files.

    .PARAMETER Days
        Specifies the number of days to look back for files. By default, it looks back 1 day.

    .PARAMETER FileName
        Specifies the name of the file to search for. By default, it searches for all files.

    .PARAMETER Recurse
        Specifies whether to search recursively.

    .PARAMETER Summarize
        Specifies whether to summarize the results.

    .EXAMPLE
        PS C:\> Get-OldFiles -Path "C:\Logs" -Days 7 -FileName "*.log" -Recurse -Summarize
        Found 10 *.log files older than 7 days with a total size of 1.23 GB

        This example gets all *.log files in the C:\Logs directory and its subdirectories that are older than 7 days. It summarizes the results by displaying the number of files found and their total size.

    .INPUTS
        None.

    .OUTPUTS
        System.IO.FileInfo

    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [int]$Days = 1,
        [string]$FileName = "*.*",
        [switch]$Recurse,
        [switch]$Summarize
    )

    begin {
        Write-Verbose -Message "Starting processing of $($FileName) files older than $($Days) days"
        $TotalSize = 0
    }

    process {
        $ChildItemParams = @{
            LiteralPath = $Path
            File        = $true
            Recurse     = $Recurse.IsPresent
            Filter      = $FileName
        }

        $OldFiles = Get-ChildItem @ChildItemParams | Where-Object -FilterScript {
            $_.LastWriteTime -lt (Get-Date).AddDays(-$Days)
        }

        if ($Summarize) {
            $TotalSize = $OldFiles | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
            $FriendlySize = Get-FriendlySize -Bytes $TotalSize
            Write-Verbose -Message "Found $($OldFiles.Count) $($FileName) files older than $($Days) days with a total size of $($FriendlySize.FriendlySize)"
            return "Found $($OldFiles.Count) $($FileName) files older than $($Days) days with a total size of $($FriendlySize.FriendlySize)"
        }
        else {
            Write-Verbose -Message "Found $($OldFiles.Count) $($FileName) files older than $($Days) days"
            return $OldFiles
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Get-OldFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-OldFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

