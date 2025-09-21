---
layout: post
title: Get-UserLogon.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-userlogon/
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

A brief description of the Get-UserLogon function.

#### Detailed Description

A detailed description of the Get-UserLogon function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-UserLogon
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-UserLogon {
	<#
		.SYNOPSIS
			A brief description of the Get-UserLogon function.
		
		.DESCRIPTION
			A detailed description of the Get-UserLogon function.
		
		.PARAMETER Computer
			Enter the Name of the Computer that you would like to gather results for. This parameter wraps the Invoke-Command CmdLet and QUser command line to scan the computer specified and collects the results.
		
		.PARAMETER OU
			The OU parameter requires you to enter the DistinguishedName of the OU that you would like to scan for computer logon accounts. This parameter wraps the Get-AdComputer and Invoke-Command CmdLets and parses the results in a foreach loop to scan each computer found within the OU specified using the QUser command line and collecting the results.
		
		.PARAMETER All
			The All parameter will scan All of the computers within the domain for logon accounts. This parameter wraps the Get-AdComputer and Invoke-Command CmdLets and parses the results in a foreach loop to scan each computer found within the domain using the QUser command line and collecting the results.
		
		.EXAMPLE
			PS C:\> Get-UserLogon
		
		.OUTPUTS
			string
		
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	[OutputType([string], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 1,
			HelpMessage = 'Enter the Name of the Computer that you would like to gather results for.')]
		[Parameter ()]
		[Alias('cn')]
		[String]
		$Computer = '.',
		[Parameter(ParameterSetName = 'Default',
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 2,
			HelpMessage = 'The OU parameter requires you to enter the DistinguishedName of the OU that you would like to scan for computer logon accounts.')]
		[Parameter ()]
		[String]
		$OU,
		[Parameter(ParameterSetName = 'Default',
			Position = 3,
			HelpMessage = 'The All parameter will scan All of the computers within the domain for logon accounts.')]
		[Parameter ()]
		[Switch]
		$All
	)
	
	$ErrorActionPreference = "SilentlyContinue"
	$result = @()
	
	if ($Computer) {
		Invoke-Command -ComputerName $Computer -ScriptBlock { quser } | Select-Object -Skip 1 | Foreach-Object {
			$b = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
			
			if ($b[2] -like 'Disc*') {
				$array = ([ordered]@{
						'User'     = $b[0]
						'Computer' = $Computer
						'Date'     = $b[4]
						'Time'     = $b[5 .. 6] -join ' '
					})
				$result += New-Object -TypeName PSCustomObject -Property $array
			}
			
			else {
				$array = ([ordered]@{
						'User'     = $b[0]
						'Computer' = $Computer
						'Date'     = $b[5]
						'Time'     = $b[6 .. 7] -join ' '
					})
				$result += New-Object -TypeName PSCustomObject -Property $array
			}
		}
	}
	
	if ($OU) {
		$comp = Get-ADComputer -Filter * -SearchBase "$OU" -Properties operatingsystem
		$count = $comp.count
		If ($count -gt 20) {
			Write-Warning "Search $count computers. This may take some time ... About 4 seconds for each computer"
		}
		foreach ($u in $comp) {
			Invoke-Command -ComputerName $u.Name -ScriptBlock { quser } | Select-Object -Skip 1 | ForEach-Object {
				$a = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
				If ($a[2] -like '*Disc*') {
					$array = ([ordered]@{
							'User'     = $a[0]
							'Computer' = $u.Name
							'Date'     = $a[4]
							'Time'     = $a[5 .. 6] -join ' '
						})
					$result += New-Object -TypeName PSCustomObject -Property $array
				}
				
				else {
					$array = ([ordered]@{
							'User'     = $a[0]
							'Computer' = $u.Name
							'Date'     = $a[5]
							'Time'     = $a[6 .. 7] -join ' '
						})
					$result += New-Object -TypeName PSCustomObject -Property $array
				}
			}
		}
	}
	
	if ($All) {
		$comp = Get-ADComputer -Filter * -Properties operatingsystem
		$count = $comp.count
		
		If ($count -gt 20) {
			Write-Warning "Search $count computers. This may take some time ... About 4 seconds for each computer ..."
		}
		foreach ($u in $comp) {
			Invoke-Command -ComputerName $u.Name -ScriptBlock { quser } | Select-Object -Skip 1 | ForEach-Object {
				$a = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
				If ($a[2] -like '*Disc*') {
					$array = ([ordered]@{
							'User'     = $a[0]
							'Computer' = $u.Name
							'Date'     = $a[4]
							'Time'     = $a[5 .. 6] -join ' '
						})
					$result += New-Object -TypeName PSCustomObject -Property $array
				}
				
				else {
					$array = ([ordered]@{
							'User'     = $a[0]
							'Computer' = $u.Name
							'Date'     = $a[5]
							'Time'     = $a[6 .. 7] -join ' '
						})
					$result += New-Object -TypeName PSCustomObject -Property $array
				}
			}
		}
	}
	Write-Output $result
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-UserLogon.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserLogon.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

