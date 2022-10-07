---
layout: post
title: templatePage.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Set-StaticIPAddress
{
<#
	.SYNOPSIS
		A brief description of the Set-StaticIPAddress function.

	.DESCRIPTION
		A detailed description of the Set-StaticIPAddress function.

	.PARAMETER CurrentIPAddress
		A description of the CurrentIPAddress parameter.

	.PARAMETER NewIPAddress
		A description of the NewIPAddress parameter.

	.PARAMETER subnetPrefix
		A description of the subnetPrefix parameter.

	.PARAMETER Gateway
		A description of the Gateway parameter.

	.PARAMETER DNSServers
		A description of the DNSServers parameter.

	.EXAMPLE
		Set-StaticIPAddress -CurrentIPAddress '172.26.155.85' -NewIPAddress '172.26.155.86' -subnetPrefix '20' -Gateway '172.26.144.1' -DNSServers '10.11.8.5','10.11.8.6'

	.EXAMPLE
		$NewNicDetails = @{
		    CurrentIPAddress = '192.168.1.15'
		    NewIPAddress     = '192.168.1.20'
		    subnetPrefix     = '24'
		    Gateway          = '192.168.1.1'
		    DNSServers       = '192.168.1.3'
		}
		Set-StaticIPAddress @NewNicDetails

	.EXAMPLE
		Set-StaticIPAddress -CurrentIPAddress '192.168.1.15' -NewIPAddress '192.168.1.20' -subnetPrefix '24' -Gateway '192.168.1.1' -DNSServers '192.168.1.3'

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
				   HelpMessage = 'Enter Current IPAddress or pipe input')]
		[Alias('ci')]
		[string]$CurrentIPAddress,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter New IPAddress or pipe input')]
		[Alias('na')]
		[string]$NewIPAddress,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter subnet prefix or pipe input')]
		[Alias('sp')]
		[int]$subnetPrefix,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter Gateway or pipe input')]
		[Alias('gw')]
		[string]$Gateway,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter DNS Server/s or pipe input')]
		[Alias('ds')]
		[string]$DNSServers
	)
	BEGIN
	{
	}
	PROCESS
	{
		foreach ($IPAddress in $CurrentIPAddress)
		{
			$NetworkCard = Get-NetIPAddress -IPAddress $IPAddress
			Get-NetIPInterface -InterfaceIndex $NetworkCard.InterfaceIndex | Set-NetIPInterface -Dhcp Disabled
			Start-Sleep -Seconds 1
			Remove-NetIPAddress -IPAddress $IPAddress -ErrorAction SilentlyContinue
			Remove-NetRoute -InterfaceIndex $NetworkCard.InterfaceIndex -NextHop $Gateway -ErrorAction SilentlyContinue
			New-NetIPAddress -InterfaceIndex $NetworkCard.InterfaceIndex -AddressFamily IPv4 -IPAddress $NewIPAddress -PrefixLength $subnetPrefix -ErrorAction SilentlyContinue
			New-NetRoute -InterfaceIndex $NetworkCard.InterfaceIndex -DestinationPrefix '0.0.0.0/0' -AddressFamily IPv4 -NextHop $Gateway -RouteMetric 0 -ErrorAction SilentlyContinue
			Set-DnsClientServerAddress -InterfaceIndex $NetworkCard.InterfaceIndex -ServerAddresses $DNSServers -ErrorAction SilentlyContinue
			Clear-DnsClientCache
			Register-DnsClient
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/templatePage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=templatePage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
