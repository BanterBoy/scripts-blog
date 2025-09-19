<#
.SYNOPSIS
Retrieves the SQL Server instances available on a specified computer.

.DESCRIPTION
The Get-DBInstances function retrieves the SQL Server instances available on a specified computer. It first checks if the computer is part of a failover cluster and if so, it uses the FailoverClusters module to get the SQL Server instances from the cluster. If the computer is not part of a cluster, it retrieves the instances from the local registry.

.PARAMETER ComputerName
The name of the computer on which to retrieve the SQL Server instances.

.EXAMPLE
Get-DBInstances -ComputerName "Server01"
Retrieves the SQL Server instances available on the computer named "Server01".

.NOTES
Author: Your Name
Date:   Current Date
#>

function Get-DBInstances {
    Param(
        [Parameter(Mandatory = $true)]
        $ComputerName
    )

    if ($null -ne (Get-CimInstance -ClassName MSCluster_ResourceGroup -ComputerName $ComputerName -Namespace root\mscluster -ErrorAction SilentlyContinue)) {  
        Import-Module FailoverClusters
        Get-ClusterResource -Cluster $ComputerName  -ErrorAction SilentlyContinue |
        Where-Object { $_.ResourceType -like "SQL Server" } | 
        Get-ClusterParameter VirtualServerName, InstanceName | group-object ClusterObject | 
        Select-Object @{Name = "SQLInstance"; Expression = { [string]::join("\", ($_.Group | Select-Object -ExpandProperty Value)) } } 
    } 
    else {
        $SQLInstances = Invoke-Command -ComputerName $ComputerName {
            (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
        }
        foreach ($sql in $SQLInstances) {
            [PSCustomObject]@{
                ServerName   = $sql.PSComputerName
                InstanceName = $sql
            }
        }  
    }
}