function Set-StaticIPAddress {
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
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy'
	)]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter Current IPAddress or pipe input')]
		[string]$CurrentIPAddress,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter New IPAddress or pipe input')]
		[string]$NewIPAddress,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter subnet prefix or pipe input')]
		[int]$subnetPrefix,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter Gateway or pipe input')]
		[string]$Gateway,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter DNS Server/s or pipe input')]
		[string]$DNSServers
	)
	BEGIN {
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$CurrentIPAddress", "Set Static IPAddress - $IPAddress")) {
			foreach ($IPAddress in $CurrentIPAddress) {
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
	}
	END {
	}
}
