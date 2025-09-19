---
layout: post
title: New-Email.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-Email/
categories:
  - UserAdminModule
  - Utilities
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

Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.

#### Detailed Description

Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.

Formats available via parameters:

- abc+yyyyMMdd@xyz.com					(no parameters)

- abc+yyyyMMdd_HHmmss@xyz.com			(IncludeTime parameter)

- abc+yyyyMMdd_SUFFIX@xyz.com			(Suffix parameter)

- abc+yyyyMMdd_HHmmss_SUFFIX@xyz.com	(IncludeTime and Suffix parameters)

- abc+SUFFIX@xyz.com					(NoDate and Suffix parameters)

- abc+@xyz.com							(NoDateparameter)

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Generates a new test email in the format abc+yyyyMMdd_test@xyz.com
```

New-Email -Suffix test

**Example 2**

```powershell
Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com
```

New-Email -Suffix test -IncludeTime

**Example 3**

```powershell
Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com (IncludeTime overrides NoDate)
```

New-Email -Suffix test -IncludeTime -NoDate

**Example 4**

```powershell
Generates a new test email in the format abc+test@xyz.com
```

New-Email -Suffix test -NoDate

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Rob Green

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
	.SYNOPSIS
        Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.
	
	.DESCRIPTION        
		Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.

		Formats available via parameters:

		- abc+yyyyMMdd@xyz.com					(no parameters)
		- abc+yyyyMMdd_HHmmss@xyz.com			(IncludeTime parameter)
		- abc+yyyyMMdd_SUFFIX@xyz.com			(Suffix parameter)
		- abc+yyyyMMdd_HHmmss_SUFFIX@xyz.com	(IncludeTime and Suffix parameters)
		- abc+SUFFIX@xyz.com					(NoDate and Suffix parameters)
		- abc+@xyz.com							(NoDateparameter)
	
	.PARAMETER Phrase
		Adds this string as a suffix to the email address, e.g. abc+yyyyMMdd_SUFFIX@xyz.com.
	
	.PARAMETER Email
		Email address to use.
	
	.PARAMETER NoClipboard
		If supplied the output will not be written to the clipboard.
	
	.PARAMETER NoDate
		If supplied the generated email will not contain the current date in yyyyMMdd format. Ignored if IncludeTime is supplied.
	
	.PARAMETER IncludeTime
		If supplied the generated email will add the time after the current date in yyyyMMdd_HHmmss format. Overrides NoDate parameter.
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_test@xyz.com
		New-Email -Suffix test
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com
		New-Email -Suffix test -IncludeTime
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com (IncludeTime overrides NoDate)
		New-Email -Suffix test -IncludeTime -NoDate
	
	.EXAMPLE
        Generates a new test email in the format abc+test@xyz.com
		New-Email -Suffix test -NoDate
	
	.OUTPUTS
		System.String. Awesome email.
	
	.NOTES
		Author: Rob Green
	
	.INPUTS
		You can pipe objects to these parameters.
		
		- Suffix [string]
#>
function New-Email {
	param (
		[Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0, HelpMessage = "Adds this string as a suffix to the email address, e.g. abc+yyyyMMdd_SUFFIX@xyz.com.")]
		[string]$Suffix,

		[Parameter(Mandatory = $false, Position = 1, HelpMessage = "Email address to use.")]
		# [ValidateSet (, "luke.leigh@gmail.com", "banterboy@gmail.com")]
		[string]$Email = "luke@leigh-services.com",
		
		[Parameter(Mandatory = $false, HelpMessage = "If supplied the output will not be written to the clipboard.")]
		[switch]$NoClipboard,

		[Parameter(Mandatory = $false, HelpMessage = "If supplied the generated email will not contain the current date in yyyyMMdd format. Ignored if IncludeTime is supplied.")]
		[switch]$NoDate,

		[Parameter(Mandatory = $false, HelpMessage = "If supplied the generated email will add the time after the current date in yyyyMMdd_HHmmss format. Overrides NoDate parameter.")]
		[switch]$IncludeTime
	)

	$parts = $Email.Split('@')

	# ascertain the date format to use
	$dateFormat = $IncludeTime.IsPresent ? "yyyyMMdd_HHmmss" : "yyyyMMdd"

	# generate the date string to be included in the output. IncludeTime overrides NoDate
	$date = $NoDate.IsPresent -and -not $IncludeTime.IsPresent ? "" : "$([System.DateTime]::Now.ToString($dateFormat))_"

	# ascertain whether a suffix should be added to the output
	$suffix = [String]::IsNullOrWhiteSpace($Suffix) ? "" : $Suffix

	# build the output email
	$email = "$($parts[0])+$($date)$($suffix)@$($parts[1])"

	if (-Not $NoClipboard.IsPresent) {
		$email | Set-Clipboard -PassThru

		Write-Host("Copied to clipboard")
	} 
	else {
		Write-Host $email
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/New-Email.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Email.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

