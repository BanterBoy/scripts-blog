---
layout: post
title: New-NTPRecord.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/new-ntprecord/
categories:
  - UserAdminModule
  - Utilities
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

Creates a new NTP (Network Time Protocol) record in a DNS zone.

#### Detailed Description

The New-NTPRecord function creates a new NTP record in a DNS zone on a specified DNS server. It takes a DNS server name, a record name, a domain name, and an array of IP addresses as input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -IPAddresses @("192.168.1.10", "192.168.1.11")
```

This example creates an NTP record with the name "ntp1" in the "example.com" domain on the "dns.example.com" DNS server. The record is associated with the IP addresses "192.168.1.10" and "192.168.1.11".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates a new NTP (Network Time Protocol) record in a DNS zone.

.DESCRIPTION
The New-NTPRecord function creates a new NTP record in a DNS zone on a specified DNS server. It takes a DNS server name, a record name, a domain name, and an array of IP addresses as input.

.PARAMETER DnsServer
The name of the DNS server where the record will be created.

.PARAMETER Name
The name of the NTP record to be created.

.PARAMETER Domain
The domain name where the record will be created.

.PARAMETER IPAddresses
An array of IP addresses associated with the NTP record.

.EXAMPLE
New-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -IPAddresses @("192.168.1.10", "192.168.1.11")

This example creates an NTP record with the name "ntp1" in the "example.com" domain on the "dns.example.com" DNS server. The record is associated with the IP addresses "192.168.1.10" and "192.168.1.11".

.NOTES
Author: Your Name
Date: Today's Date
#>

function New-NTPRecord {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DnsServer,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Domain,

        [Parameter(Mandatory = $true)]
        [string[]]$IPAddresses
    )

    begin {
        Write-Verbose "Starting to create NTP record..."
    }

    process {
        $fqdn = "$Name.$Domain"
        foreach ($ip in $IPAddresses) {
            try {
                Add-DnsServerResourceRecordA -Name $Name -ZoneName $Domain -IPv4Address $ip -TimeToLive 00:05:00 -ComputerName $DnsServer -ErrorAction Stop
                Write-Verbose "Successfully added record $fqdn with IP $ip"
            }
            catch {
                Write-Error "Failed to add record $fqdn with IP $($ip): $_"
            }
        }
    }

    end {
        Write-Verbose "Finished creating NTP record."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/New-NTPRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-NTPRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

