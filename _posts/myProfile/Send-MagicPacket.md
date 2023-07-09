---
layout: post
title: Send-MagicPacket.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
function Send-MagicPacket {
	<#
	.SYNOPSIS
		Send a Magic Packet to a specific computer to wake up the computer.

	.DESCRIPTION
		A detailed description of the Send-MagicPacket function.

	.PARAMETER Mac
		 This field will accept a string value for the MAC Address - e.g. "98-90-96-DE-4C-6E" or "98:90:96:DE:4C:6E"

	.EXAMPLE
				PS C:\> Send-MagicPacket -Mac 'Value1'

	.OUTPUTS
		string

	.NOTES
		Additional information about the function.

	.LINK
		http://www.microsoft.com/
#>
	[CmdletBinding(DefaultParameterSetName = 'Default',
		ConfirmImpact = 'Low',
		HelpUri = 'http://www.microsoft.com/',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[Alias('smp')]
	[OutputType([String])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 0,
			HelpMessage = "This field will accept a string value for the MAC Address - e.g. '98 - 90 - 96 -DE - 4C-6E' or '98:90:96:DE:4C:6E' ")]
		[String]$Mac
	)
	BEGIN {
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$($MAC)", "Sending Magic Packet")) {
			try {
				$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_" }
				[Byte[]]$MagicPacket = ( , 0xFF * 6) + ($MacByteArray * 16)
				$UdpClient = New-Object System.Net.Sockets.UdpClient
				$UdpClient.Connect(([System.Net.IPAddress]::Broadcast), 7)
				$UdpClient.Send($MagicPacket, $MagicPacket.Length)
				$UdpClient.Close()
			}
			catch {
				Write-Error "Error sending magic packet"
			}
		}
	}
	END {
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Send-MagicPacket.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Send-MagicPacket.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
