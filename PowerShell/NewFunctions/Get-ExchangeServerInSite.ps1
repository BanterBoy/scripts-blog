# https://raw.githubusercontent.com/mikepfeiffer/PowerShell/master/Get-ExchangeServerInSite.ps1

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
            Name      = $_.Properties.name[0]
            FQDN      = $_.Properties.networkaddress |
            ForEach-Object -Process { if ($_ -match "ncacn_ip_tcp") { $_.split(":")[1] } }
            Roles     = $_.Properties.msexchcurrentserverroles[0]
            IPAddress = $_.Properties.networkaddress |
            ForEach-Object -Process { if ($_ -match "ncacn_ip_tcp") { $_.split(":")[1].split("/")[0] }
            }
        }
    }
}
