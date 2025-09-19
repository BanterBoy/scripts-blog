function Get-KMSclientActivations {
	<#
	.SYNOPSIS
		A brief description of the Get-KMSclientActivations function.
	
	.DESCRIPTION
		A detailed description of the Get-KMSclientActivations function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER Last
		A description of the Last parameter.
	
	.EXAMPLE
		PS C:\> Get-KMSclientActivations -ComputerName 'value1'
	
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
		if ($PSCmdlet.ShouldProcess("$($Computer)", "Extracting Activation Events")) {
			foreach ($Computer in $ComputerName) {
				if ($First) {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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
				elseif ($Last) {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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
				else {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Application"; ProviderName = 'Microsoft-Windows-Security-SPP'; ID = '12288', '12289' } -ErrorAction SilentlyContinue |
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

# "HOTH", "KAMINO", "DANTOOINE" | ForEach-Object -Process { Get-KMSclientActivations -ComputerName $_ -First 1 }
