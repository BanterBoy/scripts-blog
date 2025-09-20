---
layout: post
title: Remove-NTPRecord.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Remove-NTPRecord/
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

Removes an NTP record from a DNS server.

#### Detailed Description

The Remove-NTPRecord function removes an NTP (Network Time Protocol) record from a specified DNS server and zone.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -IPAddresses @("192.168.1.10", "192.168.1.11")
```

This example removes the NTP record "ntp1" with its associated IP addresses from the "example.com" DNS zone on the "dns.example.com" DNS server.

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
Removes an NTP record from a DNS server.

.DESCRIPTION
The Remove-NTPRecord function removes an NTP (Network Time Protocol) record from a specified DNS server and zone.

.PARAMETER DnsServer
The DNS server from which to remove the NTP record.

.PARAMETER Name
The name of the NTP record to be removed.

.PARAMETER Domain
The domain name where the record is located.

.PARAMETER IPAddresses
An array of IP addresses associated with the NTP record.

.EXAMPLE
Remove-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -IPAddresses @("192.168.1.10", "192.168.1.11")

This example removes the NTP record "ntp1" with its associated IP addresses from the "example.com" DNS zone on the "dns.example.com" DNS server.

#>

function Remove-NTPRecord {
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
        Write-Verbose "Starting to remove NTP record..."
    }

    process {
        $fqdn = "$Name.$Domain"
        foreach ($ip in $IPAddresses) {
            try {
                Remove-DnsServerResourceRecord -ZoneName $Domain -Name $Name -RRType "A" -RecordData $ip -ComputerName $DnsServer -Force -ErrorAction Stop
                Write-Verbose "Successfully removed record $fqdn with IP $ip"
            }
            catch {
                Write-Error "Failed to remove record $fqdn with IP $($ip): $_"
            }
        }
    }

    end {
        Write-Verbose "Finished removing NTP record."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Remove-NTPRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-NTPRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

