---
layout: post
title: Connect-CmRcViewer.ps1
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

**_@GitHub Copilot_** - The code is a PowerShell function called `Connect-CmRcViewer`. This function is used to spawn the ConfigMgr Remote Control Viewer and launch a session to a remote computer. The function accepts a single parameter called `ComputerName`, which is used to specify the name of the computer you would like to connect to. This parameter supports IP/Name/FQDN.

The function has a `CmdletBinding` attribute that specifies the default parameter set name, positional binding, and support for the `ShouldProcess` common parameter. The function also has an `OutputType` attribute that specifies the output type as a string, and a `Alias` attribute that provides an alias for the function called `crdp`.

The function has a `Begin` block that is empty, a `Process` block that contains the main logic of the function, and an `End` block that is also empty. The `Process` block uses a `ForEach` loop to iterate over each computer name passed to the function. If the `ShouldProcess` common parameter is used and the user confirms the action, the function attempts to start the ConfigMgr Remote Control Viewer by checking if the executable file exists in either of two possible locations. If the executable file is found, the function starts the process with the specified computer name as an argument. If the executable file is not found, the function outputs an error message indicating that the computer is not reachable.

The function also has a comment-based help section that provides information about the function's parameters, inputs, outputs, and links to additional resources. The help section includes examples of how to use the function to connect to a specific computer and to all SCCM computers in Active Directory.

To improve the code's readability, the comments could be reorganized to follow a more standard format, and the parameter descriptions could be more detailed. To improve the code's performance, the function could be modified to use a more efficient method for checking if the executable file exists, such as using the `Test-Path` cmdlet with a wildcard pattern. Additionally, the function could be modified to support additional parameters, such as specifying the username and password to use for the remote connection.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you can use the `Connect-CmRcViewer` function:

1. To start a ConfigMgr Remote Control Viewer session to a specific computer, you can use the `-ComputerName` parameter to specify the computer name. For example:

```
Connect-CmRcViewer -ComputerName COMPUTERNAME
```

Replace `COMPUTERNAME` with the name of the computer you want to connect to.

2. To start a ConfigMgr Remote Control Viewer session to all SCCM computers in Active Directory, you can use the `Get-ADComputer` cmdlet to filter for computers with "SCCM" in their name, and then pipe the results to `ForEach-Object` to pass each computer's DNSHostName to the `-ComputerName` parameter. For example:

```
Get-ADComputer -Filter { Name -like '*SCCM*' } | ForEach-Object -Process { Connect-CmRcViewer -ComputerName $_.DNSHostName }
```

This will start a ConfigMgr Remote Control Viewer session to each SCCM computer in Active Directory that has "SCCM" in its name.

Note that you will need to have the appropriate permissions to connect to the remote computers.

---

#### Script

```powershell
Function Connect-CmRcViewer {
	<#
	.SYNOPSIS
		Connect-CmRcViewer

	.DESCRIPTION
		Connect-CmRcViewer - Spawn ConfigMgr Remote Control Viewer and launches a session to a remote computer.

	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN

	.EXAMPLE
		Connect-CmRcViewer -ComputerName COMPUTERNAME
		Starts an ConfigMgr Remote Control Viewer session to COMPUTERNAME

	.EXAMPLE
		Get-ADComputer -Filter { Name -like '*SCCM*' } | ForEach-Object -Process { Connect-CmRcViewer -ComputerName $_.DNSHostName }
		Starts an ConfigMgr Remote Control Viewer session to all SCCM computers in Active Directory

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
			If ($PSCmdlet.ShouldProcess("$($Computer)", "Establish a ConfigMgr Remote Control Viewer connection")) {
				try {
					$exePath = Get-ChildItem -Path "C:\Program Files (x86)\Microsoft Endpoint Manager\AdminConsole\bin\i386\CmRcViewer.exe", "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
					if ($null -ne $exePath) {
						Start-Process $exePath -ArgumentList "$Computer"
					}
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Connect-CmRcViewer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-CmRcViewer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
