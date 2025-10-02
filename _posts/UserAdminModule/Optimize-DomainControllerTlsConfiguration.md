---
layout: post
title: Optimize-DomainControllerTlsConfiguration.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/optimize-domaincontrollertlsconfiguration/
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

This function creates a new Group Policy Object (GPO). The policy disables TLS 1.0 and 1.1 on all domain controllers where the GPO is applied. Optionally, the function can link the new GPO to the Domain Controllers OU and update the TLS cipher suites to only allow secure ciphers.

#### Detailed Description

When an Active Directory domain controller has a valid TLS certificate installed, TLS can be used for encrypted LDAP communcation (LDAPS). By default, domain controllers support TLS 1.0, 1.1, and 1.2. However, it is recommended to disable TLS 1.0 and 1.1 to improve security. This function creates a new Group Policy Object (GPO) in Active Directory and optionally links it to the Domain Controllers OU. The policy disables TLS 1.0 and 1.1 on all domain controllers to improve security. In addition, the function can update the TLS cipher suites to only allow secure ciphers to further improve security. Be sure to perform thorough testing before applying this policy in a production environment, as it may impact legacy applications that rely on older TLS versions.

IMPORTANT NOTE: When updating TLS cipher suites, this function assumes all domain controllers are running the same version of Windows Server. If domain controllers are running different versions of Windows Server, create separate GPOs for each server version and use WMI filtering to ensure the correct GPO is applied to each domain controller. In addition, domain controllers must be restarted for TLS cipher suite changes to take effect.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Optimize-DomainControllerTlsConfiguration
```

This example creates a new GPO with the default name 'Domain Controllers LDAPS Security Configuration'. The GPO disables TLS 1.0 and 1.1 on all domain controllers where the GPO is applied.

**Example 2**

```powershell
Optimize-DomainControllerTlsConfiguration -GpoName 'Enterprise Domain Controller TLS Optimization' -Link -UpdateCiphers
```

This example creates a new GPO named 'Enterprise Domain Controller TLS Optimization', links it to the Domain Controllers OU in Active Directory, and updates the TLS cipher suites to only allow secure ciphers.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.1 Creation Date:  March 20, 2024 Last Updated:   March 24, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    This function creates a new Group Policy Object (GPO). The policy disables TLS 1.0 and 1.1 on all domain controllers where the GPO is applied. Optionally, the function can link the new GPO to the Domain Controllers OU and update the TLS cipher suites to only allow secure ciphers.

.PARAMETER GpoName
    The name of the new GPO to create. The default value is 'Domain Controller LDAPS Security Configuration'.

.PARAMETER UpdateCiphers
    Indicates that the TLS cipher suites should be updated to only allow secure ciphers.

.PARAMETER Server
    Specifies the version of Windows Server that the domain controllers are running. Valid values are '2022', '2019', and '2016'. The default value is '2022'.

.PARAMETER Link
    Indicates that the new GPO should be linked to the Domain Controllers OU.

.EXAMPLE
    Optimize-DomainControllerTlsConfiguration

    This example creates a new GPO with the default name 'Domain Controllers LDAPS Security Configuration'. The GPO disables TLS 1.0 and 1.1 on all domain controllers where the GPO is applied.

.EXAMPLE
    Optimize-DomainControllerTlsConfiguration -GpoName 'Enterprise Domain Controller TLS Optimization' -Link -UpdateCiphers

    This example creates a new GPO named 'Enterprise Domain Controller TLS Optimization', links it to the Domain Controllers OU in Active Directory, and updates the TLS cipher suites to only allow secure ciphers.

.DESCRIPTION
    When an Active Directory domain controller has a valid TLS certificate installed, TLS can be used for encrypted LDAP communcation (LDAPS). By default, domain controllers support TLS 1.0, 1.1, and 1.2. However, it is recommended to disable TLS 1.0 and 1.1 to improve security. This function creates a new Group Policy Object (GPO) in Active Directory and optionally links it to the Domain Controllers OU. The policy disables TLS 1.0 and 1.1 on all domain controllers to improve security. In addition, the function can update the TLS cipher suites to only allow secure ciphers to further improve security. Be sure to perform thorough testing before applying this policy in a production environment, as it may impact legacy applications that rely on older TLS versions.

    IMPORTANT NOTE: When updating TLS cipher suites, this function assumes all domain controllers are running the same version of Windows Server. If domain controllers are running different versions of Windows Server, create separate GPOs for each server version and use WMI filtering to ensure the correct GPO is applied to each domain controller. In addition, domain controllers must be restarted for TLS cipher suite changes to take effect.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Optimize-DomainControllerTlsConfiguration.ps1

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.1
    Creation Date:  March 20, 2024
    Last Updated:   March 24, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Optimize-DomainControllerTlsConfiguration {

    [CmdletBinding()]

    Param (

        [ValidateNotNullOrEmpty()]
        [string]$GpoName = 'Domain Controller LDAPS Security Configuration',
        [switch]$UpdateCiphers,
        [Parameter(Mandatory, HelpMessage = 'Specify the version of Windows Server that the domain controllers are running.')]
        [ValidateSet('2022', '2019', '2016')]
        [string]$Server = '2022',
        [switch]$Link

    )

    # Check for existing GPO
    Write-Verbose "Checking for existing GPO named `'$GpoName`'..."
    $GpoExists = Get-Gpo -Name $GpoName -ErrorAction SilentlyContinue
    If ($GpoExists) {

        Write-Warning "A GPO named `'$GpoName`' already exists. Please specify a different name for the new GPO."
        Return

    }

    # Create new GPO in Active Directory
    Write-Verbose "Creating a new GPO named `'$GpoName`'..."
    New-Gpo -Name $GpoName -Comment 'This GPO disables TLS 1.1 and 1.0 on Domain Controllers' | Out-Null

    # Disable TLS 1.0
    Write-Verbose 'Disabling TLS 1.0...'

    $GpoParams = @{

        Name      = $GpoName
        Key       = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
        ValueName = 'Enabled'
        Value     = 0
        Type      = 'DWORD'

    }

    Set-GpRegistryValue @GpoParams | Out-Null

    # Disable TLS 1.1
    Write-Verbose 'Disabling TLS 1.1...'

    $GpoParams = @{

        Name      = $GpoName
        Key       = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'
        ValueName = 'Enabled'
        Value     = 0
        Type      = 'DWORD'

    }

    Set-GpRegistryValue @GpoParams | Out-Null

    # Ensure TLS 1.2 is enabled (should be enabled by default)
    Write-Verbose 'Enabling TLS 1.2...'

    $GpoParams = @{

        Name      = $GpoName
        Key       = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'
        ValueName = 'Enabled'
        Value     = 1
        Type      = 'DWORD'

    }

    Set-GpRegistryValue @GpoParams | Out-Null

    $GpoParams = @{

        Name      = $GpoName
        Key       = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'
        ValueName = 'DisabledByDefault'
        Value     = 0
        Type      = 'DWORD'

    }

    Set-GpRegistryValue @GpoParams | Out-Null

    If ($UpdateCiphers) {

        # Update TLS cipher suites
        Switch -Regex ($Server) {

            '2022|2019' { $Ciphers = 'TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256' }
            '2016' { $Ciphers = 'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256' }

        }

        $GpoParams = @{

            Name      = $GpoName
            Key       = 'HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002\'
            ValueName = 'Functions'
            Type      = 'String'
            Value     = $Ciphers

        }

        Set-GpRegistryValue @GpoParams
        Write-Warning "TLS cipher suites have been updated to only allow secure ciphers. Ensure all domain controllers with this GPO applied are running Windows Server $Server."
        Write-Warning 'Domain controllers must be restarted for TLS cipher suite changes to take effect.'

    }

    If ($Link) {

        # Link the new GPO to the Domain Controllers OU
        Write-Verbose 'Linking the OU to the Domain Controllers OU...'
        $Ou = Get-ADOrganizationalUnit -Filter 'Name -eq "Domain Controllers"'
        New-GPLink -Name $GpoName -Target $Ou | Out-Null

    }

    Write-Warning 'The NTDS service must be restarted on all domain controllers for this policy to take effect.'

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Optimize-DomainControllerTlsConfiguration.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Optimize-DomainControllerTlsConfiguration.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

