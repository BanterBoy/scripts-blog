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
