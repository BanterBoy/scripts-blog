<#

    .SYNOPSIS
    Removes the Certificate Authority (CA) database folder from the specified path.

    .DESCRIPTION
    The `Remove-CertLogDatabase` function automates the process of removing the Certificate Authority (CA) database folder from the specified path.
    It checks if the folder exists, deletes it if found, and logs the operation's success or failure to a specified log file.

    .PARAMETER DatabasePath
    Specifies the path to the CA database folder to be removed. The default path is `C:\Windows\System32\CertLog`.

    .EXAMPLE
    Remove-CertLogDatabase
    This example removes the CA database folder located at the default path `C:\Windows\System32\CertLog`.

    .EXAMPLE
    Remove-CertLogDatabase -DatabasePath "D:\CertLog"
    This example removes the CA database folder located at the specified path `D:\CertLog`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: None

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server.
    - **Valid Path**: The specified database path must exist and be accessible to the user.

    BEST PRACTICES
    - **Backup Before Removal**: Ensure that a full backup of the CA database has been performed before removing the database folder.
    - **Audit Logs**: Maintain logs of the database removal process for auditing purposes and to track any issues during the operation.
    - **Verify Path**: Double-check the database path to avoid accidentally deleting unrelated or critical files.

#>

function Remove-CertLogDatabase {
    [CmdletBinding()]
    param ([string]$DatabasePath = "C:\Windows\System32\CertLog")
    try {
        # Check if the database path exists
        if (Test-Path $DatabasePath) {
            Remove-Item -Path $DatabasePath -Recurse -Force
            Write-CAActivityLog -Message "Successfully removed CA database folder located at: $DatabasePath." -LogPath "C:\CA-Logs\remove-database.log"
        }
        else {
            Write-CAActivityLog -Message "CA database folder not found at path: $DatabasePath. No action was taken." -LogPath "C:\CA-Logs\remove-database.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA database folder. Error: $_" -LogPath $LogPath
        throw
    }
}