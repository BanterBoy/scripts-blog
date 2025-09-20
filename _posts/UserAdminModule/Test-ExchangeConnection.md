---
layout: post
title: Test-ExchangeConnection.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-ExchangeConnection/
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
function Test-ExchangeConnection {
    $sessions = Get-PSSession
    $connections = Get-ConnectionInformation
    $result = @()

    foreach ($session in $sessions) {
        if ($session.State -eq 'Opened') {
            $sessionDetails = New-Object PSObject -Property @{
                SessionName            = $session.Name
                ComputerName           = $session.ComputerName
                ConfigurationName      = $session.ConfigurationName
                SessionState           = "Established"
                ApplicationPrivateData = $session.ApplicationPrivateData
                Availability           = $session.Availability
                ComputerType           = $session.ComputerType
                ContainerId            = $session.ContainerId
                InstanceId             = $session.InstanceId
                Runspace               = $session.Runspace
                Transport              = $session.Transport
                VMId                   = $session.VMId
                VMName                 = $session.VMName
                DisconnectedOn         = $session.DisconnectedOn
                ExpiresOn              = $session.ExpiresOn
                IdleTimeout            = $session.IdleTimeout
                OutputBufferingMode    = $session.OutputBufferingMode
            }
            $result += $sessionDetails
        }
        else {
            $sessionDetails = New-Object PSObject -Property @{
                SessionName  = $session.Name
                SessionState = "Not Established"
            }
            $result += $sessionDetails
        }
    }

    foreach ($connection in $connections) {
        if ($connection.State -eq 'Connected') {
            $connectionDetails = New-Object PSObject -Property @{
                ConnectionId                    = $connection.ConnectionId
                ConnectionState                 = "Connected"
                ConnectionName                  = $connection.Name
                UserPrincipalName               = $connection.UserPrincipalName
                ConnectionUri                   = $connection.ConnectionUri
                AzureAdAuthorizationEndpointUri = $connection.AzureAdAuthorizationEndpointUri
                TokenExpiryTimeUTC              = $connection.TokenExpiryTimeUTC
                CertificateAuthentication       = $connection.CertificateAuthentication
                ModuleName                      = $connection.ModuleName
                ModulePrefix                    = $connection.ModulePrefix
                Organization                    = $connection.Organization
                DelegatedOrganization           = $connection.DelegatedOrganization
                AppId                           = $connection.AppId
                PageSize                        = $connection.PageSize
                TenantID                        = $connection.TenantID
                TokenStatus                     = $connection.TokenStatus
                ConnectionUsedForInbuiltCmdlets = $connection.ConnectionUsedForInbuiltCmdlets
                IsEopSession                    = $connection.IsEopSession
            }
            $result += $connectionDetails
        }
        else {
            $connectionDetails = New-Object PSObject -Property @{
                ConnectionName  = $connection.Name
                ConnectionState = "Not Connected"
            }
            $result += $connectionDetails
        }
    }

    return $result
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-ExchangeConnection.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ExchangeConnection.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

