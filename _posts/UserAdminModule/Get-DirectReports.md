---
layout: post
title: Get-DirectReports.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-DirectReports/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- Direct Reports
description: A brief description of the Get-DirectReports function.
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

A brief description of the Get-DirectReports function.

#### Detailed Description

A detailed description of the Get-DirectReports function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-DirectReports -EmployeeID 'Value1'
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-DirectReports {

	<#
	.SYNOPSIS
		A brief description of the Get-DirectReports function.
	
	.DESCRIPTION
		A detailed description of the Get-DirectReports function.
	
	.PARAMETER Identity
		The SamAccountName of the Manager.
	
	.EXAMPLE
		PS C:\> Get-DirectReports -EmployeeID 'Value1'
	
	.OUTPUTS
		string
	
	.NOTES
		Additional information about the function.
	#>
	
	[OutputType([string], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter the SamAccountName for the Manager whose direct reports you would like to view.')]
		[ValidateNotNullOrEmpty()]
		[string]$Identity
	)
	
	Function Get-Reports {
		[cmdletbinding()]
		Param (
			[Parameter(Position = 0, ValueFromPipelineByPropertyName = $True)]
			[string]$DistinguishedName,
			[int]$Tab = 2
		)
		
		Process {
			$direct = Get-ADUser -Identity $DistinguishedName -Properties DirectReports
			
			if ($direct.DirectReports) {
				$direct.DirectReports | Get-ADUser -Properties Title | ForEach-Object {
					"{0} [{1}]" -f $_.Name.padleft($_.name.length + $tab), $_.title
					$_ | Get-Reports -Tab $($tab + 2)
				}
			}
			
		} #process
		
	} #end function
	
	$user = Get-ADUser $Identity -Properties DirectReports, Title
	$reports = $user.DirectReports
	
	"{0} [{1}]" -f $User.name, $User.Title
	
	foreach ($report in $reports) {
		$direct = $report | Get-ADUser -Properties DirectReports, Title, Department
		"{0} [{1}]" -f $direct.name.padleft($direct.name.length + 1, ">"), $direct.Title
		$direct | Get-Reports
	} #foreach
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-DirectReports.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DirectReports.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

