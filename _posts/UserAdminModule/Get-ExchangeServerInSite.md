---
layout: post
title: Get-ExchangeServerInSite.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ExchangeServerInSite/
categories:
  - UserAdminModule
  - Exchange
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

Retrieves Exchange servers within the current Active Directory site.

#### Detailed Description

The Get-ExchangeServerInSite function retrieves Exchange servers within the current Active Directory site. It uses the LDAP protocol to search for servers that match the specified criteria.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ExchangeServerInSite
```

This example retrieves all Exchange servers within the current Active Directory site and displays their names, FQDNs, and roles.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the Active Directory module to be installed.

- The user running this function must have appropriate permissions to query Active Directory.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-ExchangeServerInSite.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ExchangeServerInSite.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

