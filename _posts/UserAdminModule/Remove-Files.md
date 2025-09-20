---
layout: post
title: Remove-Files.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-Files/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- Files
description: Removes an array of files.
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

Removes an array of files.

#### Detailed Description

The Remove-Files function takes an array of file paths and removes each file. It supports verbose output and handles errors gracefully. This function also supports the `ShouldProcess` method for safety.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-Files -Files "C:\temp\file1.txt", "C:\temp\file2.txt"
```

This example removes the files "file1.txt" and "file2.txt" from the "C:\temp" directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: [Author Name] Date: [Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-Files {
    <#
    .SYNOPSIS
        Removes an array of files.

    .DESCRIPTION
        The Remove-Files function takes an array of file paths and removes each file. It supports verbose output and handles errors gracefully. This function also supports the `ShouldProcess` method for safety.

    .PARAMETER Files
        An array of file paths to be removed.

    .EXAMPLE
        Remove-Files -Files "C:\temp\file1.txt", "C:\temp\file2.txt"
        This example removes the files "file1.txt" and "file2.txt" from the "C:\temp" directory.

    .NOTES
        Author: [Author Name]
        Date: [Date]
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Files
    )

    begin {
        Write-Verbose -Message "Starting file removal process for $($Files.Count) files"
    }

    process {
        $Files | ForEach-Object -Process {
            # Check if the file exists before attempting to remove it
            if (Test-Path -Path $_ -PathType Leaf) {
                if ($PSCmdlet.ShouldProcess("$($_)", "Deleting file...")) {
                    Write-Verbose -Message "Removing file $($_)"
                    try {
                        Remove-Item -Path $_ -Force
                        Write-Verbose -Message "Successfully removed file $($_)"
                    }
                    catch {
                        Write-Error -Message "Failed to remove file $($_) - $_"
                    }
                }
            }
            else {
                Write-Warning -Message "File $($_) does not exist."
            }
        }
    }

    end {
        Write-Verbose -Message "File removal process completed."
    }
}

# Example Usage:
# Remove-Files -Files "C:\temp\file1.txt", "C:\temp\file2.txt" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Remove-Files.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-Files.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

