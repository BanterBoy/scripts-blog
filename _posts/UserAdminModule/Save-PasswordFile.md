---
layout: post
title: Save-PasswordFile.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Save-PasswordFile/
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

Saves a secure password to a file.

#### Detailed Description

This function saves a secure password to a file with the specified label. The user can choose to save the password in a predefined profile path or select a custom path.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Save-PasswordFile -Label UserName
```

Prompts for a password and saves it to a file named 'UserName.txt' in the profile path.

**Example 2**

```powershell
Save-PasswordFile -Label Password -Path Select
```

Prompts for a password and allows the user to select a folder to save the password file named 'Password.txt'.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Save-PasswordFile {
	<#
    .SYNOPSIS
        Saves a secure password to a file.

    .DESCRIPTION
        This function saves a secure password to a file with the specified label. The user can choose to save the password 
        in a predefined profile path or select a custom path.

    .PARAMETER Label
        The label for the password file.

    .PARAMETER Path
        The path where the password file will be saved. Options are 'Profile' or 'Select'. If not specified, the default is 'Profile'.

    .EXAMPLE
        Save-PasswordFile -Label UserName
        Prompts for a password and saves it to a file named 'UserName.txt' in the profile path.

    .EXAMPLE
        Save-PasswordFile -Label Password -Path Select
        Prompts for a password and allows the user to select a folder to save the password file named 'Password.txt'.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true,
			HelpMessage = "Enter password label")]
		[string]$Label,

		[Parameter(Mandatory = $false,
			HelpMessage = "Enter file path.")]
		[ValidateSet('Profile', 'Select')]
		[string]$Path = 'Profile'
	)

	begin {
		Write-Verbose -Message "Starting Save-PasswordFile function"
	}

	process {
		$securePassword = Read-Host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString

		switch ($Path) {
			'Profile' {
				Write-Verbose -Message "Using profile path for password storage"
				$ProfilePath = Split-Path -Path $PROFILE
				$filePath = Join-Path -Path $ProfilePath -ChildPath "$Label.txt"
			}
			'Select' {
				Write-Verbose -Message "Allowing user to select a folder for password storage"
				$directoryPath = Select-FolderLocation
				if ([string]::IsNullOrEmpty($directoryPath)) {
					Write-Error "No directory selected. Exiting function."
					return
				}
				$filePath = Join-Path -Path $directoryPath -ChildPath "$Label.txt"
			}
		}

		Write-Verbose -Message "Saving password to $filePath"
		try {
			$securePassword | Out-File -FilePath $filePath
			Write-Verbose -Message "Password saved successfully to $filePath"
		}
		catch {
			Write-Error "Failed to save password: $_"
		}
	}

	end {
		Write-Verbose -Message "Completed Save-PasswordFile function"
	}
}

# Example Usage:
# Save-PasswordFile -Label UserName -Verbose
# Save-PasswordFile -Label Password -Path Select -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Save-PasswordFile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Save-PasswordFile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

