---
layout: post
title: Get-MoreCowbell.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-MoreCowbell/
categories:
- UserAdminModule
- Shell
tags:
- PowerShell
- User Admin Module
- More Cowbell
description: No synopsis provided.
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-MoreCowbell
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Introduction,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$Repeat = 10,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$CowbellUrl = 'http://emmanuelprot.free.fr/Drums%20kit%20Manu/Cowbell.wav',
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$IntroUrl = 'http://www.innervation.com/crap/cowbell.wav'
		
		
	)
	begin {
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
	}
	process {
		try
		{
			$sound = New-Object System.Media.SoundPlayer

			# Resolve a stable base path for resources (module base -> script root -> script path -> current directory)
			$basePath = $null
			if ($PSScriptRoot) {
				$basePath = $PSScriptRoot
			} elseif ($MyInvocation.MyCommand.Module -and $MyInvocation.MyCommand.Module.ModuleBase) {
				$basePath = $MyInvocation.MyCommand.Module.ModuleBase
			} elseif ($MyInvocation.MyCommand.Path) {
				$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path
			} else {
				$basePath = (Get-Location).Path
			}

			# Ensure the resources directory exists
			$resourceDir = Join-Path $basePath 'resources'
			if (-not (Test-Path -Path $resourceDir -PathType Container)) {
				New-Item -Path $resourceDir -ItemType Directory -Force | Out-Null
			}

			$CowBellLoc = Join-Path $resourceDir 'Cowbell.wav'
			if (-not (Test-Path -Path $CowBellLoc -PathType Leaf)) {
				Invoke-WebRequest -Uri $CowbellUrl -OutFile $CowBellLoc -ErrorAction Stop
			}

			if ($Introduction.IsPresent) {
				$IntroLoc = Join-Path $resourceDir 'CowbellIntro.wav'
				if (-not (Test-Path -Path $IntroLoc -PathType Leaf)) {
					Invoke-WebRequest -Uri $IntroUrl -OutFile $IntroLoc -ErrorAction Stop
				}
				$sound.SoundLocation = $IntroLoc
				$sound.Load()
				$sound.Play()
				Start-Sleep -Seconds 2
			}

			$sound.SoundLocation = $CowBellLoc
			for ($i = 0; $i -lt $Repeat; $i++) {
				$sound.Play()
				Start-Sleep -Milliseconds 500
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-MoreCowbell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MoreCowbell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

