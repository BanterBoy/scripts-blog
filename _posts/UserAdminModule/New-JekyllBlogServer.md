---
layout: post
title: New-JekyllBlogServer.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-JekyllBlogServer/
categories:
  - UserAdminModule
  - JekyllBlog
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

Starts a Jekyll blog server using Docker Compose.

#### Detailed Description

The New-JekyllBlogServer function starts a Jekyll blog server using Docker Compose. It provides two parameter sets: 'Select' and 'Blog'.

- 'Select' parameter set prompts the user to select a folder location and then starts the blog server in that location.

- 'Blog' parameter set starts the blog server in the specified path.

- If no parameter set is specified, it prompts the user to select a folder location and starts the blog server in that location.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-JekyllBlogServer -BlogPath 'Select'
```

Starts the Jekyll blog server by prompting the user to select a folder location.

**Example 2**

```powershell
New-JekyllBlogServer -BlogPath 'Blog' -Path 'C:\MyBlog'
```

Starts the Jekyll blog server in the 'C:\MyBlog' path.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
	Starts a Jekyll blog server using Docker Compose.

.DESCRIPTION
	The New-JekyllBlogServer function starts a Jekyll blog server using Docker Compose. It provides two parameter sets: 'Select' and 'Blog'.
	- 'Select' parameter set prompts the user to select a folder location and then starts the blog server in that location.
	- 'Blog' parameter set starts the blog server in the specified path.
	- If no parameter set is specified, it prompts the user to select a folder location and starts the blog server in that location.

.PARAMETER BlogPath
	Specifies the parameter set to use. Valid values are 'Select' and 'Blog'.
	- 'Select': Prompts the user to select a folder location and starts the blog server in that location.
	- 'Blog': Starts the blog server in the specified path.

.PARAMETER Path
	Specifies the path where the blog server should be started. Only used when 'Blog' parameter set is selected.

.EXAMPLE
	New-JekyllBlogServer -BlogPath 'Select'
	Starts the Jekyll blog server by prompting the user to select a folder location.

.EXAMPLE
	New-JekyllBlogServer -BlogPath 'Blog' -Path 'C:\MyBlog'
	Starts the Jekyll blog server in the 'C:\MyBlog' path.

#>
function New-JekyllBlogServer {
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param(
		[Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter path or Browse to select dockerfile")]
		[ValidateSet('Select', 'Blog')]
		[string]$BlogPath,
		[string]$Path
	)
	switch ($BlogPath) {
		Select {
			try {
				$PSRootFolder = Select-FolderLocation
				Set-Location -Path $PSRootFolder
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Blog {
			try {
				Set-Location -Path $Path
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Default {
			try {
				Set-Location -Path $PSRootFolder
				$PSRootFolder = Select-FolderLocation
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/JekyllBlog/Public/New-JekyllBlogServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-JekyllBlogServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

