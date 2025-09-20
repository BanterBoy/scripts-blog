---
layout: post
title: Set-NTPRecord.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/set-ntprecord/
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

Sets NTP records in a DNS server zone.

#### Detailed Description

The Set-NTPRecord function is used to update an NTP record in a DNS server zone. It removes the old IP addresses associated with the specified record and adds the new IP addresses.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -OldIPAddresses @("192.168.1.10") -NewIPAddresses @("10.0.0.10")
```

This example updates the NTP record "ntp1" in the "example.com" domain on the "dns.example.com" DNS server by removing the old IP address "192.168.1.10" and adding the new IP address "10.0.0.10".

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
Sets NTP records in a DNS server zone.

.DESCRIPTION
The Set-NTPRecord function is used to update an NTP record in a DNS server zone. It removes the old IP addresses associated with the specified record and adds the new IP addresses.

.PARAMETER DnsServer
The DNS server where the zone is hosted.

.PARAMETER Name
The name of the NTP record to be updated.

.PARAMETER Domain
The domain name where the record is located.

.PARAMETER OldIPAddresses
An array of old IP addresses to be removed.

.PARAMETER NewIPAddresses
An array of new IP addresses to be added.

.EXAMPLE
Set-NTPRecord -DnsServer "dns.example.com" -Name "ntp1" -Domain "example.com" -OldIPAddresses @("192.168.1.10") -NewIPAddresses @("10.0.0.10")

This example updates the NTP record "ntp1" in the "example.com" domain on the "dns.example.com" DNS server by removing the old IP address "192.168.1.10" and adding the new IP address "10.0.0.10".

#>

function Set-NTPRecord {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DnsServer,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Domain,

        [Parameter(Mandatory = $true)]
        [string[]]$OldIPAddresses,

        [Parameter(Mandatory = $true)]
        [string[]]$NewIPAddresses
    )

    begin {
        Write-Verbose "Starting to update NTP record..."
    }

    process {
        $fqdn = "$Name.$Domain"
        foreach ($oldIp in $OldIPAddresses) {
            try {
                Remove-DnsServerResourceRecord -ZoneName $Domain -Name $Name -RRType "A" -RecordData $oldIp -ComputerName $DnsServer -Force -ErrorAction Stop
                Write-Verbose "Successfully removed old record $fqdn with IP $oldIp"
            }
            catch {
                Write-Error "Failed to remove old record $fqdn with IP $($oldIp): $_"
            }
        }
        foreach ($newIp in $NewIPAddresses) {
            try {
                Add-DnsServerResourceRecordA -Name $Name -ZoneName $Domain -IPv4Address $newIp -TimeToLive 00:05:00 -ComputerName $DnsServer -ErrorAction Stop
                Write-Verbose "Successfully added new record $fqdn with IP $newIp"
            }
            catch {
                Write-Error "Failed to add new record $fqdn with IP $($newIp): $_"
            }
        }
    }

    end {
        Write-Verbose "Finished updating NTP record."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Set-NTPRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-NTPRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

