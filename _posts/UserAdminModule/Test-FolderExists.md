---
layout: post
title: Test-FolderExists.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-FolderExists/
categories:
  - UserAdminModule
  - Testing
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

Tests if a specified folder exists and creates it if it does not.

#### Detailed Description

This function takes a file path as input, checks if the folder exists, and creates the folder if it does not exist. It provides verbose output for the operations performed.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-FolderExists -Path "C:\Temp\MyFolder" -Verbose
```

Tests if the folder "C:\Temp\MyFolder" exists and creates it if it does not.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Tests if a specified folder exists and creates it if it does not.

.DESCRIPTION
    This function takes a file path as input, checks if the folder exists, and creates the folder if it does not exist. It provides verbose output for the operations performed.

.PARAMETER Path
    The file path to test. If the folder does not exist, it will be created.

.EXAMPLE
    PS C:\> Test-FolderExists -Path "C:\Temp\MyFolder" -Verbose
    Tests if the folder "C:\Temp\MyFolder" exists and creates it if it does not.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-FolderExists {
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
            HelpMessage = 'Enter the file path to test. If folder does not exist, it will be created.'
        )]
        [ValidateScript(
            {
                # Check if the specified path is a valid container path
                if (Test-Path $_ -PathType Container) {
                    Write-Verbose -Message "Folder exists: $_"
                    $true
                }
                else {
                    Write-Verbose -Message "Folder does not exist: $_"
                    $false
                }
            }
        )]
        [string]$Path
    )

    BEGIN {
        Write-Verbose "Starting the Test-FolderExists function."
    }

    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Testing if this path exists...")) {
            if (Test-Path $Path -PathType Container) {
                Write-Verbose -Message "$Path - Folder exists, yay!"
            }
            else {
                Write-Verbose -Message "$Path - Folder does not exist. Creating folder..."
                try {
                    New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
                    Write-Verbose -Message "$Path - Folder created successfully."
                }
                catch {
                    Write-Error -Message "Failed to create folder at {$Path}: $_"
                }
            }
        }
    }

    END {
        Write-Verbose "Test-FolderExists function completed."
    }
}

# Example call to the function with verbose output
# Test-FolderExists -Path "C:\Temp\MyFolder" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-FolderExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-FolderExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

