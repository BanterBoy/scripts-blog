<#
    .SYNOPSIS
    Backs up the Certificate Authority (CA) database and private keys.

    .DESCRIPTION
    The `Backup-CAServer` function performs a backup of the Certificate Authority (CA) database and private keys.
    It ensures the specified backup directory exists, then uses the `certutil` command to back up the CA database
    and keys. Logs the operation's success or failure to a specified log file.

    .PARAMETER BackupPath
    Specifies the directory where the CA database and keys will be backed up. If the directory does not exist,
    it will be created. The default path is `C:\CA-Backup`.

    .EXAMPLE
    Backup-CAServer
    This example backs up the CA database and keys to the default path `C:\CA-Backup`.

    .EXAMPLE
    Backup-CAServer -BackupPath "D:\Backups\CA"
    This example backs up the CA database and keys to the specified path `D:\Backups\CA`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to perform backup operations.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Backup Directory**: The specified backup directory must be accessible to the user and have sufficient disk space to store the CA database and private keys.

    BEST PRACTICES
    - **Secure Backup Location**: Store the backup in a secure location with restricted access to prevent unauthorized access to the CA database and private keys.
    - **Encryption**: Consider encrypting the backup directory or using a secure storage solution to protect sensitive data.
    - **Regular Backups**: Schedule regular backups of the CA database and private keys to ensure data recovery in case of failure or corruption.
    - **Test Restores**: Periodically test the restore process to verify the integrity of the backups and ensure they can be used in a disaster recovery scenario.
    - **Audit Logs**: Maintain logs of backup operations for auditing purposes and to track any issues during the backup process.

#>

function Backup-CAServer {
    [CmdletBinding()]
    param ([string]$BackupPath = "C:\CA-Backup")
    try {
        # Ensure the backup directory exists
        if (-not (Test-Path $BackupPath)) {
            New-Item -Path $BackupPath -ItemType Directory -Force
        }

        # Perform the CA database and key backup
        certutil -backupdb $BackupPath
        certutil -backupkey $BackupPath
        Write-CAActivityLog -Message "CA backup completed successfully. Database and keys backed up to: $BackupPath" -LogPath "C:\CA-Logs\backup.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to back up the CA server. Error: $_"
        throw
    }
} {
    [CmdletBinding()]
    param ([string]$BackupPath = "C:\CA-Backup")
    try {
        # Ensure the backup directory exists
        if (-not (Test-Path $BackupPath)) {
            New-Item -Path $BackupPath -ItemType Directory -Force
        }

        # Perform the CA database and key backup
        certutil -backupdb $BackupPath
        certutil -backupkey $BackupPath
        Write-CAActivityLog -Message "CA backup completed successfully. Database and keys backed up to: $BackupPath" -LogPath "C:\CA-Logs\backup.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to back up the CA server. Error: $_"
        throw
    }
}