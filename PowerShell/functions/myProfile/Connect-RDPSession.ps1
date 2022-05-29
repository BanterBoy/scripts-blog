Function Connect-RDPSession {
	<#
	.SYNOPSIS
		Connect-RDPSession
	
	.DESCRIPTION
		Connect-RDPSession - Spawn MSTSC and launches an RDP session to a remote computer.
	
	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN
	
	.EXAMPLE
		Connect-RDPSession -ComputerName COMPUTERNAME
		Starts an RDP session to COMPUTERNAME
	
	.OUTPUTS
		System.String. Connect-RDPSession
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		ComputerName - You can pipe objects to this perameters.
	
	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Start-Process
		Write-Output
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[Alias('crdp')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter a computer name or pipe input'
		)]
		[Alias('cn')]
		[string[]]$ComputerName
	)
	
	Begin {
		
	}
	
	Process {
		ForEach ($Computer In $ComputerName) {
			If ($PSCmdlet.ShouldProcess("$($Computer)", "Establish an RDP connection")) {
				try {
					Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$Computer"
				}
				catch {
					Write-Output "$($Computer): is not reachable."
				}
			}
		}
	}
	
	End {
		
	}
}
