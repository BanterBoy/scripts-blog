---
layout: post
title: Get-MullvadApiDetails.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-MullvadApiDetails/
categories:
  - UserAdminModule
  - Network
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

Queries Mullvad’s public status API.

#### Detailed Description

Get-MullvadApiDetails sends a GET request to https://am.i.mullvad.net/<Endpoint> and returns: • connected – a user-friendly status message (e.g. “You are not connected to Mullvad. Your IP address is …”) • ip        – your current public IP address as a string • city      – the city of the exit node • country   – the country of the exit node • json      – a PSCustomObject with all fields (ip, country, city, longitude, latitude, mullvad_exit_ip, blacklisted, results, organization)

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS> Get-MullvadApiDetails -Endpoint connected
```

You are not connected to Mullvad. Your IP address is 77.99.103.120

**Example 2**

```powershell
PS> Get-MullvadApiDetails -Endpoint ip
```

77.99.103.120

**Example 3**

```powershell
PS> Get-MullvadApiDetails -Endpoint city
```

Southend-on-Sea

**Example 4**

```powershell
PS> Get-MullvadApiDetails -Endpoint country
```

United Kingdom

**Example 5**

```powershell
PS> Get-MullvadApiDetails -Endpoint json | Format-List *
```

ip              : 77.99.103.120 country         : United Kingdom city            : Southend-on-Sea longitude       : 0.7101 latitude        : 51.5323 mullvad_exit_ip : False blacklisted     : False results         : {} organization    : Virgin Media

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Queries Mullvad’s public status API.

.DESCRIPTION
Get-MullvadApiDetails sends a GET request to https://am.i.mullvad.net/<Endpoint> and returns:
  • connected – a user-friendly status message (e.g. “You are not connected to Mullvad. Your IP address is …”)  
  • ip        – your current public IP address as a string  
  • city      – the city of the exit node  
  • country   – the country of the exit node  
  • json      – a PSCustomObject with all fields (ip, country, city, longitude, latitude, mullvad_exit_ip, blacklisted, results, organization)

.PARAMETER Endpoint
The API resource to query. Valid values: connected, ip, city, country, json.

.OUTPUTS
If Endpoint is 'json', returns a PSCustomObject with:
  ip              [string]
  country         [string]
  city            [string]
  longitude       [double]
  latitude        [double]
  mullvad_exit_ip [bool]
  blacklisted     [bool]
  results         [object[]]
  organization    [string]
Otherwise returns a simple string.

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint connected
You are not connected to Mullvad. Your IP address is 77.99.103.120

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint ip
77.99.103.120

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint city
Southend-on-Sea

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint country
United Kingdom

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint json | Format-List *
ip              : 77.99.103.120
country         : United Kingdom
city            : Southend-on-Sea
longitude       : 0.7101
latitude        : 51.5323
mullvad_exit_ip : False
blacklisted     : False
results         : {}
organization    : Virgin Media
#>

function Get-MullvadApiDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('connected', 'ip', 'city', 'country', 'json')]
        [string]$Endpoint
    )

    $url = "https://am.i.mullvad.net/$Endpoint"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        if ($Endpoint -eq 'json') {
            $jsonResponse = $response.Content | ConvertFrom-Json

            # build a PSCustomObject so 'results' comes back as a real array
            return [PSCustomObject]@{
                ip              = $jsonResponse.ip
                country         = $jsonResponse.country
                city            = $jsonResponse.city
                longitude       = $jsonResponse.longitude
                latitude        = $jsonResponse.latitude
                mullvad_exit_ip = $jsonResponse.mullvad_exit_ip
                blacklisted     = $jsonResponse.blacklisted.blacklisted
                results         = $jsonResponse.blacklisted.results
                organization    = $jsonResponse.organization
            }
        }
        else {
            return $response.Content
        }
    }
    catch {
        Write-Error "Failed to retrieve data from Mullvad API: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-MullvadApiDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MullvadApiDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

