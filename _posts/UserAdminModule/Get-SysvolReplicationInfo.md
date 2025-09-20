---
layout: post
title: Get-SysvolReplicationInfo.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-SysvolReplicationInfo/
categories:
- UserAdminModule
- Replication
tags:
- PowerShell
- User Admin Module
- Sysvol Replication Info
description: Retrieves information about the SYSVOL replication mechanism for each
  domain controller.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Retrieves information about the SYSVOL replication mechanism for each domain controller.

#### Detailed Description

The Get-SysvolReplicationInfo function retrieves information about the SYSVOL replication mechanism used in each domain controller in the current domain. It checks if the replication mechanism is DFSR (Distributed File System Replication) or FRS (File Replication Service) and returns the corresponding replication path along with the domain controller's hostname.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-SysvolReplicationInfo
```

This example retrieves the SYSVOL replication information for each domain controller in the current domain.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the Active Directory module to be installed.

- The user running this function must have appropriate permissions to query Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Replication/Public/Get-SysvolReplicationInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-SysvolReplicationInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

