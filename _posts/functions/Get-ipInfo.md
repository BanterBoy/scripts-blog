---
layout: post
title: Get-ipInfo.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
    .SYNOPSIS
    This CmdLet can be used to extract the IP Geo-location using the API from https://ipinfo.io
    A Free account required)
    https://ipinfo.io/developers

    .DESCRIPTION

    .EXAMPLE
    .\CmdLets\Get-ipInfo.ps1 -ApiKey YourApiKeyGoesHere -ipAddress 8.8.8.8

    This example will provide geo-ip location details for 8.8.8.8

    city     : Mountain View
    postal   : 94035
    region   : California
    hostname : google-public-dns-a.google.com
    ip       : 8.8.8.8
    loc      : 37.3860,-122.0840
    country  : US


    .INPUTS
    System.String

    You can pipe command names to this cmdlet.

    .OUTPUTS
    Free Account Response
    The free account provides you with the following output but does not include the additional details from the Full Response

    {
        "ip": "66.87.125.72",
        "hostname": "66-87-125-72.pools.spcsdns.net",
        "city": "Southbridge",
        "region": "Massachusetts",
        "country": "US",
        "loc": "42.0707,-72.0440",
        "postal": "01550"
    }

    Full Response (Standard and Pro Account required)
    Here's the full API responses for an example IP address, including the asn object that's included in the standard plan, and the company and carrier objects that are included in the pro plan. If you're on the free or basic plan these additional objects won't be included in the response.

    Full Response (covers Standard and Pro Plans)
    {
        "ip": "66.87.125.72",
        "hostname": "66-87-125-72.pools.spcsdns.net",
        "city": "Southbridge",
        "region": "Massachusetts",
        "country": "US",
        "loc": "42.0707,-72.0440",
        "postal": "01550",
        "asn": { <--- Available in Standard and Pro Plan
            "asn": "AS10507",
            "name": "Sprint Personal Communications Systems",
            "domain": "spcsdns.net",
            "route": "66.87.125.0/24",
            "type": "isp"
        },
        "company": { <--- Only available in Pro Plan
            "name": "Sprint Springfield POP",
            "domain": "sprint.com",
            "type": "isp"
        },
        "carrier": { <--- Only available in Pro Plan
            "name": "Sprint",
            "mcc": "310",
            "mnc": "120"
        }
    }


    .NOTES


    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $false,
        HelpMessage = "Please enter your API Key",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('ak')]
    [string[]]$ApiKey,

    [Parameter(Mandatory = $false,
        HelpMessage = "Please enter the IP address you would like to check",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('ip')]
    [string[]]$ipAddress

)

BEGIN {
    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SiteURL = "https://ipinfo.io/"
    $AccessKey = ("?token=" + "$ApiKey")
    $ipLocation = Invoke-RestMethod -Method Get -Uri ( $SiteURL + $ipAddress + $AccessKey )
}

PROCESS {

    foreach ($item in $ipLocation) {
        $ipCheck = $item | Select-Object -Property *

        try {
            $properties = @{
                ip       = $ipCheck.ip
                hostname = $ipCheck.hostname
                city     = $ipCheck.city
                region   = $ipCheck.region
                country  = $ipCheck.country
                loc      = $ipCheck.loc
                postal   = $ipCheck.postal
            }
        }
        catch {
            $properties = @{
                ip       = $ipCheck.ip
                hostname = $ipCheck.hostname
                city     = $ipCheck.city
                region   = $ipCheck.region
                country  = $ipCheck.country
                loc      = $ipCheck.loc
                postal   = $ipCheck.postal
            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

}

END {}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/ip/Get-ipInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ipInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
