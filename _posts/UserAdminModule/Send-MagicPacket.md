---
layout: post
title: Send-MagicPacket.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Send-MagicPacket/
categories:
  - UserAdminModule
  - Network
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

Send a Magic Packet to a specific computer to wake it up.

#### Detailed Description

This function sends a Magic Packet to a specified MAC address to wake up a computer on the network. The MAC address should be in the format "98-90-96-DE-4C-6E" or "98:90:96:DE:4C:6E".

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Send-MagicPacket -Mac '98-90-96-DE-4C-6E'
```

This example sends a Magic Packet to the computer with the specified MAC address.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Send-MagicPacket {
	<#
    .SYNOPSIS
        Send a Magic Packet to a specific computer to wake it up.
    
    .DESCRIPTION
        This function sends a Magic Packet to a specified MAC address to wake up a computer on the network.
        The MAC address should be in the format "98-90-96-DE-4C-6E" or "98:90:96:DE:4C:6E".
    
    .PARAMETER Mac
        Specifies the MAC address of the computer to wake up. The MAC address should be in the format "98-90-96-DE-4C-6E" or "98:90:96:DE:4C:6E".
    
    .EXAMPLE
        PS C:\> Send-MagicPacket -Mac '98-90-96-DE-4C-6E'
    
        This example sends a Magic Packet to the computer with the specified MAC address.
    
    .OUTPUTS
        None
    
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
	param (
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = "This field will accept a string value for the MAC Address - e.g. '98-90-96-DE-4C-6E' or '98:90:96:DE:4C:6E' ")]
		[String]$Mac
	)
	BEGIN {
		Write-Verbose "Starting Send-MagicPacket function."
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$($Mac)", "Sending Magic Packet")) {
			try {
				Write-Verbose "Converting MAC address to byte array."
				$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte]::Parse($_, [System.Globalization.NumberStyles]::HexNumber) }
                
				Write-Verbose "Creating Magic Packet."
				[Byte[]]$MagicPacket = ( , 0xFF * 6) + ($MacByteArray * 16)
                
				Write-Verbose "Initializing UDP client."
				$UdpClient = New-Object System.Net.Sockets.UdpClient
                
				Write-Verbose "Connecting to broadcast address on port 7."
				$UdpClient.Connect([System.Net.IPAddress]::Broadcast, 7)
                
				Write-Verbose "Sending Magic Packet."
				$UdpClient.Send($MagicPacket, $MagicPacket.Length)
                
				Write-Verbose "Closing UDP client."
				$UdpClient.Close()
                
				Write-Output "Magic Packet sent to $Mac."
			}
			catch {
				Write-Error "Error sending magic packet: $_"
			}
		}
	}
	END {
		Write-Verbose "Send-MagicPacket function completed."
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Send-MagicPacket.ps1')">
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

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

