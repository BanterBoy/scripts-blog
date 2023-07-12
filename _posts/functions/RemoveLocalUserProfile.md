---
layout: post
title: RemoveLocalUserProfile.ps1
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
#---------------------------------------------------------------------------------
#The sample scripts are not supported under any Microsoft standard support
#program or service. The sample scripts are provided AS IS without warranty
#of any kind. Microsoft further disclaims all implied warranties including,
#without limitation, any implied warranties of merchantability or of fitness for
#a particular purpose. The entire risk arising out of the use or performance of
#the sample scripts and documentation remains with you. In no event shall
#Microsoft, its authors, or anyone else involved in the creation, production, or
#delivery of the scripts be liable for any damages whatsoever (including,
#without limitation, damages for loss of business profits, business interruption,
#loss of business information, or other pecuniary loss) arising out of the use
#of or inability to use the sample scripts or documentation, even if Microsoft
#has been advised of the possibility of such damages
#---------------------------------------------------------------------------------

#requires -version 2.0

<#
 	.SYNOPSIS
        The PowerShell script which can be used to list user profile and delete user profile that were specified by user.
    .DESCRIPTION
        The PowerShell script which can be used to list user profile and delete user profile that were specified by user.
    .PARAMETER  ListUnusedDay
		Lists of unused more than a specified number of days in user profile.
	.PARAMETER  ListAll
		Lists all items in user profile.
    .PARAMETER  DeleteUnusedDay
		Delete the user profile that has not been used for more than the number of days as you specified.
    .PARAMETER  ExcludedUsers
		Sepcifies the user that you do not want to remove.
    .EXAMPLE
        C:\PS> C:\Script\RemoveLocalUserProfile.ps1 -ListUnusedDay 10

		ComputerName                            LocalPath                               LastUseTime
		------------                            ---------                               -----------
		WS-ANDTEST-01                           C:\Users\Administrator                  11/18/2013 1:37:26 PM
		WS-ANDTEST-01                           C:\Users\User001                        11/22/2013 10:50:35 AM
	.EXAMPLE
        C:\PS> C:\Script\RemoveLocalUserProfile.ps1 -ListAll

		ComputerName                            LocalPath                               LastUseTime
		------------                            ---------                               -----------
		WS-ANDTEST-01                           C:\Users\Administrator                  11/18/2013 1:37:26 PM
		WS-ANDTEST-01                           C:\Users\User001                        11/22/2013 10:50:35 AM
		WS-ANDTEST-01                           C:\Users\User002                        11/22/2012 10:50:35 AM
	.EXAMPLE
        C:\PS> C:\Script\RemoveLocalUserProfile.ps1 -DeleteUnusedDay 60

		ComputerName                  LocalPath                     LastUseTime                   Action
		------------                  ---------                     -----------                   ------
		WS-ANDTEST-01                 C:\Users\User001              11/22/2012 10:50:35 AM        Deleted
		WS-ANDTEST-01                 C:\Users\User002              11/22/2012 10:50:35 AM        Deleted
	.EXAMPLE
        C:\PS> C:\Script\RemoveLocalUserProfile.ps1 -DeleteUnusedDay 60 -ExcludedUsers "User001"

		ComputerName                  LocalPath                     LastUseTime                   Action
		------------                  ---------                     -----------                   ------
		WS-ANDTEST-01                 C:\Users\User002              11/22/2012 10:50:35 AM        Deleted
#>
Param
(
	[Parameter(Mandatory = $true,
		Position = 0,
		ParameterSetName = 'ListUnused',
		HelpMessage = "Lists of unused more than a specified number of days in user profile.")]
	[Alias("lunused")]
	[Int32]$ListUnusedDay,

	[Parameter(Mandatory = $true,
		Position = 0,
		ParameterSetName = 'ListAll',
		HelpMessage = "Lists of specified items in user profile.")]
	[Alias("all")]
	[Switch]$ListAll,

	[Parameter(Mandatory = $true,
		Position = 0,
		ParameterSetName = 'DeleteUnused',
		HelpMessage = "Delete the user profile that has not been used for more than the number of days as you specified.")]
	[Alias("dunused")]
	[Int32]$DeleteUnusedDay,

	[Parameter(Mandatory = $false,
		Position = 1,
		ParameterSetName = 'DeleteUnused',
		HelpMessage = "Specifies names of the user accounts that should not be removed.")]
	[Alias("excluded")]
	[String[]]$ExcludedUsers
)

Try {
	$UserProfileLists = Get-WmiObject -Class Win32_UserProfile |
	Select-Object @{Expression = { $_.__SERVER }; Label = "ComputerName" }, LocalPath, @{Expression = { $_.ConvertToDateTime($_.LastUseTime) }; Label = "LastUseTime" } |
	Where-Object { $_.LocalPath -notlike "*$env:SystemRoot*" }
}
Catch {
	Throw "Gathering profile WMI information from $computername failed. Be sure that WMI is functioning on this system."
}

If ($ListAll) {
	$UserProfileLists
}

If ($ListUnusedDay -gt 0) {
	$ProfileInfo = $UserProfileLists |
	Where-Object { $_.LastUseTime -le (Get-Date).AddDays(-$ListUnusedDay) }
	If ($null -eq $ProfileInfo) {
		Write-Warning -Message "The item not found."
	}
	Else {
		$ProfileInfo
	}
}

If ($DeleteUnusedDay -gt 0) {
	$ProfileInfo = Get-WmiObject -Class Win32_UserProfile |
	Where-Object { $_.ConvertToDateTime($_.LastUseTime) -le (Get-Date).AddDays(-$DeleteUnusedDay) -and $_.LocalPath -notlike "*$env:SystemRoot*" }

	If ($ExcludedUsers) {
		Foreach ($ExcludedUser in $ExcludedUsers) {
			#Perform the recursion by calling itself.
			$ProfileInfo = $ProfileInfo |
			Where-Object { $_.LocalPath -notlike "*$ExcludedUser*" }
		}
	}

	If ($null -eq $ProfileInfo) {
		Write-Warning -Message "The item not found."
	}
	Else {
		Foreach ($RemoveProfile in $ProfileInfo) {
			#Prompt message
			$Caption = "Remove Profile"
			$Message = "Are you sure you want to remove profile '$($RemoveProfile.LocalPath)'?"
			$Choices = [System.Management.Automation.Host.ChoiceDescription[]]`
			@("&Yes", "&No")

			[Int]$DefaultChoice = 1

			$ChoiceRTN = $Host.UI.PromptForChoice($Caption, $Message, $Choices, $DefaultChoice)

			Switch ($ChoiceRTN) {
				0	{
					Try { $RemoveProfile.Delete(); Write-Host "Delete profile '$($RemoveProfile.LocalPath)' successfully." }
					Catch { Write-Host "Delete profile failed." -ForegroundColor Red }
				}
				1 { break }
			}
		}
		$ProfileInfo | Select-Object @{Expression = { $_.__SERVER }; Label = "ComputerName" }, LocalPath, `
		@{Expression = { $_.ConvertToDateTime($_.LastUseTime) }; Label = "LastUseTime" }, `
		@{Name = "Action"; Expression = { If (Test-Path -Path $_.LocalPath)
				{ "Not Deleted" }
				Else
				{ "Deleted" }
			}
		}
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/RemoveLocalUserProfile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=RemoveLocalUserProfile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
