---
layout: post
title: Update-PowerShell.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/update-powershell/
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

Installs the latest version of PowerShell 7.

#### Detailed Description

This function checks for the existing installation of PowerShell 7 and installs the latest version if it's not already installed.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Update-PowerShell -Verbose
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Installs the latest version of PowerShell 7.

.DESCRIPTION
    This function checks for the existing installation of PowerShell 7 and installs the latest version if it's not already installed.

.NOTES
    Author: Your Name
    Date: Today's Date

.EXAMPLE
    Update-PowerShell -Verbose
#>

function Update-PowerShell {
    [CmdletBinding()]
    param ()

    begin {
        Write-Verbose "Checking for existing installation of PowerShell 7..."
    }

    process {
        $installedVersion = $null
        $latestVersion = $null

        # Check for existing installation
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            $installedVersion = (pwsh --version).Split(" ")[-1]
            Write-Verbose "Installed PowerShell 7 version: $installedVersion"

            try {
                $latestVersion = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).tag_name.Replace("v", "")
                Write-Verbose "Latest PowerShell 7 version available: $latestVersion"
            }
            catch {
                Write-Error "Failed to retrieve the latest version of PowerShell 7: $_"
                return
            }

            if ($installedVersion -eq $latestVersion) {
                Write-Output "The latest version of PowerShell 7 ($latestVersion) is already installed."
                return
            }
            else {
                Write-Output "An older version of PowerShell 7 ($installedVersion) is installed. The latest version is $latestVersion."
            }
        }

        # Attempt to install PowerShell 7
        try {
            Write-Verbose "Attempting to install PowerShell 7..."
            if ($IsWindows) {
                Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
            }
            elseif ($IsLinux) {
                curl -sSL https://aka.ms/install-powershell.sh | sudo bash
            }
            elseif ($IsMacOS) {
                brew install --cask powershell
            }
            else {
                Write-Error "Unsupported platform. This script supports Windows, Linux, and macOS only."
                return
            }
            Write-Verbose "PowerShell 7 installed successfully."
        }
        catch {
            Write-Error "Failed to install PowerShell 7: $_"
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Update-PowerShell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-PowerShell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

