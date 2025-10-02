---
layout: post
title: Get-ADDiagnosticConfiguration.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-addiagnosticconfiguration/
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
<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Get-ADDiagnosticConfiguration {
    <#
        .SYNOPSIS
        Retrieves Active Directory diagnostic logging levels for the specified instance.

        .DESCRIPTION
        This function is a direct wrapper around Get-ADDiagnosticLogging. It allows you to retrieve diagnostic logging levels for a specified Domain Controller or LDS instance using the same parameters as Get-ADDiagnosticLogging. All parameters in this function map directly to those in Get-ADDiagnosticLogging:
        
        - InstanceType: Specifies the type of instance ("DomainController" or "LDS").
        - LoggingLevels: Specifies the diagnostic logging levels to retrieve.
        - LDSInstanceName: (Optional) Specifies the name of the LDS instance if InstanceType is "LDS".
        - ComputerName: Specifies the target computer.
        
        There are no additional features or differences from Get-ADDiagnosticLogging; this function serves as an alias for convenience or readability.

        .EXAMPLE
        Get-ADDiagnosticConfiguration -InstanceType "DomainController" -LoggingLevels "LDAP Interface", "Security" -ComputerName "DC01"
        Retrieves the diagnostic logging levels for the LDAP Interface and Security categories on the Domain Controller named DC01.

        .EXAMPLE
        Get-ADDiagnosticConfiguration -InstanceType "LDS" -LoggingLevels "Replication", "Security" -LDSInstanceName "ADAM_Instance1" -ComputerName "Server01"
        Retrieves the diagnostic logging levels for the Replication and Security categories on the LDS instance named ADAM_Instance1 on Server01.
    #>
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

    Get-ADDiagnosticLogging @PSBoundParameters
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADDiagnosticConfiguration.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADDiagnosticConfiguration.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

