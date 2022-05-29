function Connect-PSExec {
    <#
	.SYNOPSIS
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer.
	
	.DESCRIPTION
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted in the powershell session.
	
	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN
	
	.EXAMPLE
		Connect-PSExec -ComputerName COMPUTERNAME
	
	.OUTPUTS
		System.String. Connect-PSExec
	
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
		PsExec.exe
		powershell.exe
        cmd.exe
#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('cpsxc')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Select which Prompt you would like to connect to.')]
        [ValidateSet('PowerShell', 'Command')]
        [string[]]
        $Prompt
    )

    BEGIN {
    }
    PROCESS {

        switch ($Prompt) {
            'PowerShell' {
                foreach ($Computer in $ComputerName) {
                if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                                & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                            }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            'Command' {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC Command Prompt session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer cmd.exe
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            Default {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
        }
    }
    END {
    }
}
