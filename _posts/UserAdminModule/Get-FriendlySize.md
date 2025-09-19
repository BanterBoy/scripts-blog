---
layout: post
title: Get-FriendlySize.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-FriendlySize/
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

Converts a given number of bytes to a human-readable format.

#### Detailed Description

The Get-FriendlySize function takes a number of bytes and converts it to a human-readable format, such as KB, MB, GB, etc. It returns an object with the following properties:

- DecimalSize: The size in bytes, rounded to two decimal places.

- FriendlySize: The size in a human-readable format, with the number rounded to the specified number of decimal places (default is 2).

- SizeType: The unit of measurement used for the FriendlySize property.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-FriendlySize -Bytes 1234567890 -DecimalPlaces 1
```

FriendlySize : 1.1 GB SizeType     : GB Converts 1234567890 bytes to a human-readable format with 1 decimal place.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Converts a given number of bytes to a human-readable format.

.DESCRIPTION
The Get-FriendlySize function takes a number of bytes and converts it to a human-readable format, such as KB, MB, GB, etc. It returns an object with the following properties:
- DecimalSize: The size in bytes, rounded to two decimal places.
- FriendlySize: The size in a human-readable format, with the number rounded to the specified number of decimal places (default is 2).
- SizeType: The unit of measurement used for the FriendlySize property.

.PARAMETER Bytes
The number of bytes to convert. This parameter is mandatory.

.PARAMETER DecimalPlaces
The number of decimal places to round the FriendlySize property to. This parameter is optional and defaults to 2.

.EXAMPLE
PS C:\> Get-FriendlySize -Bytes 1234567890 -DecimalPlaces 1

FriendlySize : 1.1 GB
SizeType     : GB

Converts 1234567890 bytes to a human-readable format with 1 decimal place.
#>
function Get-FriendlySize {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[int64]$Bytes,
		[Parameter(Mandatory = $false)]
		[int]$DecimalPlaces = 2
	)

	$sizes = "Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB"

	$i = 0
	while ($Bytes -ge 1kb -and $i -lt $sizes.Count) {
		$Bytes /= 1kb
		$i++
	}

	$sizeType = $sizes[$i]
	$friendlySize = "{0:N$($DecimalPlaces)} $sizeType" -f $Bytes

	[PSCustomObject]@{
		FriendlySize = $friendlySize
		SizeType     = $sizeType
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-FriendlySize.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FriendlySize.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

