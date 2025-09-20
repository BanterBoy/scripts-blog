---
layout: post
title: Test-FileExists.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Test-FileExists/
categories:
- UserAdminModule
- Testing
tags:
- PowerShell
- User Admin Module
- File Exists
description: Tests whether a file exists at the specified path.
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

Tests whether a file exists at the specified path.

#### Detailed Description

The Test-FileExists function tests whether a file exists at the specified path. If the file exists, the function returns $true. If the file does not exist, the function returns $false, unless the -Create switch is specified, in which case the function creates a new file at the specified path and returns $true.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Test-FileExists -Path "C:\Temp\test.txt"
```

Returns $true if a file named "test.txt" exists in the C:\Temp directory.

**Example 2**

```powershell
Test-FileExists -Path "C:\Temp\test.txt" -Create
```

Creates a new file named "test.txt" in the C:\Temp directory and returns $true.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Date: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Tests whether a file exists at the specified path.

.DESCRIPTION
The Test-FileExists function tests whether a file exists at the specified path. If the file exists, the function returns $true. If the file does not exist, the function returns $false, unless the -Create switch is specified, in which case the function creates a new file at the specified path and returns $true.

.PARAMETER Path
The path to the file to test.

.PARAMETER Create
If specified, creates a new file at the specified path if the file does not already exist.

.EXAMPLE
Test-FileExists -Path "C:\Temp\test.txt"
Returns $true if a file named "test.txt" exists in the C:\Temp directory.

.EXAMPLE
Test-FileExists -Path "C:\Temp\test.txt" -Create
Creates a new file named "test.txt" in the C:\Temp directory and returns $true.

.INPUTS
None.

.OUTPUTS
System.Boolean

.NOTES
Author: Unknown
Date: Unknown
#>
function Test-FileExists {
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true
    )]
    param
    (
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'Enter the file path to test.'
        )]
        [string]
        $Path,

        [Parameter(
            ParameterSetName = 'Default'
        )]
        [switch]
        $Create
    )
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Testing this path...")) {
            $fileExists = Test-Path $Path -PathType Leaf
            if ($fileExists) {
                Write-Verbose -Message "File Exists."
            }
            else {
                Write-Verbose -Message "File does not exist."
                if ($Create) {
                    New-Item -ItemType File -Path $Path | Out-Null
                    Write-Verbose -Message "File created."
                    $fileExists = $true
                }
            }
            return $fileExists
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-FileExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-FileExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

