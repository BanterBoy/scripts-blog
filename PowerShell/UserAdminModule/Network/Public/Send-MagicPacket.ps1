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
