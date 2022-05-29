function Set-DHCPIPAddress {
	<#
	.SYNOPSIS
		Configure a network adapter to use DHCP settings.
	
	.DESCRIPTION
		Configure a network adapter to use DHCP settings using the current IP address of the Network Card that you would like to configure to receive a DHCP IP Address assignment.
	
	.PARAMETER CurrentIPAddress
		Enter the current IP address of the Network Card that you would like to configure to receive a DHCP IP Address assignment.
	
	.EXAMPLE
		Set-DHCPIPAddress -CurrentIPAddress $value1
	
	.EXAMPLE
		Set-DHCPIPAddress -CurrentIPAddress '192.168.1.20'
		Clear-DnsClientCache
		Register-DnsClient
		ipconfig /release
		ipconfig /renew

	.OUTPUTS
		string
	
	.NOTES
		Additional information about the function.
	
	.LINK
		https://github.com/BanterBoy
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		HelpUri = 'https://github.com/BanterBoy',
		SupportsPaging = $true,
		SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter Current IPAddress or pipe input')]
		[Alias('ci')]
		[string]$CurrentIPAddress
	)
	
	BEGIN {
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$($CurrentIPAddress)", "Setting Network card to DHCP")) {
			try {
				foreach ($IPAddress in $CurrentIPAddress) {
						$NetworkCard = Get-NetIPAddress -IPAddress $IPAddress
						$Interface = Get-NetIPInterface -InterfaceIndex $NetworkCard.InterfaceIndex
						$Interface | Set-NetIPInterface -Dhcp Enabled -ErrorAction SilentlyContinue
						$Interface | Set-DnsClientServerAddress -ResetServerAddresses -ErrorAction SilentlyContinue
						$Interface | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
						Clear-DnsClientCache
						Register-DnsClient
						ipconfig /release
						ipconfig /renew
				}
			}
			catch {
				Write-Error "Unable to find interface with IP Address $($IPAddress)"
			}
		}
	}
	END {
	}
}
