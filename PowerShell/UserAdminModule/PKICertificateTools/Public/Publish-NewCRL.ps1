<#

    .SYNOPSIS
    Publishes a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA) and optionally copies it to specified UNC paths.

    .DESCRIPTION
    The `Publish-NewCRL` function automates the process of publishing a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA).
    It uses the `ADCSAdministration` module to publish the CRL and optionally copies the CRL files to specified UNC paths for distribution.
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`.

    .PARAMETER LogPath
    Specifies the path to the log file where the CRL publishing process will be logged. The default path is `C:\CA-Logs\crl-publish.log`.

    .PARAMETER UNCPaths
    Specifies an array of UNC paths where the CRL files will be copied after publishing.

    .PARAMETER Force
    Forces the CRL publishing operation without prompting for confirmation.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA"
    This example publishes a new CRL for the CA `MyServer\MyCA` and logs the operation to the default log path.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA" -UNCPaths "\\FileShare1\CRL", "\\FileShare2\CRL"
    This example publishes a new CRL for the CA `MyServer\MyCA` and copies the CRL files to the specified UNC paths.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA" -Force
    This example forces the publishing of a new CRL for the CA `MyServer\MyCA` without prompting for confirmation.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Certificate Authority Access**: The function requires access to the specified Certificate Authority to publish the CRL.
    - **UNC Path Permissions**: If UNC paths are specified, the user must have write permissions to the target locations.

    BEST PRACTICES
    - **Secure Distribution**: Ensure that the UNC paths used for CRL distribution are secure and accessible only to authorized users.
    - **Regular Publishing**: Schedule regular CRL publishing to ensure that revoked certificates are properly communicated to relying parties.
    - **Audit Logs**: Maintain logs of CRL publishing operations for auditing purposes and to track any issues during the process.
    - **Verify Distribution**: After publishing, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.

#>

function Publish-NewCRL {
    [CmdletBinding()]
    param (
        [string]$CAConfig,
        [string]$LogPath = "C:\CA-Logs\crl-publish.log",
        [string[]]$UNCPaths,
        [switch]$Force
    )
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Publish the CRL using ADCSAdministration cmdlets
        $ca = Get-CertificationAuthority -Name $CAConfig
        Publish-CertificateRevocationList -InputObject $ca -Force:$Force
        Write-CAActivityLog -Message "Published CRL for CA: $CAConfig." -LogPath $LogPath

        # Copy CRL to UNC paths if specified
        if ($UNCPaths) {
            $crlFiles = Get-ChildItem -Path "C:\Windows\System32\CertSrv\CertEnroll\*.crl"
            foreach ($file in $crlFiles) {
                foreach ($unc in $UNCPaths) {
                    $dest = Join-Path -Path $unc -ChildPath $file.Name
                    Copy-Item -Path $file.FullName -Destination $dest -Force
                    Write-CAActivityLog -Message "Copied CRL file to UNC path: $dest" -LogPath $LogPath
                }
            }
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to publish CRL. Error: $_" -LogPath $LogPath
        throw
    }
}
