<#
    .SYNOPSIS
    Retrieves certificates from a specified certificate store on the local machine.

    .DESCRIPTION
    The `Get-CACertificateInfo` function retrieves certificates from a specified certificate store on the local machine.
    It can retrieve all certificates in the store or filter by a specific certificate thumbprint. The function uses the
    `Get-Certificate` cmdlet to query the certificate store and returns the matching certificates.

    .PARAMETER StoreName
    Specifies the name of the certificate store to query. The default store is `CA`.

    .PARAMETER CertThumbprint
    Specifies the thumbprint of the certificate to retrieve. If not provided, all certificates in the specified store will be returned.

    .EXAMPLE
    Get-CACertificateInfo
    This example retrieves all certificates from the default `CA` certificate store.

    .EXAMPLE
    Get-CACertificateInfo -StoreName "My" -CertThumbprint "ABC123DEF456..."
    This example retrieves a specific certificate with the thumbprint `ABC123DEF456...` from the `My` certificate store.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: PowerShell Certificate Cmdlets

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges to access the certificate store.
    - **Certificate Store Access**: The function requires access to the specified certificate store on the local machine.
    - **PowerShell Certificate Cmdlets**: The `Get-Certificate` cmdlet must be available on the system. This is included in modern versions of PowerShell.

    BEST PRACTICES
    - **Secure Access**: Ensure that only authorized users have access to the certificate store to prevent unauthorized modifications or access to sensitive certificates.
    - **Validate Thumbprints**: When filtering by thumbprint, ensure the thumbprint is accurate to avoid retrieving incorrect certificates.
    - **Audit Logs**: Maintain logs of certificate retrieval operations for auditing purposes and to track any issues during the process.


#>

function Get-CACertificateInfo {
    [CmdletBinding()]
    param (
        [string]$StoreName = "CA",
        [string]$CertThumbprint
    )
    try {
        # Retrieve certificates using ADCSAdministration
        if (-not $CertThumbprint) {
            $certs = Get-Certificate -CertStoreLocation "Cert:\LocalMachine\$StoreName"
        }
        else {
            $certs = Get-Certificate -CertStoreLocation "Cert:\LocalMachine\$StoreName" | Where-Object { $_.Thumbprint -eq $CertThumbprint }
        }

        # Return the certificates
        return $certs
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to retrieve certificates from store '$StoreName'. Error: $_"
        throw
    }
}