# RegWriteBruteForce: Because efficiency beats beauty. The function below reliably writes to the registry, locally or on remote machines.
# Example: RegWriteBruteForce -ComputerName $Computer -KeyName 'HKLM\Software\HappyAdmin' -ValueName $FunFactor -Value 'high' -DataType REG_SZ

function Set-RegEntry {

    Param(
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
			HelpMessage = 'Enter computer name or pipe input'
		)]
        [String[]]
        $KeyName,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
        [String[]]
        $ValueName,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
        [String[]]
        $Value,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
        [ValidateSet('REG_SZ', 'REG_MULTI_SZ', 'REG_EXPAND_SZ', 'REG_DWORD', 'REG_QWORD', 'REG_BINARY', 'REG_NONE')]
        [String[]]
        $DataType = 'REG_SZ'
    )

    $arg = 'ADD \\' + $Computer + '\' + $KeyName + ' /v ' + $ValueName + ' /t ' + $DataType + ' /d ' + $Value + " /f"

    $process = (Start-Process -FilePath reg.exe -ArgumentList $arg -WindowStyle Hidden -PassThru) 
    $process.WaitForExit() 
    return $(if ($process.ExitCode -eq 0) { $true } else { $false }) # return true if successful
}
