<#

    .SYNOPSIS
    Revokes a specific Certificate Authority (CA) certificate using its thumbprint.

    .DESCRIPTION
    The `Revoke-CACertificate` function automates the process of revoking a specific CA certificate by its thumbprint.
    It uses the `ADCSAdministration` module to revoke the certificate and logs the operation's success or failure to a specified log file.
    The function supports specifying a reason code for the revocation.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`. This parameter is required.

    .PARAMETER Thumbprint
    Specifies the thumbprint of the CA certificate to be revoked. This parameter is required.

    .PARAMETER ReasonCode
    Specifies the reason code for the revocation. Valid values include:
    - `0`: Unspecified
    - `1`: Key Compromise
    - `2`: CA Compromise
    - `3`: Affiliation Changed
    - `4`: Superseded
    - `5`: Cessation of Operation
    - `6`: Certificate Hold

    .EXAMPLE
    Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..." -ReasonCode 5
    This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` with the reason code `5` (Cessation of Operation).

    .EXAMPLE
    Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..."
    This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` using the default reason code `0` (Unspecified).

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Valid Thumbprint**: The thumbprint provided must match an existing certificate issued by the specified CA.

    BEST PRACTICES
    - **Verify Thumbprint**: Ensure the thumbprint provided is accurate to avoid revoking the wrong certificate.
    - **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.
    - **Backup Before Revocation**: Perform a backup of the CA database before revoking certificates to ensure recovery if needed.

#>

function Revoke-CACertificate {
    [CmdletBinding()]
    param (
        [string]$CAConfig,
        [string]$Thumbprint,
        [ValidateSet(
            0, # Unspecified
            1, # Key Compromise
            2, # CA Compromise
            3, # Affiliation Changed
            4, # Superseded
            5, # Cessation of Operation
            6  # Certificate Hold
        )]
        [int]$ReasonCode = 0
    )
    try {
        # Validate input
        if (-not $Thumbprint) {
            Write-Warning "Thumbprint must be specified to revoke a CA certificate."
            return
        }

        # Revoke the certificate using ADCSAdministration
        Revoke-Certificate -CAConfig $CAConfig -Thumbprint $Thumbprint -Reason $ReasonCode
        Write-CAActivityLog -Message "CA certificate with thumbprint $Thumbprint revoked with reason code $ReasonCode."
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to revoke CA certificate. Error: $_"
        throw
    }
}