---
layout: post
title: Get-DBInstances.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/database/get-dbinstances/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Retrieves the SQL Server instances available on a specified computer.

#### Detailed Description

The Get-DBInstances function retrieves the SQL Server instances available on a specified computer. It first checks if the computer is part of a failover cluster and if so, it uses the FailoverClusters module to get the SQL Server instances from the cluster. If the computer is not part of a cluster, it retrieves the instances from the local registry.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DBInstances -ComputerName "Server01"
```

Retrieves the SQL Server instances available on the computer named "Server01".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
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
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Database/Public/Get-DBInstances.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DBInstances.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

