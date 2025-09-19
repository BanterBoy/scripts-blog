<#
.SYNOPSIS
Stops a specified process on one or more computers.

.DESCRIPTION
The Stop-ProcessOnComputer function stops a specified process on one or more computers. 
It uses the CIM_Process class to find and stop the process.

.PARAMETER ComputerName
The names of the computers where the process should be stopped. 
This parameter accepts pipeline input and can be used in a pipeline command.

.PARAMETER Name
The name of the process to stop. 
This parameter accepts pipeline input and can be used in a pipeline command.

.PARAMETER Force
If this switch is provided, the function will forcefully terminate the process.

.PARAMETER Credential
The credentials to use when connecting to the computers. 
If not provided, the function will use the current user's credentials.

.EXAMPLE
$cred = Get-Credential
"Server1", "Server2" | Stop-ProcessOnComputer -Name "Notepad" -Credential $cred

This example stops the Notepad process on Server1 and Server2 using the provided credentials.

.EXAMPLE
Stop-ProcessOnComputer -ComputerName "Server1" -Name "Notepad" -Force

This example forcefully stops the Notepad process on Server1.
#>
function Stop-ProcessOnComputer {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Default')]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The names of the computers where the process should be stopped.")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The name of the process to stop.", ParameterSetName = 'Default')]
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The name of the process to stop.", ParameterSetName = 'Force')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(HelpMessage = "If this switch is provided, the function will forcefully terminate the process.", ParameterSetName = 'Force')]
        [switch]
        $Force,

        [Parameter(HelpMessage = "The credentials to use when connecting to the computers. If not provided, the function will use the current user's credentials.")]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Stop process $Name")) {
                try {
                    $cimParams = @{
                        ClassName    = "Win32_Process"
                        Namespace    = "root/CIMV2"
                        ComputerName = "$Computer"
                    }
                    if ($null -ne $Credential) {
                        $cimParams.Credential = $Credential
                    }
                    $Process = Get-CimInstance @cimParams | Where-Object -Property Name -Like ($Name + ".exe")

                    if ($Process) {
                        $Process | ForEach-Object {
                            $result = Invoke-CimMethod -InputObject $_ -MethodName "Terminate"
                            [PSCustomObject]@{
                                ComputerName    = $Computer
                                ProcessName     = $_.Name
                                ProcessId       = $_.ProcessId
                                TerminateResult = $result.ReturnValue
                            }
                        }
                    }
                }
                catch {
                    Write-Error -Message "Failed to get process information from Server ${Computer}: $_"
                }
            }
        }
    }    
}
