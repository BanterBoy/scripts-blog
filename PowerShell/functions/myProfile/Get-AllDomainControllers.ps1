Function Get-AllDomainControllers {
    Get-ADDomainController -Filter * -Server (Get-ADDomain).DNSRoot | Select-Object Hostname,Site,OperatingSystem
}
