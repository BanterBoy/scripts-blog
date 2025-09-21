---
layout: post
title: PadOrTruncate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/padortruncate/
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

Pad or truncate a string to a specified length.

#### Detailed Description

This function takes a string and a length as input parameters.

- If the length of the string is less than or equal to the specified length, it pads the string with spaces (or a specified character) on the right side to make it equal to the specified length.

- If the length of the string is greater than the specified length, it truncates the string and appends "..." (or a specified truncation indicator) at the end.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PadOrTruncate -s "Hello, world!" -length 15
```

# Output: "Hello, world!  "

**Example 2**

```powershell
PadOrTruncate -s "Hello, world!" -length 10
```

# Output: "Hello, wo..."

**Example 3**

```powershell
PadOrTruncate -s "Hello, world!" -length 20 -PaddingChar "-"
```

# Output: "Hello, world!-------"

**Example 4**

```powershell
PadOrTruncate -s "Hello, world!" -length 10 -TruncationIndicator ">>>"
```

# Output: "Hello, w>>>"

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
    Pad or truncate a string to a specified length.

.DESCRIPTION
    This function takes a string and a length as input parameters. 
    - If the length of the string is less than or equal to the specified length, it pads the string with spaces (or a specified character) on the right side to make it equal to the specified length. 
    - If the length of the string is greater than the specified length, it truncates the string and appends "..." (or a specified truncation indicator) at the end.

.PARAMETER s
    The input string to be padded or truncated.

.PARAMETER length
    The desired length of the string.

.PARAMETER PaddingChar
    The character to use for padding the string. Defaults to a space.

.PARAMETER TruncationIndicator
    The string to use to indicate truncation. Defaults to "...".

.OUTPUTS
    System.String

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 15
    # Output: "Hello, world!  "

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 10
    # Output: "Hello, wo..."

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 20 -PaddingChar "-"
    # Output: "Hello, world!-------"

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 10 -TruncationIndicator ">>>"
    # Output: "Hello, w>>>"

#>

function PadOrTruncate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$s,

		[Parameter(Mandatory = $true)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$length,

		[Parameter(Mandatory = $false)]
		[ValidateLength(1, 1)]
		[char]$PaddingChar = ' ',

		[Parameter(Mandatory = $false)]
		[string]$TruncationIndicator = '...'
	)

	begin {
		# Calculate the max length of the string before truncation indicator
		$maxLengthBeforeTruncation = $length - $TruncationIndicator.Length
	}

	process {
		if ($s.Length -le $length) {
			# Pad the string if it is shorter than or equal to the specified length
			$result = $s.PadRight($length, $PaddingChar)
		}
		else {
			# Truncate the string and append the truncation indicator if it is longer than the specified length
			$truncated = $s.Substring(0, $maxLengthBeforeTruncation)
			$result = "$truncated$TruncationIndicator"
		}

		# Output the result
		return $result
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/PadOrTruncate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=PadOrTruncate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

