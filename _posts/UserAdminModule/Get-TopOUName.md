---
layout: post
title: Get-TopOUName.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-topouname/
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

A brief description of the Get-TopOUName function.

#### Detailed Description

A detailed description of the Get-TopOUName function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-TopOUName -DistinguishedName 'value1'
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-TopOUName {
	<#
		.SYNOPSIS
			A brief description of the Get-TopOUName function.
		
		.DESCRIPTION
			A detailed description of the Get-TopOUName function.
		
		.PARAMETER DistinguishedName
			A description of the DistinguishedName parameter.
		
		.EXAMPLE
			PS C:\> Get-TopOUName -DistinguishedName 'value1'
		
		.OUTPUTS
			string
		
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 0,
			HelpMessage = 'A description of the DistinguishedName parameter.')]
		[string]
		$DistinguishedName
	)
	
	Begin {
		Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
		#ignore case
		$rx = [System.Text.RegularExpressions.Regex]::new("^(((CN=.*?))?)OU=(?<OUName>.*?(?=,))", "IgnoreCase")
	} #begin
	
	Process {
		if ($PSCmdlet.ShouldProcess("$($Month)" + "-" + "$($DistinguishedName)", "Processing")) {
			Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $DistinguishedName"
			If ($rx.IsMatch($DistinguishedName)) {
				$rx.Match($DistinguishedName).groups["OUName"].Value
			}
		} #process
	}
	End {
		Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
	} #end
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-TopOUName.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TopOUName.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

