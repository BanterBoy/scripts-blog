<#
.SYNOPSIS
    Monitors and stops non-responding processes after a specified timeout.

.DESCRIPTION
    This function continuously monitors processes with a window and stops those that are non-responding for longer than the specified timeout. 
    The user is presented with a selection of non-responding processes to kill.

.PARAMETER None
    This function does not take any parameters.

.EXAMPLE
    PS C:\> Stop-NonRespondingProcesses
    Continuously monitors and stops non-responding processes based on user selection.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Stop-NonRespondingProcesses {
    [CmdletBinding()]
    param ()

    $timeout = 3
    # Initialize a hash table to keep track of processes
    $hash = @{}
    
    # Verbose output indicating the start of the function
    Write-Verbose "Starting Stop-NonRespondingProcesses function..."

    # Use an endless loop to continuously monitor processes
    do {
        Write-Verbose "Checking processes for non-responding state..."
        Get-Process |
        # Filter for processes with a window
        Where-Object MainWindowTitle |
        ForEach-Object {
            # Use process ID as key to the hash table
            $key = $_.Id
            # If the process is responding, reset the counter
            if ($_.Responding) {
                $hash[$key] = 0
                Write-Verbose "Process $key ($($_.Name)) is responding."
            }
            # Else, increment the counter by one
            else {
                $hash[$key]++
                Write-Verbose "Process $key ($($_.Name)) is not responding. Counter: $($hash[$key])"
            }
        }
        
        # Copy the hash table keys so that the collection can be modified
        $keys = @($hash.Keys).Clone()

        # Emit all processes hanging for longer than $timeout seconds
        $keys |
        # Take the ones not responding for the time specified in $timeout
        Where-Object { $hash[$_] -gt $timeout } |
        ForEach-Object {
            # Reset the counter (in case you choose not to kill them)
            $hash[$_] = 0
            # Emit the process for the process ID on record
            Get-Process -Id $_
        } |
        # Exclude those that already exited
        Where-Object { $_.HasExited -eq $false } |
        # Show properties
        Select-Object -Property Id, Name, StartTime, HasExited |
        # Show hanging processes. The process(es) selected by the user will be killed
        Out-GridView -Title "Select apps to kill that are hanging for more than $timeout seconds" -PassThru |
        # Kill selected processes
        Stop-Process -Force

        # Sleep for a second
        Start-Sleep -Seconds 1
    
    } while ($true)

    # Verbose output indicating the end of the function
    Write-Verbose "Stop-NonRespondingProcesses function completed."
}

# Example call to the function with verbose output
# Stop-NonRespondingProcesses -Verbose
