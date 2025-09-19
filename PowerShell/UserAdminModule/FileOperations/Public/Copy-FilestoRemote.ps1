function Copy-FilestoRemote {

    <#
	.SYNOPSIS
		A brief description of the Copy-FilestoRemote function.
	
	.DESCRIPTION
		A detailed description of the Copy-FilestoRemote function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER Credentials
		A description Credentials parameter.
	
	.PARAMETER LocalFile
		A description LocalFile parameter.
	
	.PARAMETER RemotePath
		A description RemotePath parameter.
	
	.EXAMPLE
		Copy-FilestoRemote -ComputerName "SERVER1" -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
		This will 

        .EXAMPLE
		Copy-FilestoRemote -ComputerName "SERVER1" -Credentials (Get-Credential) -LocalFile C:\Temp\Test.txt -RemotePath "C:\Temp\"
		This will 

	.EXAMPLE
		$Creds = Get-Credential
        $Files = @(
        (Get-ChildItem -Path C:\GitRepos\ -File).FullName
        )
        $Files | ForEach-Object -Process { Copy-FilestoRemote -ComputerName "SERVER1" -Credentials $credentials -LocalFile $_ -RemotePath "C:\Temp\" }
		This will 
	
	.OUTPUTS
		None
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		- EmailAddress [string[]]
	
	.LINK
		https://scripts.lukeleigh.com
		New-PSSession
        Copy-Item
        Remove-PSSession
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [ValidateScript( { 
                if (Test-Connection -ComputerName $_ -Quiet -Count 1 -ErrorAction SilentlyContinue ) {
                    $true
                }
                else {
                    throw "$_ is unavailable"
                }
            })]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the full path of the file to be copied.'
        )]
        [string[]]$LocalFile,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the destination path on the remote computer'
        )]
        [string[]]$RemotePath

    )

    begin {
        $File = Split-Path $LocalFile -Leaf
    }

    process {

        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess($Computer, "Copy $File to $RemotePath")) {

                # Create a remote session to the destination computer.
                if ($Credentials) {
                    $NewPSSession = New-PSSession -ComputerName $Computer -Credential $Credentials
                }
                else {
                    $NewPSSession = New-PSSession -ComputerName $Computer
                }

                # Copy  the file to the remote session.
                $Test = Invoke-Command -Session $NewPSSession -ScriptBlock { Test-Path -Path "C:\Temp" -ErrorAction SilentlyContinue }
                if ($Test) {
                    Copy-Item -Path "$LocalFile" -Destination "$RemotePath" -ToSession $NewPSSession
                }
                else {
                    Invoke-Command -Session $NewPSSession -ScriptBlock { New-Item -Path C:\ -Name Temp -ItemType Directory -Force } -ErrorAction SilentlyContinue
                    Copy-Item -Path "$LocalFile" -Destination "$RemotePath" -ToSession $NewPSSession
                }

                # Terminate the remote session.
                Remove-PSSession -Session $NewPSSession

            }

        }

    }

    end {
    }

}
