---
layout: post
title: Show-PSDrive.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Show-PSDrive/
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

Displays the details of all PowerShell drives.

#### Detailed Description

The Show-PSDrive function retrieves all the PowerShell drives, sorts them by a specified property, and then displays them in a table format.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Show-PSDrive -SortBy "Name"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Show-PSDrive {
	<#
    .SYNOPSIS
       Displays the details of all PowerShell drives.

    .DESCRIPTION
       The Show-PSDrive function retrieves all the PowerShell drives, sorts them by a specified property, and then displays them in a table format.

    .PARAMETER SortBy
       Specifies the property by which the PowerShell drives should be sorted.

    .EXAMPLE
       Show-PSDrive -SortBy "Name"
    #>
	param (
		[ValidateSet("Name", "Root", "Description", "MaximumSize", "Credential", "DisplayRoot", "Used", "Free", "CurrentLocation", "IsReady")]
		[string]$SortBy
	)

	try {
		$drives = Get-PSDrive

		if ($SortBy) {
			$drives = $drives | Sort-Object $SortBy
		}

		$drives = $drives | Select-Object Name, Root, Description, @{Name = 'Used'; Expression = { (Get-FriendlySize -Bytes $_.Used).FriendlySize } }, @{Name = 'Free'; Expression = { (Get-FriendlySize -Bytes $_.Free).FriendlySize } }, DisplayRoot

		$drives | Format-Table -AutoSize
	}
	catch {
		Write-Error "An error occurred: $_"
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Show-PSDrive.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Show-PSDrive.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

