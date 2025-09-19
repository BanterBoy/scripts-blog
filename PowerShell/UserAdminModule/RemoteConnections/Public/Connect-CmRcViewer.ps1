Function Connect-CmRcViewer {
	<#
	.SYNOPSIS
		Connect-CmRcViewer
	
	.DESCRIPTION
		Connect-CmRcViewer - Spawn ConfigMgr Remote Control Viewer and launches a session to a remote computer.
	
	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN
	
	.EXAMPLE
		Connect-CmRcViewer -ComputerName COMPUTERNAME
		Starts an ConfigMgr Remote Control Viewer session to COMPUTERNAME

	.EXAMPLE	
		Get-ADComputer -Filter { Name -like '*SCCM*' } | ForEach-Object -Process { Connect-CmRcViewer -ComputerName $_.DNSHostName }
		Starts an ConfigMgr Remote Control Viewer session to all SCCM computers in Active Directory

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
			If ($PSCmdlet.ShouldProcess("$($Computer)", "Establish a ConfigMgr Remote Control Viewer connection")) {
				try {
					Start-Process "C:\Program Files (x86)\Microsoft Endpoint Manager\AdminConsole\bin\i386\CmRcViewer.exe" -ArgumentList "$Computer"
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
