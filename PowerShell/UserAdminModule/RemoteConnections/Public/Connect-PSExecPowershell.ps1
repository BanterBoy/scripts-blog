#requires -PSEdition Desktop
function Connect-PSExecPowershell {
    <#
	.SYNOPSIS
		Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer.
	
	.DESCRIPTION
		Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted.
	
	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN
	
	.EXAMPLE
		Connect-PSExecPowershell -ComputerName COMPUTERNAME
		Starts an RDP session to COMPUTERNAME
	
	.OUTPUTS
		System.String. Connect-PSExecPowershell
	
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
#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
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
        $ComputerName
    )

    BEGIN {
        $psExecPath = Join-Path $PSScriptRoot 'resources/PsExec.exe'
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$($Computer)", "Establishing PSEXEC PowerShell Console session")) {
            foreach ($Computer in $ComputerName) {
                try {
                    if ($PSCmdlet.ShouldProcess("$($Computer)", "Establishing PSEXEC Session")) {
                        & $psExecPath \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                    }
                }
                catch {
                    Write-Error "Unable to connect to $($Computer)"
                }
            }
        }
    }
    END {
    }
}
