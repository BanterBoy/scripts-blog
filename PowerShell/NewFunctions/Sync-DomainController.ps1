function Sync-DomainController {

    <#
    .SYNOPSIS
        Synchronizes all domain controllers in the specified domain.

    .DESCRIPTION
        This function synchronizes all domain controllers in the specified domain by forcing replication using the repadmin tool.

    .PARAMETER Domain
        The name of the domain to synchronize. Defaults to the user's domain.

    .EXAMPLE
        Sync-DomainController -Domain "contoso.com"

    .NOTES
        Author: Unknown
        Last Edit: Unknown
        Version: 1.0
        Keywords: Active Directory, Domain Controller, Replication
    #>

    [CmdletBinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN
    )
    $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
    (Get-ADDomainController -Filter * -Server $Domain).Name | ForEach-Object {
        Write-Verbose -Message "Sync-DomainController - Forcing synchronization $_"
        repadmin /syncall $_ $DistinguishedName /e /A | Out-Null
    }
}
