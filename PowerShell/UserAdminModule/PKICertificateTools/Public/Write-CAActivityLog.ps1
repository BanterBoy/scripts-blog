<#

    .SYNOPSIS
    Writes a log entry to a specified log file with a timestamp.

    .DESCRIPTION
    The `Write-CAActivityLog` function automates the process of writing log entries to a specified log file.
    It ensures the log directory exists, appends the log entry with a timestamp, and supports verbose output for additional context.
    If the log directory does not exist, it is created automatically.

    .PARAMETER Message
    Specifies the message to be logged. This parameter is mandatory.

    .PARAMETER LogPath
    Specifies the path to the log file where the message will be written. If not provided, the default path is `C:\CA-Logs\activity.log`.

    .EXAMPLE
    Write-CAActivityLog -Message "CA backup completed successfully."
    This example writes the message "CA backup completed successfully." to the default log file.

    .EXAMPLE
    Write-CAActivityLog -Message "Failed to revoke certificate." -LogPath "D:\Logs\CAActivity.log"
    This example writes the message "Failed to revoke certificate." to the specified log file `D:\Logs\CAActivity.log`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: None

    REQUIREMENTS
    - **Write Permissions**: The user running this function must have write permissions to the specified log file and its directory.
    - **Valid Log Path**: The specified log path must be accessible and valid.

    BEST PRACTICES
    - **Centralized Logging**: Use a centralized and secure location for log files to ensure they are accessible for auditing and troubleshooting.
    - **Log Rotation**: Implement log rotation or archiving to prevent the log file from growing too large over time.
    - **Error Handling**: Monitor warnings for any failures to write to the log file and address permission or path issues promptly.

#>

function Write-CAActivityLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [string]$LogPath = "C:\CA-Logs\activity.log" # Updated default log path to a more generic location
    )
    try {
        # Ensure the log directory exists
        if (-not (Test-Path (Split-Path $LogPath))) {
            New-Item -Path (Split-Path $LogPath) -ItemType Directory -Force | Out-Null
        }

        # Write the log entry with a timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp`t$Message" | Out-File -FilePath $LogPath -Append -Encoding UTF8
        Write-Verbose $Message
    }
    catch {
        Write-Warning "Failed to write to log file: $LogPath. Error: $_"
    }
}