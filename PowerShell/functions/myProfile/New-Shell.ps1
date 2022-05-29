function New-Shell {
	
	<#
		.Synopsis
			Starts an Elevated PowerShell Console.
		
		.Description
			Opens a new PowerShell Console Elevated as Administrator. If the user is already running an elevated
			administrator shell, a message is displayed in the console session.
		.PARAMETER User
			A description of the User parameter. Brief explanation of the parameter and its requirements/function
		
		.PARAMETER RunAs
			A description of the RunAs parameter. Brief explanation of the parameter and its requirements/function
		
		.PARAMETER RunAsUser
			A description of the RunAsUser parameter. Brief explanation of the parameter and its requirements/function
		
		.PARAMETER Credentials
			A description of the Credentials parameter. Brief explanation of the parameter and its requirements/function
		
		.EXAMPLE
			PS C:\> New-Shell -RunAs PowerShellRunAs
			Launch PowerShell a new elevated Shell as current user.
		.EXAMPLE
			PS C:\> New-Shell -RunAsUser PowerShellRunAsUser -Credentials (Get-Credential)
			Launch PowerShell a new Shell as specified user.
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'User')]
	param
	(
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'User',
				   Mandatory = $false,
				   Position = 0,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShell', 'pwsh')]
		[string]
		$User,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAs',
				   Mandatory = $false,
				   Position = 0,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShellRunAs', 'pwshRunAs')]
		[string]
		$RunAs,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAsUser',
				   Mandatory = $false,
				   Position = 1,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShellRunAsUser', 'pwshRunAsUser')]
		[string]
		$RunAsUser,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAsUser',
				   Mandatory = $true,
				   Position = 2,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[pscredential]
		$Credentials
		
	)
	
	switch ($User)
	{
		PowerShell {
			Start-Process -FilePath:"PowerShell.exe" -PassThru:$true
		}
		pwsh {
			Start-Process -FilePath:"pwsh.exe" -PassThru:$true
		}
	}
	switch ($RunAs)
	{
		PowerShellRunAs {
			Start-Process -FilePath:"PowerShell.exe" -Verb:RunAs -PassThru:$true
		}
		pwshRunAs {
			Start-Process -FilePath:"pwsh.exe" -Verb:RunAs -PassThru:$true
		}
	}
	switch ($RunAsUser)
	{
		PowerShellRunAsUser {
			Start-Process -Credential:$Credentials -FilePath:"PowerShell.exe" -LoadUserProfile:$true -UseNewEnvironment:$true -ArgumentList @("-Mta")
		}
		pwshRunAsUser {
			Start-Process -Credential:$Credentials -FilePath:"pwsh.exe" -LoadUserProfile:$true -UseNewEnvironment:$true -ArgumentList @("-Mta")
		}
	}
}
