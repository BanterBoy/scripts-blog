function Replicate-AllDomainControllers {
	(Get-ADDomainController -Filter *).Name |
	Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A |
	Out-Null}; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain |
	Select-Object Server, LastReplicationSuccess
}

