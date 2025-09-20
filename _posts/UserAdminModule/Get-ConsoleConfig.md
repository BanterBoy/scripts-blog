---
layout: post
title: Get-ConsoleConfig.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ConsoleConfig/
categories:
  - UserAdminModule
  - Shell
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

Retrieves the current console window and buffer sizes.

#### Detailed Description

This function retrieves and returns the current console window size (height and width) and buffer size (height and width).

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-ConsoleConfig
```

Retrieves the current console window and buffer sizes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-ConsoleConfig {
    <#
    .SYNOPSIS
        Retrieves the current console window and buffer sizes.

    .DESCRIPTION
        This function retrieves and returns the current console window size (height and width) and buffer size (height and width).

    .EXAMPLE
        PS C:\> Get-ConsoleConfig
        Retrieves the current console window and buffer sizes.

    .NOTES
        Author: Your Name
        Date: 2024-06-30
    #>

    [CmdletBinding()]
    param ()

    begin {
        Write-Verbose "Starting to retrieve the console settings."
    }

    process {
        try {
            $windowHeight = [System.Console]::WindowHeight
            $windowWidth = [System.Console]::WindowWidth
            $bufferHeight = [System.Console]::BufferHeight
            $bufferWidth = [System.Console]::BufferWidth

            Write-Verbose "Successfully retrieved console settings."

            [PSCustomObject]@{
                WindowHeight = $windowHeight
                WindowWidth  = $windowWidth
                BufferHeight = $bufferHeight
                BufferWidth  = $bufferWidth
            }
        }
        catch {
            Write-Error "Failed to retrieve console configuration. Error: $_"
        }
    }

    end {
        Write-Verbose "Completed retrieving the console settings."
    }
}

# Example usage:
# Get-ConsoleConfig
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-ConsoleConfig.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ConsoleConfig.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

