---
layout: post
title: Disable-PrintSpooler.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Disable-PrintSpooler`. This function disables the Print Spooler service on one or more remote computers. The function takes a single parameter called `ComputerName`, which is an array of strings representing the names of the remote computers on which the Print Spooler service should be disabled.

The function is defined using the `function` keyword, followed by the name of the function, and then a block of code enclosed in curly braces. The block of code contains a comment-based help section that provides a brief and detailed description of the function, as well as information about its parameters, examples, outputs, and notes.

The function is decorated with two attributes: `CmdletBinding` and `OutputType`. The `CmdletBinding` attribute specifies the default parameter set name and a help URI for the function. The `OutputType` attribute specifies the type of object that the function returns, which is a string.

The function has a single parameter called `ComputerName`, which is decorated with several parameter attributes. These attributes specify the parameter set name, whether the parameter is mandatory, whether the parameter can be piped, and a help message. The parameter is an array of strings, which allows the function to accept multiple computer names.

The function contains three blocks of code: `BEGIN`, `PROCESS`, and `END`. The `BEGIN` block is executed once at the beginning of the function, the `PROCESS` block is executed once for each input object, and the `END` block is executed once at the end of the function. In this case, the `BEGIN` and `END` blocks are empty, and the `PROCESS` block contains a loop that iterates over each computer name and disables the Print Spooler service on that computer using the `Invoke-Command` cmdlet.

To improve the readability of the code, the comments could be more descriptive and the parameter attributes could be aligned. To improve the performance of the code, the `Invoke-Command` cmdlet could be replaced with the `Stop-Service` and `Set-Service` cmdlets, which would eliminate the need for a remote PowerShell session.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are a few examples of how you can use the `Disable-PrintSpooler` function:

1. Disable the Print Spooler service on a single remote computer:

```powershell
Disable-PrintSpooler -ComputerName 'RemoteComputer01'
```

2. Disable the Print Spooler service on multiple remote computers:

```powershell
Disable-PrintSpooler -ComputerName 'RemoteComputer01', 'RemoteComputer02', 'RemoteComputer03'
```

3. Disable the Print Spooler service on remote computers specified in a text file:

```powershell
$ComputerList = Get-Content -Path 'C:\ComputerList.txt'
Disable-PrintSpooler -ComputerName $ComputerList
```

4. Disable the Print Spooler service on remote computers specified by pipeline input:

```powershell
'RemoteComputer01', 'RemoteComputer02', 'RemoteComputer03' | Disable-PrintSpooler
```

In each of these examples, the `Disable-PrintSpooler` function is called with the `-ComputerName` parameter, which specifies the name of the remote computer or computers on which the Print Spooler service should be disabled. The function disables the service using the `Stop-Service` and `Set-Service` cmdlets, and returns a string indicating that the service has been disabled.

---

#### Script

```powershell
function Disable-PrintSpooler
{
	<#
	.SYNOPSIS
		A brief description of the Disable-PrintSpooler function.

	.DESCRIPTION
		A detailed description of the Disable-PrintSpooler function.

	.PARAMETER ComputerName
		A description of the ComputerName parameter.

	.EXAMPLE
		PS C:\> Disable-PrintSpooler -ComputerName 'value1'

	.OUTPUTS
		System.String

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
				   HelpUri = 'https://github.com/BanterBoy')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter computer name or pipe input')]
		[Alias('cn')]
		[string[]]$ComputerName
	)
	BEGIN
	{
	}
	PROCESS
	{
		foreach ($Computer in $ComputerName)
		{
			Invoke-Command -ComputerName $Computer -ScriptBlock {
				Get-Service -Name Spooler | Stop-Service
				Set-Service -Name Spooler -StartupType Disabled
			}
		}
	}
	END
	{
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Disable-PrintSpooler.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-PrintSpooler.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
