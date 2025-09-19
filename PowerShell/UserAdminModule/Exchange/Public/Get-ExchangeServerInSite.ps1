# https://raw.githubusercontent.com/mikepfeiffer/PowerShell/master/Get-ExchangeServerInSite.ps1

<#
.SYNOPSIS
Retrieves Exchange servers within the current Active Directory site.

.DESCRIPTION
The Get-ExchangeServerInSite function retrieves Exchange servers within the current Active Directory site. It uses the LDAP protocol to search for servers that match the specified criteria.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-ExchangeServerInSite

This example retrieves all Exchange servers within the current Active Directory site and displays their names, FQDNs, and roles.

.OUTPUTS
[System.Management.Automation.PSCustomObject]
The function outputs a custom object with the following properties:
- Name: The name of the Exchange server.
- FQDN: The fully qualified domain name (FQDN) of the Exchange server.
- Roles: The roles currently assigned to the Exchange server.

.NOTES
- This function requires the Active Directory module to be installed.
- The user running this function must have appropriate permissions to query Active Directory.

.LINK
https://raw.githubusercontent.com/mikepfeiffer/PowerShell/master/Get-ExchangeServerInSite.ps1
#>

function Get-ExchangeServerInSite {
    $ADSite = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]
    $siteDN = $ADSite::GetComputerSite().GetDirectoryEntry().distinguishedName
    $configNC = ([ADSI]"LDAP://RootDse").configurationNamingContext
    $search = New-Object DirectoryServices.DirectorySearcher([ADSI]"LDAP://$configNC")
    $objectClass = "objectClass=msExchExchangeServer"
    $version = "versionNumber>=1937801568"
    $site = "msExchServerSite=$siteDN"
    $search.Filter = "(&($objectClass)($version)($site))"
    $search.PageSize = 1000
    [void] $search.PropertiesToLoad.Add("name")
    [void] $search.PropertiesToLoad.Add("msexchcurrentserverroles")
    [void] $search.PropertiesToLoad.Add("networkaddress")
    $search.FindAll() | ForEach-Object -Process {
        New-Object PSObject -Property @{
            Name  = $_.Properties.name[0]
            FQDN  = $_.Properties.networkaddress |
            ForEach-Object -Process { if ($_ -match "ncacn_ip_tcp") { $_.split(":")[1] } }
            Roles = $_.Properties.msexchcurrentserverroles[0]
        }
    }
}
