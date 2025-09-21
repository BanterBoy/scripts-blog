---
layout: post
title: Start-JekyllBlogging.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/jekyllblog/start-jekyllblogging/
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

Starts a Jekyll blog server with administrative privileges if required.

#### Detailed Description

This function checks if the current user has administrative privileges. If so, it starts the Jekyll blog server. If not, it prompts the user to restart the script with administrative privileges.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Start-JekyllBlogging
```

Starts the Jekyll blog server if the user has administrative privileges. Otherwise, prompts the user to restart the script with administrative privileges.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Starts a Jekyll blog server with administrative privileges if required.

.DESCRIPTION
    This function checks if the current user has administrative privileges. If so, it starts the Jekyll blog server. 
    If not, it prompts the user to restart the script with administrative privileges.

.PARAMETER None
    This function does not take any parameters.

.EXAMPLE
    PS C:\> Start-JekyllBlogging
    Starts the Jekyll blog server if the user has administrative privileges. Otherwise, prompts the user to restart the script with administrative privileges.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Start-JekyllBlogging {
	[CmdletBinding()]
	param ()

	# Function to check if the current user is an administrator
	function Test-IsAdmin {
		try {
			$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
			return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
		}
		catch {
			Write-Verbose "Error checking admin rights: $_"
			return $False
		}
	}

	# Verbose output indicating the start of the function
	Write-Verbose "Starting Jekyll Blogging function..."

	if (Test-IsAdmin) {
		Write-Verbose "User is an administrator. Starting Jekyll blog server..."
		New-JekyllBlogServer
	}
 else {
		Write-Warning "User is not an administrator. Prompting for administrative privileges..."
		Write-Verbose "Starting PowerShell with administrative privileges..."
		Start-Process -FilePath "pwsh.exe" -ArgumentList '-NoExit', '-Command', "& { $MyInvocation.Line }" -Verb runas -PassThru
	}

	# Verbose output indicating the end of the function
	Write-Verbose "Jekyll Blogging function completed."
}

# Define the New-JekyllBlogServer function for demonstration purposes
function New-JekyllBlogServer {
	Write-Host "Starting Jekyll blog server..."
	# Add your Jekyll blog server start commands here
}

# Example call to the function
# Start-JekyllBlogging -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/JekyllBlog/Public/Start-JekyllBlogging.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-JekyllBlogging.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

