---
layout: post
title: Test-NetworkPort.ps1
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

<#PSScriptInfo

.VERSION 1.0

.GUID ee346973-6b67-4099-9191-cbcc169cf360

.AUTHOR Adam Bertram

.COMPANYNAME Adam the Automator, LLC

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

<#

.DESCRIPTION
 A script to test if a TCP or UDP port is open.

#>
[CmdletBinding(DefaultParameterSetName = 'TCP')]
[OutputType([System.Management.Automation.PSCustomObject])]
param (
	[Parameter(Mandatory)]
	[string]$ComputerName,

	[Parameter(Mandatory)]
	[int]$Port,

	[Parameter()]
	[ValidateSet('TCP', 'UDP')]
	[string]$Protocol = 'TCP',

	[Parameter(ParameterSetName = 'TCP')]
	[int]$TcpTimeout = 1000,

	[Parameter(ParameterSetName = 'UDP')]
	[int]$UdpTimeout = 1000
)
process {
	if ($Protocol -eq 'TCP') {
		$TcpClient = New-Object System.Net.Sockets.TcpClient
		$Connect = $TcpClient.BeginConnect($ComputerName, $Port, $null, $null)
		$Wait = $Connect.AsyncWaitHandle.WaitOne($TcpTimeout, $false)
		if (!$Wait) {
			$TcpClient.Close()
		}
		else {
			$TcpClient.EndConnect($Connect)
			$TcpClient.Close()
			$result = $true
		}
		$TcpClient.Close()
		$TcpClient.Dispose()
	}
	elseif ($Protocol -eq 'UDP') {
		$UdpClient = New-Object System.Net.Sockets.UdpClient
		$UdpClient.Client.ReceiveTimeout = $UdpTimeout
		$UdpClient.Connect($ComputerName, $Port)
		$a = new-object system.text.asciiencoding
		$byte = $a.GetBytes("$(Get-Date)")
		[void]$UdpClient.Send($byte, $byte.length)
		#IPEndPoint object will allow us to read datagrams sent from any source.
		Write-Verbose "$($MyInvocation.MyCommand.Name) - Creating remote endpoint"
		$remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any, 0)
		try {
			#Blocks until a message returns on this socket from a remote host.
			Write-Verbose "$($MyInvocation.MyCommand.Name) - Waiting for message return"
			$receivebytes = $UdpClient.Receive([ref]$remoteendpoint)
			[string]$returndata = $a.GetString($receivebytes)
			If ($returndata) {
				$result = $true
			}
		}
		catch {
			Write-Error "$($MyInvocation.MyCommand.Name) - '$ComputerName' failed port test on port '$Protocol`:$Port' with error '$($_.Exception.Message)'"
		}
		$UdpClient.Close()
		$UdpClient.Dispose()
	}
	if ($result) {
		$true
	}
	else {
		$false
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-NetworkPort.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-NetworkPort.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
