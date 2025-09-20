---
layout: post
title: Show-JekyllBlogSite.ps1
date: 2025-09-19
permalink: /useradminmodule/jekyllblog/show-jekyllblogsite/
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

Opens the local Jekyll blog site in the default web browser.

#### Detailed Description

This function constructs the local URL for the Jekyll blog site using the computer's DNS name and network profile. It then opens this URL in the default web browser.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Show-JekyllBlogSite
```

This example opens the local Jekyll blog site in the default web browser.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 30/06/2024

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Show-JekyllBlogSite {
	<#
    .SYNOPSIS
        Opens the local Jekyll blog site in the default web browser.

    .DESCRIPTION
        This function constructs the local URL for the Jekyll blog site using the computer's DNS name and network profile. 
        It then opens this URL in the default web browser.

    .PARAMETER None
        This function does not take any parameters.

    .OUTPUTS
        None. Opens the URL in the default web browser.

    .EXAMPLE
        PS C:\> Show-JekyllBlogSite
        This example opens the local Jekyll blog site in the default web browser.

    .NOTES
        Author: Your Name
        Date: 30/06/2024

    .LINK
        https://github.com/YourGitHubProfile
    #>

	[CmdletBinding()]
	param()

	begin {
		Write-Verbose "Initializing Show-JekyllBlogSite function"
	}

	process {
		try {
			Write-Verbose "Retrieving computer name and network profile"
			$ComputerDNSName = $env:COMPUTERNAME + '.' + (Get-NetIPConfiguration | Select-Object -ExpandProperty NetProfile).Name
			$URL = "http://" + $ComputerDNSName + ":4000"
			Write-Verbose "Constructed URL: $URL"
            
			Write-Verbose "Opening the URL in the default web browser"
			Start-Process $URL
		}
		catch {
			Write-Error "An error occurred while trying to open the Jekyll blog site: $_"
		}
	}

	end {
		Write-Verbose "Completed Show-JekyllBlogSite function"
	}
}

# Example usage:
# Show-JekyllBlogSite -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/JekyllBlog/Public/Show-JekyllBlogSite.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Show-JekyllBlogSite.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

