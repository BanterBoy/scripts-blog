---
layout: post
title: Install-PSTools.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Install-PSTools/
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

Installs or uninstalls PSTools.

#### Detailed Description

This script contains two functions: Install-PSTools and Uninstall-PSTools. Install-PSTools downloads and installs PSTools if it is not already installed. Uninstall-PSTools removes PSTools from the system.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Install-PSTools
```

Installs PSTools if it is not already installed.

**Example 2**

```powershell
Install-PSTools -Uninstall
```

Uninstalls PSTools from the system.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
	Installs or uninstalls PSTools.

.DESCRIPTION
	This script contains two functions: Install-PSTools and Uninstall-PSTools.
	Install-PSTools downloads and installs PSTools if it is not already installed.
	Uninstall-PSTools removes PSTools from the system.

.PARAMETER Uninstall
	Specifies whether to uninstall PSTools. If this switch is provided, the script will call the Uninstall-PSTools function.

.INPUTS
	None.

.OUTPUTS
	None.

.EXAMPLE
	Install-PSTools
	Installs PSTools if it is not already installed.

.EXAMPLE
	Install-PSTools -Uninstall
	Uninstalls PSTools from the system.

.NOTES
	Author: Your Name
	Date:   Current Date
#>

function Uninstall-PSTools {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param()

	if ($PSCmdlet.ShouldProcess('PSTools', 'Uninstall')) {
		Write-Verbose "Checking if PSTools is installed..."
		if (!(Test-Path 'C:\Program Files\Sysinternals\PsExec.exe')) {
			Write-Verbose "PSTools is not installed."
			return
		}

		try {
			Write-Verbose "Removing PSTools from 'C:\Program Files\Sysinternals\'..."
			Remove-Item -Path 'C:\Program Files\Sysinternals\' -Recurse -Force -ErrorAction Stop

			Write-Verbose "Removing 'C:\Program Files\Sysinternals\' from system and user 'Path'..."
			Remove-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'Machine'
			Remove-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'User'
		}
		catch {
			Write-Error "An error occurred: $_"
		}
	}
}

function Install-PSTools {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param(
		[switch] $Uninstall
	)

	if ($Uninstall) {
		Uninstall-PSTools
	}
	else {
		if ($PSCmdlet.ShouldProcess('PSTools', 'Install')) {
			Write-Verbose "Checking if PSTools is already installed..."
			if (Test-Path 'C:\Program Files\Sysinternals\PsExec.exe') {
				Write-Verbose "PSTools is already installed."
				return
			}

			try {
				# Paths
				$Temp = "C:\Temp\"
				$ZipTemp = $Temp + "\pstools.zip"
				$ZipTempExtract = $Temp + "\pstools\"

				Write-Verbose "Downloading PSTools..."
				Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile $ZipTemp -ErrorAction Stop
				Write-Verbose "Extracting PSTools..."
				Expand-Archive -Path $ZipTemp -DestinationPath $ZipTempExtract -Force -ErrorAction Stop

				Write-Verbose "Checking if 'C:\Program Files\Sysinternals\' directory exists..."
				if (!(Test-Path 'C:\Program Files\Sysinternals\')) {
					Write-Verbose "Creating 'C:\Program Files\Sysinternals\' directory..."
					New-Item -Path 'C:\Program Files\Sysinternals\' -ItemType Directory -Force | Out-Null
				}

				Write-Verbose "Copying PSTools to 'C:\Program Files\Sysinternals\'..."
				$Tools = Get-ChildItem -Path $ZipTempExtract -File -Recurse -Force
				$Tools | ForEach-Object {
					Copy-Item -Path $_.FullName -Destination 'C:\Program Files\Sysinternals\' -Force -ErrorAction Stop
				}

				Write-Verbose "Cleaning up temporary files..."
				Remove-Item -Path $ZipTemp -Force
				Remove-Item -Path $ZipTempExtract -Recurse -Force

				Write-Verbose "Checking if user is an administrator..."
				$test = Test-IsAdmin
				if ($test -eq $true) {
					Write-Verbose "User is an administrator. Adding 'C:\Program Files\Sysinternals\' to system 'Path'..."
					Add-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'Machine'
				}
				else {
					Write-Verbose "User is not an administrator. Adding 'C:\Program Files\Sysinternals\' to user 'Path'..."
					Add-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'User'
				}
			}
			catch {
				Write-Error "An error occurred: $_"
			}
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Install-PSTools.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-PSTools.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

