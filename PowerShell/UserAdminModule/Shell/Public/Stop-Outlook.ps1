<#
.SYNOPSIS
    Stops the Outlook process if it is running.

.DESCRIPTION
    This function checks if the Outlook process is running. If it is, the function stops the process.

.PARAMETER None
    This function does not take any parameters.

.EXAMPLE
    PS C:\> Stop-Outlook
    Checks if Outlook is running and stops the process if it is.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Stop-Outlook {
	[CmdletBinding()]
	param ()

	# Verbose output indicating the start of the function
	Write-Verbose "Starting Stop-Outlook function..."

	# Check if the Outlook process is running
	$OutlookRunning = Get-Process -ProcessName "Outlook" -ErrorAction SilentlyContinue

	if ($null -ne $OutlookRunning) {
		Write-Verbose "Outlook is running. Attempting to stop the process..."
		Stop-Process -ProcessName "Outlook" -Force
		Write-Output "Outlook process has been stopped."
	}
 else {
		Write-Verbose "Outlook is not running."
		Write-Output "Outlook process is not running."
	}

	# Verbose output indicating the end of the function
	Write-Verbose "Stop-Outlook function completed."
}

# Example call to the function with verbose output
# Stop-Outlook -Verbose
