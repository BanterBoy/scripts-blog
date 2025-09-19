<#

    .SYNOPSIS
    Removes the Certificate Authority (CA) role from a specified computer.

    .DESCRIPTION
    The `Remove-CASolution` function automates the process of removing the Certificate Authority (CA) role from a specified computer.
    It uses the `ADCSAdministration` module to identify and remove the CA role. The function supports filtering by CA type and includes
    a force option to bypass type checks. Logs the operation's success or failure to a specified log file.

    .PARAMETER ComputerName
    Specifies the name of the computer from which the CA role will be removed. The default is the local computer.

    .PARAMETER CATypeToRemove
    Specifies the types of CA roles to be removed. Valid values are `EnterpriseSubordinate`, `StandaloneSubordinate`, `EnterpriseRoot`, and `StandaloneRoot`.
    The default is `@('EnterpriseSubordinate', 'StandaloneSubordinate')`.

    .PARAMETER Force
    Forces the removal of the CA role, bypassing the CA type check.

    .EXAMPLE
    Remove-CASolution -ComputerName "CA-Server01"
    This example removes the CA role from the computer `CA-Server01` if its type matches the default types to remove.

    .EXAMPLE
    Remove-CASolution -ComputerName "CA-Server01" -CATypeToRemove "EnterpriseRoot"
    This example removes the `EnterpriseRoot` CA role from the computer `CA-Server01`.

    .EXAMPLE
    Remove-CASolution -ComputerName "CA-Server01" -Force
    This example forces the removal of the CA role from the computer `CA-Server01`, bypassing the CA type check.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the target computer.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Service Access**: The function requires access to the `CertSvc` service on the target computer.

    BEST PRACTICES
    - **Backup Before Removal**: Ensure that a full backup of the CA database and private keys has been performed before removing the CA role.
    - **Audit Logs**: Maintain logs of the CA removal process for auditing purposes and to track any issues during the operation.
    - **Verify Removal**: After running the function, verify that the CA role and associated services have been successfully removed.

#>
function Remove-CASolution {
    [CmdletBinding()]
    param (
        [string]$ComputerName = $env:COMPUTERNAME,
        [ValidateSet('EnterpriseSubordinate', 'StandaloneSubordinate', 'EnterpriseRoot', 'StandaloneRoot')]
        [string[]]$CATypeToRemove = @('EnterpriseSubordinate', 'StandaloneSubordinate'),
        [switch]$Force
    )
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Use ADCSAdministration cmdlets to remove the CA role
        $ca = Get-CertificationAuthority -ComputerName $ComputerName
        if ($ca.CAType -in $CATypeToRemove -or $Force) {
            Stop-Service -Name CertSvc -Force
            Remove-CertificationAuthority -InputObject $ca -Force
            Write-CAActivityLog -Message "Removed CA role for $($ca.Name) on $ComputerName." -LogPath "C:\CA-Logs\remove-ca.log"
        }
        else {
            Write-CAActivityLog -Message "Skipped CA removal for $($ca.Name) on $ComputerName. CA type does not match selection." -LogPath "C:\CA-Logs\remove-ca.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA solution. Error: $_"
        throw
    }
}