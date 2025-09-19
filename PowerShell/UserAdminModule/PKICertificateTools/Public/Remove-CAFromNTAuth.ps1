<#

    .SYNOPSIS
    Removes a Certificate Authority (CA) certificate from the NTAuth store.

    .DESCRIPTION
    The `Remove-CAFromNTAuth` function removes a specified CA certificate from the NTAuth store using its thumbprint.
    The NTAuth store is used to designate trusted CAs for issuing certificates in an Active Directory environment.
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER Thumbprint
    Specifies the thumbprint of the CA certificate to be removed from the NTAuth store. This parameter is required.

    .EXAMPLE
    Remove-CAFromNTAuth -Thumbprint "ABC123DEF456..."
    This example removes the CA certificate with the thumbprint `ABC123DEF456...` from the NTAuth store.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Valid Thumbprint**: The thumbprint provided must match a certificate currently in the NTAuth store.

    BEST PRACTICES
    - **Validate Thumbprint**: Ensure the thumbprint provided is accurate to avoid removing the wrong certificate from the NTAuth store.
    - **Audit Logs**: Maintain logs of certificate removal operations for auditing purposes and to track any issues during the process.
    - **Backup NTAuth Store**: Before removing a certificate, consider backing up the NTAuth store to ensure recovery in case of accidental removal.

#>

function Remove-CAFromNTAuth {
    [CmdletBinding()]
    param ([string]$Thumbprint)
    try {
        # Validate input
        if (-not $Thumbprint) {
            Write-Warning "Thumbprint must be specified to remove from NTAuth store."
            return
        }

        # Remove the certificate from the NTAuth store
        certutil -delstore "NTAuth" "$Thumbprint"
        Write-CAActivityLog -Message "Removed CA certificate from NTAuth store: $Thumbprint"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA certificate from NTAuth store. Error: $_"
        throw
    }
}