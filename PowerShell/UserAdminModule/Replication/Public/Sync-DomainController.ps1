function Sync-DomainController {
<#
.SYNOPSIS
Forces Active Directory replication for all domain controllers in a specified domain.

.DESCRIPTION
This function uses repadmin to force synchronization of all domain controllers in the given domain. It displays a progress bar and provides error handling for each controller.

.PARAMETER Domain
The Active Directory domain to target for replication. Defaults to the current user's domain.

.PARAMETER Controller
Optionally specify one or more domain controller names to sync. If not provided, all DCs in the domain are synced.

.EXAMPLE
Sync-DomainController -Domain "contoso.com"

.EXAMPLE
Sync-DomainController -Controller "DC01","DC02"

.NOTES
Requires Active Directory PowerShell module and repadmin.exe.
#>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string] $Domain = $Env:USERDNSDOMAIN,

        [Parameter(Position=1, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Controller
    )
    try {
        $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
        if ($Controller) {
            $DCs = foreach ($Name in $Controller) { Get-ADDomainController -Identity $Name -Server $Domain }
        } else {
            $DCs = Get-ADDomainController -Filter * -Server $Domain
        }
        $Total = $DCs.Count
        $i = 0
        foreach ($DC in $DCs) {
            $i++
            Write-Progress -Activity "Synchronizing Domain Controllers" -Status "Syncing $($DC.Name) ($i of $Total)" -PercentComplete (($i / $Total) * 100)
            Write-Verbose -Message "Sync-DomainController - Forcing synchronization $($DC.Name)"
            try {
                repadmin /syncall $DC.Name $DistinguishedName /e /A | Out-Null
            } catch {
                Write-Error "Failed to sync $($DC.Name): $_"
            }
        }
        Write-Progress -Activity "Synchronizing Domain Controllers" -Completed
    } catch {
        Write-Error "Sync-DomainController failed: $_"
    }
}
