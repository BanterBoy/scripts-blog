<#
.SYNOPSIS
Starts a process on a remote computer.

.DESCRIPTION
The Start-ProcessOnComputer function starts a process on a remote computer. 
It uses the Invoke-Command cmdlet to run a script block on the remote machine, 
and within that script block, it uses the Start-Process cmdlet to start the process.

.PARAMETER ComputerName
The name of the computer on which to start the process.

.PARAMETER Name
The name of the process to start.

.PARAMETER Credential
The credentials to use to start the process. If not provided, the current user's credentials are used.

.EXAMPLE
Start-ProcessOnComputer -ComputerName "Server01" -Name "notepad.exe"

Starts the notepad.exe process on the computer named Server01.
#>
function Start-ProcessOnComputer {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Enter the name of the computer.")]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the process to start.")]
        [string]$Name,

        [Parameter(HelpMessage = "Enter the credentials to use. If not provided, the current user's credentials are used.")]
        [System.Management.Automation.PSCredential]$Credential
    )

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Start process $Name")) {
            try {
                Write-Verbose "Attempting to start process $Name on $ComputerName..."
                $scriptBlock = {
                    param($Name)
                    $process = Start-Process -FilePath $Name -PassThru
                    $process | Format-List * | Out-String
                }

                $invokeParams = @{
                    ComputerName = $ComputerName
                    ScriptBlock  = $scriptBlock
                    ArgumentList = $Name
                }
                if ($null -ne $Credential) {
                    $invokeParams.Credential = $Credential
                }
                $processDetails = Invoke-Command @invokeParams
                Write-Verbose "Process $Name started on $ComputerName successfully. Details: `n$processDetails"
            }
            catch {
                Write-Error -Message "Failed to start process on Server ${ComputerName}: $_"
            }
        }
    }
}
