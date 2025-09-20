---
layout: post
title: Remove-JekyllBlogServer.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-JekyllBlogServer/
categories:
- UserAdminModule
- JekyllBlog
tags:
- PowerShell
- User Admin Module
- Jekyll Blog Server
description: Cleans up the Jekyll blog environment by removing Docker images and specific
  directories and files.
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

Cleans up the Jekyll blog environment by removing Docker images and specific directories and files.

#### Detailed Description

This function prompts the user to confirm the cleanup of the Jekyll blog environment. If confirmed, it removes Docker images related to Jekyll and specific directories and files associated with the Jekyll environment.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-JekyllBlogServer
```

Prompts the user for confirmation and then performs the cleanup of the Jekyll blog environment if confirmed.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-JekyllBlogServer {
	<#
    .SYNOPSIS
        Cleans up the Jekyll blog environment by removing Docker images and specific directories and files.

    .DESCRIPTION
        This function prompts the user to confirm the cleanup of the Jekyll blog environment. If confirmed, it removes Docker images related to Jekyll and specific directories and files associated with the Jekyll environment.

    .EXAMPLE
        Remove-JekyllBlogServer
        Prompts the user for confirmation and then performs the cleanup of the Jekyll blog environment if confirmed.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

	[CmdletBinding()]
	param ()

	# Prompt the user for confirmation
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

	if ($decision -eq 0) {
		# Prompt user to select a directory
		$directoryPath = Select-FolderLocation

		if (![string]::IsNullOrEmpty($directoryPath)) {
			Write-Output "You selected the directory: $directoryPath"
		}
		else {
			Write-Output "You did not select a directory."
			return
		}

		Write-Output 'Cleaning Environment - Removing Docker Images'
		$images = docker images jekyll/jekyll:latest -q

		foreach ($image in $images) {
			Write-Verbose -Message "Removing Docker image $image" -Verbose
			docker image rm $image -f
		}

		# Remove exited containers related to Jekyll
		$jekyllContainers = docker ps -a --filter ancestor=jekyll/jekyll:latest -q
		foreach ($container in $jekyllContainers) {
			Write-Verbose -Message "Removing Docker container $container" -Verbose
			docker rm $container -f
		}

		# Define paths to remove
		$pathsToRemove = @{
			"Vendor Bundle"    = "$directoryPath\vendor"
			"_site Folder"     = "$directoryPath\_site"
			"Gemfile.lock"     = "$directoryPath\gemfile.lock"
			".jekyll-metadata" = "$directoryPath\.jekyll-metadata"
			".jekyll-cache"    = "$directoryPath\.jekyll-cache"
		}

		foreach ($path in $pathsToRemove.GetEnumerator()) {
			if (Test-Path -Path $path.Value) {
				Write-Warning -Message "Cleaning Environment - Removing $($path.Key)"
				try {
					Remove-Item -Path $path.Value -Recurse -Force -ErrorAction Stop
					Write-Verbose -Message "$($path.Key) removed." -Verbose
				}
				catch {
					Write-Verbose -Message "Failed to remove $($path.Key): $_" -Verbose
				}
			}
			else {
				Write-Verbose -Message "$($path.Key) does not exist." -Verbose
			}
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/JekyllBlog/Public/Remove-JekyllBlogServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-JekyllBlogServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

