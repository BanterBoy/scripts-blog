---
layout: post
title: Get-ADDiagnosticLogging.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-addiagnosticlogging/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-ADDiagnosticLogging {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("DomainController", "LDS")]
        [string]$InstanceType,

        [Parameter(Mandatory = $true)]
        [string[]]$LoggingLevels,

        [Parameter(Mandatory = $false)]
        [string]$LDSInstanceName,

        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    $scriptBlock = {
        param (
            $InstanceType,
            $LoggingLevels,
            $LDSInstanceName
        )

        $basePath = "HKLM:\SYSTEM\CurrentControlSet\Services"
        $diagnosticsPath = if ($InstanceType -eq "DomainController") {
            "$basePath\NTDS\Diagnostics"
        } elseif ($InstanceType -eq "LDS" -and $LDSInstanceName) {
            "$basePath\$LDSInstanceName\Diagnostics"
        } else {
            throw "LDS instance name is required for LDS instance type."
        }

        $loggings = @{
            "Knowledge Consistency Checker (KCC)" = 1
            "Security Events" = 2
            "ExDS Interface Events" = 3
            "MAPI Interface Events" = 4
            "Replication Events" = 5
            "Garbage Collection" = 6
            "Internal Configuration" = 7
            "Directory Access" = 8
            "Internal Processing" = 9
            "Performance Counters" = 10
            "Initialization/Termination" = 11
            "Service Control" = 12
            "Name Resolution" = 13
            "Backup" = 14
            "Field Engineering" = 15
            "LDAP Interface Events" = 16
            "Setup" = 17
            "Global Catalog" = 18
            "Inter-site Messaging" = 19
            "Group Caching" = 20
            "Linked-Value Replication" = 21
            "DS RPC Client" = 22
            "DS RPC Server" = 23
            "DS Schema" = 24
            "Transformation Engine" = 25
            "Claims-Based Access Control" = 26
            "PDC Password Update Notifications" = 27
        }

        $results = @()

        foreach ($LoggingLevel in $LoggingLevels) {
            if ($loggings.ContainsKey($LoggingLevel)) {
                $registryKey = $loggings[$LoggingLevel]
                $value = Get-ItemProperty -Path $diagnosticsPath -Name "$registryKey $LoggingLevel" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "$registryKey $LoggingLevel" -ErrorAction SilentlyContinue
                if ($null -eq $value) {
                    $value = 0
                }
                $results += [PSCustomObject]@{
                    LoggingLevel = $LoggingLevel
                    Level = $value
                }
            } else {
                throw "Invalid logging level specified: $LoggingLevel."
            }
        }

        return $results
    }

    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $InstanceType, $LoggingLevels, $LDSInstanceName
}

# Example usage:
# $InstanceType = "DomainController"
# $ComputerName = Get-AllDomainControllers | Select-Object -First 1 -ExpandProperty Name
# $LoggingLevels = @(
#     "Knowledge Consistency Checker (KCC)",
#     "Security Events",
#     "ExDS Interface Events",
#     "MAPI Interface Events",
#     "Replication Events",
#     "Garbage Collection",
#     "Internal Configuration",
#     "Directory Access",
#     "Internal Processing",
#     "Performance Counters",
#     "Initialization/Termination",
#     "Service Control",
#     "Name Resolution",
#     "Backup",
#     "Field Engineering",
#     "LDAP Interface Events",
#     "Setup",
#     "Global Catalog",
#     "Inter-site Messaging",
#     "Group Caching",
#     "Linked-Value Replication",
#     "DS RPC Client",
#     "DS RPC Server",
#     "DS Schema",
#     "Transformation Engine",
#     "Claims-Based Access Control",
#     "PDC Password Update Notifications"
# )
# $ComputerName |ForEach-Object -Process { Get-ADDiagnosticLogging -InstanceType $InstanceType -LoggingLevels $LoggingLevels -ComputerName $_ }
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADDiagnosticLogging.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADDiagnosticLogging.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

