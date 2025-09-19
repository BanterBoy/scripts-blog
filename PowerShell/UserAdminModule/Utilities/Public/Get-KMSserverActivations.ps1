function Get-KMSserverActivations {
	<#
	.SYNOPSIS
		A brief description of the Get-KMSserverActivations function.
	
	.DESCRIPTION
		A detailed description of the Get-KMSserverActivations function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER Last
		A description of the Last parameter.
	
	.EXAMPLE
		PS C:\> Get-KMSserverActivations -ComputerName 'value1'
	
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
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cn')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cred')]
		[ValidateNotNull()]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input')]
		[int]$First,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input')]
		[int]$Last
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($First) {
				if ($PSCmdlet.ShouldProcess("$($Computer)", "Extracting Activation Events")) {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -First $First
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
		
					}
					else {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -First $First
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
				}
			}
			elseif ($Last) {
				if ($PSCmdlet.ShouldProcess("$($Computer)", "Extracting Activation Events")) {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -Last $Last
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
		
					}
					else {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -Last $Last
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
				}
			}
			else {
				if ($PSCmdlet.ShouldProcess("$($Computer)", "Extracting Activation Events")) {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
		
					}
					else {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Key Management Service"; ID = 12290 } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
				}
			}
		}
	}
	END {
	}
}

# "HOTH", "KAMINO", "DANTOOINE" | ForEach-Object -Process { Get-KMSserverActivations -ComputerName $_ -First 1 }
