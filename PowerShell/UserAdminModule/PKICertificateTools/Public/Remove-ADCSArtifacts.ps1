<#

    .SYNOPSIS
    Removes Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA).

    .DESCRIPTION
    The `Remove-ADCSArtifacts` function automates the removal of Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA).
    It uses the `ADCSAdministration` module to locate and remove the CA from Active Directory. The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAName
    Specifies the name of the Certificate Authority to be removed from Active Directory.

    .PARAMETER DomainDN
    Specifies the distinguished name (DN) of the Active Directory domain where the CA is located.

    .EXAMPLE
    Remove-ADCSArtifacts -CAName "MyCA" -DomainDN "DC=example,DC=com"
    This example removes the ADCS artifacts for the CA named "MyCA" from the specified Active Directory domain.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server and in the Active Directory domain.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Active Directory Access**: The function requires access to the Active Directory domain where the CA is located.

    BEST PRACTICES
    - **Backup Before Removal**: Ensure that a full backup of the CA database and private keys has been performed before removing ADCS artifacts.
    - **Audit Logs**: Maintain logs of the removal process for auditing purposes and to track any issues during the operation.
    - **Verify Removal**: After running the function, verify that all ADCS-related objects have been successfully removed from Active Directory.

#>

function Remove-ADCSArtifacts {
    [CmdletBinding()]
    param (
        [string]$CAName,
        [string]$DomainDN
    )
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Remove ADCS-related objects using ADCSAdministration cmdlets
        $ca = Get-CertificationAuthority -Name $CAName
        Remove-CertificationAuthority -InputObject $ca -Force
        Write-CAActivityLog -Message "Removed Certification Authority: $CAName from Active Directory." -LogPath "C:\CA-Logs\remove-adcs-artifacts.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove ADCS artifacts. Error: $_"
        throw
    }
}