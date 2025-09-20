---
layout: post
title: New-PSDriveRootFolder.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-PSDriveRootFolder/
categories:
  - UserAdminModule
  - FileOperations
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

Creates PowerShell drives for all folders in a given path.

#### Detailed Description

The `New-PSDriveRootFolder` function creates PowerShell drives for all folders in a specified root folder. It iterates through each folder in the root path, creating a PSDrive for each one. The function validates the specified path and handles errors gracefully.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-PSDriveRootFolder -FolderPath "C:\Users\username\Documents\WindowsPowerShell\Modules"
```

Creates PS Drives for all subfolders in the specified path.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Ensure you have the necessary permissions to create PS Drives for the specified folders.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-PSDriveRootFolder {
	<#
    .SYNOPSIS
    Creates PowerShell drives for all folders in a given path.

    .DESCRIPTION
    The `New-PSDriveRootFolder` function creates PowerShell drives for all folders in a specified root folder. 
    It iterates through each folder in the root path, creating a PSDrive for each one. The function validates 
    the specified path and handles errors gracefully.

    .PARAMETER FolderPath
    The root folder for which to create PS Drives.

    .EXAMPLE
    New-PSDriveRootFolder -FolderPath "C:\Users\username\Documents\WindowsPowerShell\Modules"
    Creates PS Drives for all subfolders in the specified path.

    .NOTES
    Ensure you have the necessary permissions to create PS Drives for the specified folders.

    .LINK
    # Add relevant links if necessary
    #>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateScript({
				if (Test-Path $_ -PathType Container) {
					$true
				}
				else {
					throw "Path `$_` is not a valid directory."
				}
			})]
		[string]$FolderPath
	)

	# Get all directories in the specified path
	$PSDrivePaths = Get-ChildItem -Path "$FolderPath" -Directory

	# Initialize progress tracking variables
	$totalItems = $PSDrivePaths.Count
	$currentItem = 0

	foreach ($item in $PSDrivePaths) {
		$currentItem++
		Write-Progress -Activity "Creating PS Drives" -Status "Processing Item $currentItem of $totalItems" -PercentComplete (($currentItem / $totalItems) * 100)

		try {
			# Ensure the path exists
			if (Test-Path -Path $item.FullName) {
				# Generate a valid drive name by removing invalid characters
				$driveName = $item.Name -replace '[;~\/\.:]', ''

				# Check if the PSDrive already exists and handle naming conflicts
				$originalDriveName = $driveName
				$index = 1
				while (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue) {
					$driveName = "$originalDriveName$index"
					$index++
				}

				# Create the new PSDrive
				New-PSDrive -Name $driveName -PSProvider "FileSystem" -Root $item.FullName -Scope Global
				Write-Verbose "Drive $driveName created successfully."
			}
		}
		catch {
			Write-Warning "Error creating drive {$driveName}: $_"
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/New-PSDriveRootFolder.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-PSDriveRootFolder.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

