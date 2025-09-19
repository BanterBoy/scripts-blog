<#
.SYNOPSIS
    Retrieves information about the SYSVOL replication mechanism for each domain controller.

.DESCRIPTION
    The Get-SysvolReplicationInfo function retrieves information about the SYSVOL replication mechanism used in each domain controller in the current domain. It checks if the replication mechanism is DFSR (Distributed File System Replication) or FRS (File Replication Service) and returns the corresponding replication path along with the domain controller's hostname.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Get-SysvolReplicationInfo

    This example retrieves the SYSVOL replication information for each domain controller in the current domain.

.OUTPUTS
    The function outputs a custom object with the following properties for each domain controller:
    - "Domain Controller": The hostname of the domain controller.
    - "SYSVOL Replication Mechanism": The replication mechanism used for SYSVOL (DFSR or FRS).
    - "Path": The replication path for SYSVOL.

.NOTES
    - This function requires the Active Directory module to be installed.
    - The user running this function must have appropriate permissions to query Active Directory.

.LINK
    https://github.com/your-repo/Get-SysvolReplicationInfo.ps1
#>

function Get-SysvolReplicationInfo {
    $domainControllers = (Get-ADDomainController -Filter *).hostname

    foreach ($currentDomain in $domainControllers) {
        $defaultNamingContext = (([ADSI]"LDAP://$currentDomain/rootDSE").defaultNamingContext)
        $searcher = New-Object DirectoryServices.DirectorySearcher
        $searcher.Filter = "(&(objectClass=computer)(dNSHostName=$currentDomain))"
        $searcher.SearchRoot = "LDAP://" + $currentDomain + "/OU=Domain Controllers," + $defaultNamingContext
        $dcObjectPath = $searcher.FindAll() | ForEach-Object { $_.Path }

        # DFSR
        $searchDFSR = New-Object DirectoryServices.DirectorySearcher
        $searchDFSR.Filter = "(&(objectClass=msDFSR-Subscription)(name=SYSVOL Subscription))"
        $searchDFSR.SearchRoot = $dcObjectPath
        $dfsrSubObject = $searchDFSR.FindAll()

        if ($null -ne $dfsrSubObject) {
            [pscustomobject]@{
                "Domain Controller"            = $currentDomain
                "SYSVOL Replication Mechanism" = "DFSR"
                "Path:"                        = $dfsrSubObject | ForEach-Object { $_.Properties."msdfsr-rootpath" }
            }
        }

        # FRS
        $searchFRS = New-Object DirectoryServices.DirectorySearcher
        $searchFRS.Filter = "(&(objectClass=nTFRSSubscriber)(name=Domain System Volume (SYSVOL share)))"
        $searchFRS.SearchRoot = $dcObjectPath
        $frsSubObject = $searchFRS.FindAll()

        if ($null -ne $frsSubObject) {
            [pscustomobject]@{
                "Domain Controller"            = $currentDomain
                "SYSVOL Replication Mechanism" = "FRS"
                "Path"                         = $frsSubObject | ForEach-Object { $_.Properties.frsrootpath }
            }
        }
    }
}