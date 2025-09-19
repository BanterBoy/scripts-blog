---
layout: post
title: Get-Lines.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-Lines/
categories:
  - UserAdminModule
  - Utilities
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

Counts the number of lines in a file.

#### Detailed Description

The Get-Lines function counts the number of lines in a file or multiple files. It accepts either a path or a literal path as input and returns an object with the file name and the number of lines in each file.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-Lines -Path "C:\Files\file.txt"
```

Counts the number of lines in the file "C:\Files\file.txt" and returns an object with the file name and the number of lines.

**Example 2**

```powershell
Get-ChildItem -Path "C:\Files" -Recurse | Get-Lines
```

Counts the number of lines in all files in the "C:\Files" directory and its subdirectories, and returns an object with the file name and the number of lines for each file.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-Lines {
    <#
    .SYNOPSIS
    Counts the number of lines in a file.

    .DESCRIPTION
    The Get-Lines function counts the number of lines in a file or multiple files. It accepts either a path or a literal path as input and returns an object with the file name and the number of lines in each file.

    .PARAMETER Path
    Specifies the path(s) to the file(s) for which the number of lines should be counted. Wildcards are supported.

    .PARAMETER LiteralPath
    Specifies the literal path(s) to the file(s) for which the number of lines should be counted. This parameter is an alias for the Path parameter.

    .EXAMPLE
    Get-Lines -Path "C:\Files\file.txt"
    Counts the number of lines in the file "C:\Files\file.txt" and returns an object with the file name and the number of lines.

    .EXAMPLE
    Get-ChildItem -Path "C:\Files" -Recurse | Get-Lines
    Counts the number of lines in all files in the "C:\Files" directory and its subdirectories, and returns an object with the file name and the number of lines for each file.

    .NOTES
    Author: Your Name
    Date:   Current Date
    #>

    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath
    )

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        # Process each item in resolved paths
        foreach ($item in $resolvedPaths) {
            $fileItem = Get-Item -LiteralPath $item
            $content = $fileItem | Get-Content
            [pscustomobject]@{
                Path  = $fileItem.Name
                Lines = $content.Count
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-Lines.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Lines.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

