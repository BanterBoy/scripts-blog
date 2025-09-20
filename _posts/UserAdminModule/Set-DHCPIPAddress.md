---
layout: post
title: Set-DHCPIPAddress.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Set-DHCPIPAddress/
categories:
- UserAdminModule
- Network
tags:
- PowerShell
- User Admin Module
- DHCPIP Address
- DHCP
- DHCPIP
description: Configure a network adapter to use DHCP settings.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Configure a network adapter to use DHCP settings.

#### Detailed Description

This function configures a network adapter to use DHCP settings based on the current IP address of the network card.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-DHCPIPAddress -CurrentIPAddress '192.168.1.20'
```

Clears DNS client cache, registers DNS client, releases and renews IP configuration.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 30/06/2024

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-DHCPIPAddress {
	<#
    .SYNOPSIS
        Configure a network adapter to use DHCP settings.
    
    .DESCRIPTION
        This function configures a network adapter to use DHCP settings based on the current IP address of the network card.
    
    .PARAMETER CurrentIPAddress
        Enter the current IP address of the network card that you would like to configure to receive a DHCP IP address assignment.
    
    .EXAMPLE
        Set-DHCPIPAddress -CurrentIPAddress '192.168.1.20'
        Clears DNS client cache, registers DNS client, releases and renews IP configuration.
    
    .OUTPUTS
        None. Configures the network adapter.
    
    .NOTES
        Author: Your Name
        Date: 30/06/2024
    
    .LINK
        https://github.com/BanterBoy
    #>
    
	[CmdletBinding(DefaultParameterSetName = 'Default',
		SupportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy')]
	param (
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter Current IPAddress or pipe input')]
		[string]$CurrentIPAddress
	)
    
	begin {
		Write-Verbose "Starting Set-DHCPIPAddress function"
	}
	process {
		if ($PSCmdlet.ShouldProcess("$CurrentIPAddress", "Setting Network card to DHCP")) {
			try {
				foreach ($IPAddress in $CurrentIPAddress) {
					Write-Verbose "Processing IP Address: $IPAddress"
                    
					$NetworkCard = Get-NetIPAddress -IPAddress $IPAddress
					if (-not $NetworkCard) {
						Write-Warning "No network card found for IP Address: $IPAddress"
						continue
					}

					$Interface = Get-NetIPInterface -InterfaceIndex $NetworkCard.InterfaceIndex
					Write-Verbose "Found network card: $($NetworkCard.InterfaceAlias)"

					$Interface | Set-NetIPInterface -Dhcp Enabled -ErrorAction SilentlyContinue
					Write-Verbose "DHCP enabled for interface: $($Interface.InterfaceAlias)"

					$Interface | Set-DnsClientServerAddress -ResetServerAddresses -ErrorAction SilentlyContinue
					Write-Verbose "DNS server addresses reset for interface: $($Interface.InterfaceAlias)"

					$Interface | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
					Write-Verbose "Routes removed for interface: $($Interface.InterfaceAlias)"
                    
					Clear-DnsClientCache
					Write-Verbose "DNS client cache cleared"

					Register-DnsClient
					Write-Verbose "DNS client registered"

					ipconfig /release
					Write-Verbose "IP configuration released"

					ipconfig /renew
					Write-Verbose "IP configuration renewed"
				}
			}
			catch {
				Write-Error "An error occurred while configuring DHCP for IP Address ${IPAddress}: $_"
			}
		}
	}
	end {
		Write-Verbose "Completed Set-DHCPIPAddress function"
	}
}

# Example usage with verbose output:
# Set-DHCPIPAddress -CurrentIPAddress '192.168.1.20' -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Set-DHCPIPAddress.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-DHCPIPAddress.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

