<#
    .SYNOPSIS
    Gives a list of all Restorable Users from the AD Recycle Bin.

    .EXAMPLE
    Get-ADDeletedUsers -domainprefix example -domainsuffix local
#>

Function Get-ADDeletedUsers {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string]$domainprefix,
        [Parameter(Mandatory = $True)]
        [string]$domainsuffix
    )
    Get-ADObject -SearchBase "CN=deleted objects,dc=$domainprefix,dc=$domainsuffix" -IncludeDeletedObjects -filter * -Properties * |
    Where-Object { $_.ObjectClass -ne 'container' -and $_.ObjectClass -eq 'user' }
}
