<#
.SYNOPSIS
    Stops a specified process on one or more remote computers.

.DESCRIPTION
    This function retrieves the specified process on the provided remote computers and attempts to terminate it.
    If the process is not running, it provides an appropriate error message.

.PARAMETER ComputerName
    The name(s) of the remote computer(s) on which to stop the process.

.PARAMETER ProcessName
    The name of the process to be stopped (without the ".exe" extension).

.EXAMPLE
    PS C:\> Stop-FailedService -ComputerName "Server1", "Server2" -ProcessName "notepad"
    Attempts to stop the notepad process on Server1 and Server2.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Stop-FailedService {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $true)]
        [string]
        $ProcessName
    )

    # Verbose output indicating the start of the function
    Write-Verbose "Starting Stop-FailedService function..."

    foreach ($Computer in $ComputerName) {
        Write-Verbose "Processing computer: $Computer"

        # Retrieve the process information from the remote computer
        $Process = Get-CimInstance -ClassName "CIM_Process" -Namespace "root/CIMV2" -ComputerName "$Computer" | Where-Object -Property Name -Like ($ProcessName + ".exe")
        
        if ($null -ne $Process) {
            Write-Verbose "Process $ProcessName found on $Computer. Attempting to terminate..."

            # Attempt to dispose of the process
            $returnval = $Process.Dispose()
            $processid = $Process.Handle
            
            if ($null -eq $returnval) {
                Write-Output "The process $ProcessName `($processid`) terminated successfully on Server $Computer"
            }
            else {
                Write-Error -Message "The process $ProcessName `($processid`) termination encountered problems on Server $Computer"
            }
        }
        else {
            Write-Error -Message "Process $ProcessName not running on Server $Computer"
        }
    }

    # Verbose output indicating the end of the function
    Write-Verbose "Stop-FailedService function completed."
}

# Example call to the function with verbose output
# Stop-FailedService -ComputerName "Server1", "Server2" -ProcessName "notepad" -Verbose
