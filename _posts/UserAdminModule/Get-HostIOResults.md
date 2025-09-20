---
layout: post
title: Get-HostIOResults.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-HostIOResults/
categories:
- UserAdminModule
- Network
tags:
- PowerShell
- User Admin Module
- Host IO Results
- IO
description: Retrieves host I/O results for a given domain name using the host.io
  API.
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

Retrieves host I/O results for a given domain name using the host.io API.

#### Detailed Description

The Get-HostIOResults function retrieves host I/O results for a given domain name using the host.io API. It makes a GET request to the host.io API and returns the results as a PowerShell object.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-HostIOResults -domainName "example.com" -apiKey "YOUR_API_KEY"
```

Retrieves host I/O results for the domain "example.com" using the specified API key.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires an active internet connection to access the host.io API.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves host I/O results for a given domain name using the host.io API.

.DESCRIPTION
    The Get-HostIOResults function retrieves host I/O results for a given domain name using the host.io API. It makes a GET request to the host.io API and returns the results as a PowerShell object.

.PARAMETER domainName
    Specifies the domain name for which to retrieve host I/O results.

.PARAMETER apiKey
    Specifies the API key to authenticate the request to the host.io API.

.EXAMPLE
    Get-HostIOResults -domainName "example.com" -apiKey "YOUR_API_KEY"

    Retrieves host I/O results for the domain "example.com" using the specified API key.

.NOTES
    This function requires an active internet connection to access the host.io API.
#>
function Get-HostIOResults {
    [CmdletBinding()]

    param (
        [Parameter()]
        [string[]]
        $domainName,

        [Parameter()]
        [string[]]
        $apiKey
    )
        
    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $siteURL = "https://host.io/api/full/"
        $accessKey = ("?token=" + "$ApiKey")
        $fullresults = Invoke-RestMethod -Method Get -Uri ($siteURL + $domainName + $accessKey)
    }
    
    process {
        try {
            foreach ($result in $fullresults) {
                $properties = @{
                    "Domain"       = $fullresults.domain
                    "WEB"          = $fullresults.web
                    "DomainRecord" = $fullresults.dns.domain
                    "ARecord"      = $fullresults.dns.a
                    "AAAADomain"   = $fullresults.dns.aaaa
                    "MXDomain"     = $fullresults.dns.mx
                    "NSDomain"     = $fullresults.dns.ns
                    
                }
            }
        }
        finally {
            $object = New-Object -TypeName PSObject -Property $properties
            Write-Output $object
        }
    }
    
    end {
        
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-HostIOResults.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-HostIOResults.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

