---
layout: post
title: Connect-RDPSession.ps1
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

**_@GitHub Copilot_** - This is a PowerShell script that defines a cmdlet called `Connect-RDPSession`. The cmdlet establishes a Remote Desktop Protocol (RDP) connection to a remote computer. The cmdlet takes a computer name as input and opens an RDP session to that computer. The cmdlet is defined with a `CmdletBinding` attribute that specifies the default parameter set name, positional binding, and support for ShouldProcess. The cmdlet also has an alias `crdp`.

The `Param` block defines the parameters for the cmdlet. The `ComputerName` parameter is defined as an array of strings and is optional. It supports pipeline input and accepts input from the pipeline by property name. The `HelpMessage` parameter specifies the help message that is displayed when the parameter is not specified.

The `Begin`, `Process`, and `End` blocks are used to define the cmdlet's functionality. The `Begin` block is executed before the pipeline input is processed. The `Process` block is executed for each input object in the pipeline. The `End` block is executed after all input objects have been processed.

The `Process` block uses a `ForEach` loop to iterate through each computer name in the `ComputerName` parameter. The `ShouldProcess` method is used to confirm that the cmdlet should establish an RDP connection to the specified computer. If the confirmation is successful, the `Start-Process` cmdlet is used to open an RDP session to the specified computer. If the connection is unsuccessful, the `catch` block is executed and an error message is displayed.

To improve the code's readability, the comments should be moved to the top of the script and the code should be indented properly. Additionally, the `try-catch` block could be improved by specifying the type of exception to catch. Finally, the `Write-Output` cmdlet in the `catch` block is unnecessary since the error message is already displayed.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are some examples of how to use the `Connect-RDPSession` cmdlet:

Example 1: Connect to a single computer

```
Connect-RDPSession -ComputerName "COMPUTER01"
```

This command establishes an RDP connection to the computer named "COMPUTER01".

Example 2: Connect to multiple computers

```
"COMPUTER01", "COMPUTER02", "COMPUTER03" | Connect-RDPSession
```

This command establishes an RDP connection to the computers named "COMPUTER01", "COMPUTER02", and "COMPUTER03" by piping the computer names to the `Connect-RDPSession` cmdlet.

Example 3: Connect to a computer using pipeline input

```
Get-Content -Path "C:\Computers.txt" | Connect-RDPSession
```

This command establishes an RDP connection to the computers listed in the "C:\Computers.txt" file by using the `Get-Content` cmdlet to read the file and piping the computer names to the `Connect-RDPSession` cmdlet.

I hope these examples help you understand how to use the `Connect-RDPSession` cmdlet!

---

#### Script

```powershell
Function Connect-RDPSession {
	<#
	.SYNOPSIS
		Connect-RDPSession

	.DESCRIPTION
		Connect-RDPSession - Spawn MSTSC and launches an RDP session to a remote computer.

	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN

	.EXAMPLE
		Connect-RDPSession -ComputerName COMPUTERNAME
		Starts an RDP session to COMPUTERNAME

	.OUTPUTS
		System.String. Connect-RDPSession

	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		ComputerName - You can pipe objects to this perameters.

	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Start-Process
		Write-Output
#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[Alias('crdp')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter a computer name or pipe input'
		)]
		[Alias('cn')]
		[string[]]$ComputerName
	)

	Begin {

	}

	Process {
		ForEach ($Computer In $ComputerName) {
			If ($PSCmdlet.ShouldProcess("$($Computer)", "Establish an RDP connection")) {
				try {
					Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$Computer"
				}
				catch {
					Write-Output "$($Computer): is not reachable."
				}
			}
		}
	}

	End {

	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Connect-RDPSession.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-RDPSession.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
