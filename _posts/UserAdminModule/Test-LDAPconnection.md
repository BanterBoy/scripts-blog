---
layout: post
title: Test-LDAPconnection.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-LDAPconnection/
categories:
  - UserAdminModule
  - Testing
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Test-LDAPConnection {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DomainName,
        
        [string]$ComputerName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("LDAP", "LDAPS", "Both")]
        [string]$Protocol
    )

    $searchBase = "DC=" + $DomainName.Replace('.', ',DC=')
    $searchFilter = "(objectClass=user)"
    
    function Test-LDAP {
        param (
            [string]$hostname,
            [bool]$useSSL
        )

        $protocolType = if ($useSSL) { "LDAPS" } else { "LDAP" }
        $port = if ($useSSL) { 636 } else { 389 }
        $result = [PSCustomObject]@{
            Hostname    = $hostname
            Protocol    = $protocolType
            Port        = $port
            Status      = "Unknown"
            Message     = ""
        }

        try {
            Write-Verbose "Attempting to connect to $hostname on port $port using $protocolType..."

            $ldapConnection = New-Object System.DirectoryServices.Protocols.LdapConnection($hostname)
            $ldapConnection.SessionOptions.SecureSocketLayer = $useSSL
            $ldapConnection.SessionOptions.ProtocolVersion = 3

            $ldapConnection.Bind()
            Write-Verbose "Successfully connected to $hostname on port $port using $protocolType."

            $searchRequest = New-Object System.DirectoryServices.Protocols.SearchRequest(
                $searchBase, 
                $searchFilter, 
                [System.DirectoryServices.Protocols.SearchScope]::Subtree, 
                $null
            )

            $searchResponse = $ldapConnection.SendRequest($searchRequest)

            if ($searchResponse.Entries.Count -gt 0) {
                $result.Status = "Success"
                $result.Message = "$protocolType is working on $hostname"
            } else {
                $result.Status = "Fail"
                $result.Message = "$protocolType is NOT working on $hostname"
            }

            $ldapConnection.Dispose()
        } catch {
            $result.Status = "Error"
            $result.Message = "Error testing $protocolType on {$hostname}: $_"
        }

        return $result
    }

    if (-not $ComputerName) {
        $domainControllers = Get-ADDomainController -Filter *
    } else {
        $domainControllers = @(Get-ADDomainController -Identity $ComputerName)
    }

    $results = @()

    foreach ($dc in $domainControllers) {
        $hostname = $dc.HostName
        
        if ($Protocol -eq "LDAP" -or $Protocol -eq "Both") {
            $results += Test-LDAP -hostname $hostname -useSSL $false
        }

        if ($Protocol -eq "LDAPS" -or $Protocol -eq "Both") {
            $results += Test-LDAP -hostname $hostname -useSSL $true
        }
    }

    return $results
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-LDAPconnection.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-LDAPconnection.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

