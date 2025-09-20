---
layout: post
title: Sync-DomainController.ps1
description: "Forces replication across domain controllers within a given domain."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Sync-DomainController/
categories:
  - UserAdminModule
  - Replication
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

Forces Active Directory replication for all domain controllers in a specified domain.

#### Detailed Description

This function uses repadmin to force synchronization of all domain controllers in the given domain. It displays a progress bar and provides error handling for each controller.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Sync-DomainController -Domain "contoso.com"
```

**Example 2**

```powershell
Sync-DomainController -Controller "DC01","DC02"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires Active Directory PowerShell module and repadmin.exe.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Sync-DomainController {
<#
.SYNOPSIS
Forces Active Directory replication for all domain controllers in a specified domain.

.DESCRIPTION
This function uses repadmin to force synchronization of all domain controllers in the given domain. It displays a progress bar and provides error handling for each controller.

.PARAMETER Domain
The Active Directory domain to target for replication. Defaults to the current user's domain.

.PARAMETER Controller
Optionally specify one or more domain controller names to sync. If not provided, all DCs in the domain are synced.

.EXAMPLE
Sync-DomainController -Domain "contoso.com"

.EXAMPLE
Sync-DomainController -Controller "DC01","DC02"

.NOTES
Requires Active Directory PowerShell module and repadmin.exe.
#>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string] $Domain = $Env:USERDNSDOMAIN,

        [Parameter(Position=1, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Controller
    )
    try {
        $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
        if ($Controller) {
            $DCs = foreach ($Name in $Controller) { Get-ADDomainController -Identity $Name -Server $Domain }
        } else {
            $DCs = Get-ADDomainController -Filter * -Server $Domain
        }
        $Total = $DCs.Count
        $i = 0
        foreach ($DC in $DCs) {
            $i++
            Write-Progress -Activity "Synchronizing Domain Controllers" -Status "Syncing $($DC.Name) ($i of $Total)" -PercentComplete (($i / $Total) * 100)
            Write-Verbose -Message "Sync-DomainController - Forcing synchronization $($DC.Name)"
            try {
                repadmin /syncall $DC.Name $DistinguishedName /e /A | Out-Null
            } catch {
                Write-Error "Failed to sync $($DC.Name): $_"
            }
        }
        Write-Progress -Activity "Synchronizing Domain Controllers" -Completed
    } catch {
        Write-Error "Sync-DomainController failed: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Replication/Public/Sync-DomainController.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Sync-DomainController.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

