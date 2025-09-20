function Get-ADDiagnosticConfiguration {
    <#
        .SYNOPSIS
        Retrieves Active Directory diagnostic logging levels for the specified instance.

        .DESCRIPTION
        This function is a direct wrapper around Get-ADDiagnosticLogging. It allows you to retrieve diagnostic logging levels for a specified Domain Controller or LDS instance using the same parameters as Get-ADDiagnosticLogging. All parameters in this function map directly to those in Get-ADDiagnosticLogging:
        
        - InstanceType: Specifies the type of instance ("DomainController" or "LDS").
        - LoggingLevels: Specifies the diagnostic logging levels to retrieve.
        - LDSInstanceName: (Optional) Specifies the name of the LDS instance if InstanceType is "LDS".
        - ComputerName: Specifies the target computer.
        
        There are no additional features or differences from Get-ADDiagnosticLogging; this function serves as an alias for convenience or readability.

        .EXAMPLE
        Get-ADDiagnosticConfiguration -InstanceType "DomainController" -LoggingLevels "LDAP Interface", "Security" -ComputerName "DC01"
        Retrieves the diagnostic logging levels for the LDAP Interface and Security categories on the Domain Controller named DC01.

        .EXAMPLE
        Get-ADDiagnosticConfiguration -InstanceType "LDS" -LoggingLevels "Replication", "Security" -LDSInstanceName "ADAM_Instance1" -ComputerName "Server01"
        Retrieves the diagnostic logging levels for the Replication and Security categories on the LDS instance named ADAM_Instance1 on Server01.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("DomainController", "LDS")]
        [string]$InstanceType,

        [Parameter(Mandatory = $true)]
        [string[]]$LoggingLevels,

        [Parameter(Mandatory = $false)]
        [string]$LDSInstanceName,

        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    Get-ADDiagnosticLogging @PSBoundParameters
}
