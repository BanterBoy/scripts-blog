function Get-ADDiagnosticConfiguration {
    <#
        .SYNOPSIS
        Retrieves Active Directory diagnostic logging levels for the specified instance.

        .DESCRIPTION
        Wrapper around Get-ADDiagnosticLogging so that the configuration information can be requested using
        either function name. All parameters mirror Get-ADDiagnosticLogging and the underlying function handles
        the data retrieval.
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
