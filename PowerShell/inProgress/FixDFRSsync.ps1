Sync-DomainController -Domain "$env:userdnsdomain" -Verbose

Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationAttempt, LastReplicationSuccess | Sort-Object LastReplicationSuccess

$DomConts = "DC01", "DC02", "DC05", "DC06", "DC07", "DC08"
foreach ( $DC in $DomConts ) {
    Invoke-Command -ComputerName $DC -ScriptBlock {
        DFSRDIAG POLLAD
        Get-Service -Name DFS* | Stop-Service
    }
}

foreach ( $DC in $DomConts ) { Invoke-Command -ComputerName $DC -ScriptBlock { Get-Service -Name DFS* | Stop-Service } }

foreach ( $DC in $DomConts ) { Invoke-Command -ComputerName $DC -ScriptBlock { Get-Service -Name DFS* | Start-Service } }

foreach ( $DC in $DomConts ) { Invoke-Command -ComputerName $DC -ScriptBlock { DFSRDIAG POLLAD } }

foreach ( $DC in $DomConts ) { Invoke-Command -ComputerName $DC -ScriptBlock { auditpol /get /category:* } }

Enter-PSSession -ComputerName DC02 -Credential (Get-Credential)

