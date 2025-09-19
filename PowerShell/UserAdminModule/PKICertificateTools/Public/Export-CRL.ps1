<#
    .SYNOPSIS
    Exports the Certificate Revocation List (CRL) from the Certificate Authority (CA) to a specified directory.

    .DESCRIPTION
    The `Export-CRL` function automates the process of exporting the Certificate Revocation List (CRL) from the Certificate Authority (CA).
    It ensures the specified output directory exists, uses the `certutil` command to generate the CRL, and copies the CRL files to the specified directory.
    Logs the operation's success or failure to a specified log file.

    .PARAMETER OutputPath
    Specifies the directory where the CRL files will be exported. If the directory does not exist, it will be created.
    The default path is `C:\CA-CRL`.

    .EXAMPLE
    Export-CRL
    This example exports the CRL to the default path `C:\CA-CRL`.

    .EXAMPLE
    Export-CRL -OutputPath "D:\CRL-Exports"
    This example exports the CRL to the specified path `D:\CRL-Exports`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to export the CRL.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Output Directory**: The specified output directory must be accessible to the user and have sufficient disk space to store the exported CRL files.

    BEST PRACTICES
    - **Secure Export Location**: Store the exported CRL files in a secure location with restricted access to prevent unauthorized modifications.
    - **Regular Exports**: Schedule regular CRL exports to ensure that revoked certificates are properly communicated to relying parties.
    - **Audit Logs**: Maintain logs of CRL export operations for auditing purposes and to track any issues during the process.
    - **Verify CRL Distribution**: After exporting, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.


#>

function Export-CRL {
    [CmdletBinding()]
    param ([string]$OutputPath = "C:\CA-CRL")
    try {
        # Ensure the output directory exists
        if (-not (Test-Path $OutputPath)) {
            New-Item -Path $OutputPath -ItemType Directory -Force
        }

        # Export the CRL
        certutil -crl
        Copy-Item -Path "C:\Windows\System32\CertSrv\CertEnroll\*.crl" -Destination $OutputPath -Force
        $exportedFiles = Get-ChildItem -Path $OutputPath -Filter *.crl | ForEach-Object { $_.Name } -join ', '
        Write-CAActivityLog -Message "CRL exported successfully. Files exported to: $OutputPath. Exported files: $exportedFiles" -LogPath "C:\CA-Logs\export-crl.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to export CRL. Error: $_" -LogPath $LogPath
        throw
    }
}