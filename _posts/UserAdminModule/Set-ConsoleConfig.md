---
layout: post
title: Set-ConsoleConfig.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/set-consoleconfig/
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

Sets the console window and buffer size for the current session.

#### Detailed Description

Configures the console window size (height and width) and buffer size (height and width). Buffer height defaults to 9001. Buffer width defaults to window width if not specified. Includes parameter validation and robust error handling.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-ConsoleConfig -WindowHeight 40 -WindowWidth 120 -BufferHeight 10000 -BufferWidth 120
```

# Sets window height to 40, width to 120, buffer height to 10000, buffer width to 120.

**Example 2**

```powershell
Set-ConsoleConfig -WindowHeight 30 -WindowWidth 100
```

# Sets window height to 30, width to 100, buffer height to 9001, buffer width to 100.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: RDGScripts Maintainers Date: 2025-09-02

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Set-ConsoleConfig {
    <#
    .SYNOPSIS
        Sets the console window and buffer size for the current session.

    .DESCRIPTION
        Configures the console window size (height and width) and buffer size (height and width).
        Buffer height defaults to 9001. Buffer width defaults to window width if not specified.
        Includes parameter validation and robust error handling.

    .PARAMETER WindowHeight
        Height of the console window. Must be a positive integer.

    .PARAMETER WindowWidth
        Width of the console window. Must be a positive integer.

    .PARAMETER BufferHeight
        Height of the console buffer. Defaults to 9001. Must be a positive integer.

    .PARAMETER BufferWidth
        Width of the console buffer. Defaults to window width. Must be a positive integer.

    .EXAMPLE
        Set-ConsoleConfig -WindowHeight 40 -WindowWidth 120 -BufferHeight 10000 -BufferWidth 120
        # Sets window height to 40, width to 120, buffer height to 10000, buffer width to 120.

    .EXAMPLE
        Set-ConsoleConfig -WindowHeight 30 -WindowWidth 100
        # Sets window height to 30, width to 100, buffer height to 9001, buffer width to 100.

    .NOTES
        Author: RDGScripts Maintainers
        Date: 2025-09-02
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the height of the console window.")]
        [ValidateRange(1, 1000)]
        [int]$WindowHeight,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Enter the width of the console window.")]
        [ValidateRange(1, 1000)]
        [int]$WindowWidth,

        [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Enter the height of the console buffer. Defaults to 9001.")]
        [ValidateRange(1, 100000)]
        [int]$BufferHeight = 9001,

        [Parameter(Mandatory = $false, Position = 3, HelpMessage = "Enter the width of the console buffer. Defaults to the window width.")]
        [ValidateRange(1, 100000)]
        [int]$BufferWidth
    )

    begin {
        Write-Verbose "Starting to configure the console settings."
        if (-not $PSBoundParameters.ContainsKey('BufferWidth') -or $BufferWidth -le 0) {
            $BufferWidth = $WindowWidth
        }
    }

    process {
        try {
            Write-Verbose "Setting console window size to Height: $WindowHeight, Width: $WindowWidth"
            [System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
            Write-Verbose "Console window size set successfully."
        }
        catch {
            Write-Error "Failed to set console window size. Error: $($_.Exception.Message)"
            return
        }

        try {
            Write-Verbose "Setting console buffer size to Width: $BufferWidth, Height: $BufferHeight"
            [System.Console]::SetBufferSize($BufferWidth, $BufferHeight)
            Write-Verbose "Console buffer size set successfully."
        }
        catch {
            Write-Error "Failed to set console buffer size. Error: $($_.Exception.Message)"
        }
    }

    end {
        Write-Verbose "Completed configuring the console settings."
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Set-ConsoleConfig.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-ConsoleConfig.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

