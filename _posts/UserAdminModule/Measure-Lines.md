---
layout: post
title: Measure-Lines.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Measure-Lines/
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

Measures the number of lines, words, and characters in one or more files.

#### Detailed Description

The Measure-Lines function measures the number of lines, words, and characters in one or more files. It provides flexibility to measure specific aspects of the file content, such as lines, words, or characters, or measure all aspects at once.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Measure-Lines -Path "C:\Files\File1.txt", "C:\Files\File2.txt" -Lines -Words
```

Measure the number of lines and words in the specified files.

**Example 2**

```powershell
Measure-Lines -LiteralPath "C:\Files\File1.txt" -Characters -Recurse
```

Measure the number of characters in the specified file and its subdirectories.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Measures the number of lines, words, and characters in one or more files.

.DESCRIPTION
    The Measure-Lines function measures the number of lines, words, and characters in one or more files. It provides flexibility to measure specific aspects of the file content, such as lines, words, or characters, or measure all aspects at once.

.PARAMETER Path
    Specifies the path to one or more files. This parameter is mandatory when using the 'Path' parameter set.

.PARAMETER LiteralPath
    Specifies the literal path to a single file. This parameter is mandatory when using the 'LiteralPath' parameter set.

.PARAMETER Lines
    Indicates whether to measure the number of lines in the file(s). By default, this parameter is set to $false.

.PARAMETER Words
    Indicates whether to measure the number of words in the file(s). By default, this parameter is set to $false.

.PARAMETER Characters
    Indicates whether to measure the number of characters in the file(s). By default, this parameter is set to $false.

.PARAMETER All
    Indicates whether to measure all aspects (lines, words, and characters) of the file(s). When this parameter is used, the 'Lines', 'Words', and 'Characters' parameters are ignored.

.PARAMETER Recurse
    Indicates whether to search for files recursively in the specified path(s). This parameter is only applicable when using the 'Path' or 'PathAll' parameter set.

.EXAMPLE
    Measure-Lines -Path "C:\Files\File1.txt", "C:\Files\File2.txt" -Lines -Words
    Measure the number of lines and words in the specified files.

.EXAMPLE
    Measure-Lines -LiteralPath "C:\Files\File1.txt" -Characters -Recurse
    Measure the number of characters in the specified file and its subdirectories.

#>
function Measure-Lines {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path',
            HelpMessage = 'Enter one or more filenames',
            Position = 0)]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'PathAll',
            Position = 0)]
        [string[]]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPathAll')]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'LiteralPath',
            HelpMessage = 'Enter a single filename',
            ValueFromPipeline = $true)]
        [string]$LiteralPath,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Lines,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Words,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Characters,

        [Parameter(Mandatory = $true, ParameterSetName = 'PathAll')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPathAll')]
        [switch]$All,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'PathAll')]
        [switch]$Recurse
    )

    begin {
        if ($All) {
            $Lines = $Words = $Characters = $true
        }
        elseif (($Words -eq $false) -and ($Characters -eq $false)) {
            $Lines = $true
        }

        if ($Path) {
            $Files = Get-ChildItem -Path $Path -Recurse:$Recurse
        }
        else {
            $Files = Get-ChildItem -LiteralPath $LiteralPath
        }
    }
    process {
        foreach ($file in $Files) {
            $result = [ordered]@{ }
            $result.Add('File', $file.fullname)

            $content = Get-Content -LiteralPath $file.fullname

            if ($Lines) { $result.Add('Lines', $content.Length) }

            if ($Words) {
                $wc = 0
                foreach ($line in $content) { $wc += $line.split(' ').Length }
                $result.Add('Words', $wc)
            }

            if ($Characters) {
                $cc = 0
                foreach ($line in $content) { $cc += $line.Length }
                $result.Add('Characters', $cc)
            }

            New-Object -TypeName psobject -Property $result
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Measure-Lines.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Measure-Lines.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

