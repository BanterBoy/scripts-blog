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
