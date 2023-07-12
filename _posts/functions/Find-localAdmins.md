---
layout: post
title: Find-localAdmins.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
function Find-localAdmins {

	<#
	.SYNOPSIS
		List users in specified local group
	.DESCRIPTION
		Created: March 17, 2011 Jeff Patton
		This script searches ActiveDirectory for computers. It then queries each computer for the list of users who
		are in the local Administrators group.
	.PARAMETER ADSPath
		The LDAP URI of the container you wish to pull computers from.
	.PARAMETER GroupName
		The name of the local group to pull membership pfrom.
	.EXAMPLE
		find-localadmins "LDAP://OU=Workstations,DC=company,DC=com"
	.NOTES
		You will need to run this script as an administrator or disable UAC to update the event-log
		You will need to have at least Read permissions in the AD container in order to get a list of computers.
	.LINK
		http://scripts.patton-tech.com/wiki/PowerShell/Production/FindLocalAdmins
	#>

	Param
	(
		[Parameter(Mandatory = $true)]
		[string]$ADSPath,
		[Parameter(Mandatory = $true)]
		[string]$GroupName
	)
	Begin {
		$ScriptName = $MyInvocation.MyCommand.ToString()
		$LogName = "Application"
		$ScriptPath = $MyInvocation.MyCommand.Path
		$Username = $env:USERDOMAIN + "\" + $env:USERNAME

		New-EventLog -Source $ScriptName -LogName $LogName -ErrorAction SilentlyContinue

		$Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
		Write-EventLog -LogName $LogName -Source $ScriptName -EventID "100" -EntryType "Information" -Message $Message

		#	Dotsource in the AD functions
		. .\includes\ActiveDirectoryManagement.ps1
	}
	Process {
		$computers = Get-ADObjects $ADSPath

		foreach ($computer in $computers) {
			if ($null -eq $computer) {}
			else {
				$groups = Get-LocalGroupMembers $computer.Properties.name $GroupName
				If ($null -ne $groups) {
					write-host "Accounts with membership in $GroupName on: " $computer.Properties.name
					$groups | Format-Table -autosize
				}
			}
		}
	}
	End {
		$Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
		Write-EventLog -LogName $LogName -Source $ScriptName -EventID "100" -EntryType "Information" -Message $Message
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Find-localAdmins.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Find-localAdmins.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
