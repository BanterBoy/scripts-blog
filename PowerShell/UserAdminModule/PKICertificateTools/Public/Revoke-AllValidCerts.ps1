<#

    .SYNOPSIS
    Revokes all valid certificates issued by a specified Certificate Authority (CA).

    .DESCRIPTION
    The `Revoke-AllValidCerts` function automates the process of revoking all valid certificates issued by a specified Certificate Authority (CA).
    It retrieves all certificates with a status of "Issued" and revokes them with the reason "Cessation of Operation."
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`. This parameter is required.

    .EXAMPLE
    Revoke-AllValidCerts -CAConfig "MyServer\MyCA"
    This example revokes all valid certificates issued by the CA `MyServer\MyCA` and logs the operation.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Certificate Authority Access**: The function requires access to the specified Certificate Authority to retrieve and revoke certificates.

    BEST PRACTICES
    - **Backup Before Revocation**: Ensure that a full backup of the CA database has been performed before revoking certificates.
    - **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.
    - **Verify Certificates**: Review the list of certificates to be revoked to ensure no unintended certificates are included.

#>

function Revoke-AllValidCerts {
    [CmdletBinding()]
    param ([string]$CAConfig)
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Retrieve all valid certificates and revoke them
        $certificates = Get-CertificationAuthority -Name $CAConfig | Get-IssuedRequest | Where-Object { $_.RequestDisposition -eq "Issued" }
        foreach ($cert in $certificates) {
            Revoke-Certificate -RequestID $cert.RequestID -Reason "CessationOfOperation" -Force
            Write-CAActivityLog -Message "Revoked certificate with RequestID: $($cert.RequestID) using CAConfig: $CAConfig. Reason: Decommissioning CA" -LogPath "C:\CA-Logs\revoke-certificates.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to revoke certificates. Error: $_"
        throw
    }
}