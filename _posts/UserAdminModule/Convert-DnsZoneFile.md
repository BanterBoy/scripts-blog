---
layout: post
title: Convert-DnsZoneFile.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Convert-DnsZoneFile/
categories:
  - UserAdminModule
  - FileOperations
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

Converts a DNS zone file into a collection of DNS records.

#### Detailed Description

The Convert-DnsZoneFile function reads a DNS zone file and converts it into a collection of DNS records. It supports the following record types: SOA, A, TXT, CNAME, MX, SRV, and NS.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$zoneFilePath = "C:\DNS\example.com.zone"
```

$dnsRecords = Convert-DnsZoneFile -FilePath $zoneFilePath $dnsRecords This example demonstrates how to use the Convert-DnsZoneFile function to convert a DNS zone file located at "C:\DNS\example.com.zone" into a collection of DNS records. The resulting DNS records are then stored in the $dnsRecords variable.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function assumes that the DNS zone file follows the standard format.

- The function uses regular expressions to parse the zone file and extract the DNS records.

- The function does not perform any validation on the DNS records.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Converts a DNS zone file into a collection of DNS records.

.DESCRIPTION
The Convert-DnsZoneFile function reads a DNS zone file and converts it into a collection of DNS records. It supports the following record types: SOA, A, TXT, CNAME, MX, SRV, and NS.

.PARAMETER FilePath
The path to the DNS zone file.

.OUTPUTS
System.Object[]
An array of DNS records. Each record is represented as a custom object with the following properties:
- Type: The type of DNS record (SOA, A, TXT, CNAME, MX, SRV, or NS).
- Name: The name of the DNS record.
- Content: The content of the DNS record.
- Additional: Additional information for certain record types (e.g., MX preference, SRV priority, weight, and port).

.EXAMPLE
$zoneFilePath = "C:\DNS\example.com.zone"
$dnsRecords = Convert-DnsZoneFile -FilePath $zoneFilePath
$dnsRecords

This example demonstrates how to use the Convert-DnsZoneFile function to convert a DNS zone file located at "C:\DNS\example.com.zone" into a collection of DNS records. The resulting DNS records are then stored in the $dnsRecords variable.

.NOTES
- This function assumes that the DNS zone file follows the standard format.
- The function uses regular expressions to parse the zone file and extract the DNS records.
- The function does not perform any validation on the DNS records.
#>
function Convert-DnsZoneFile {
    param (
        [string]$FilePath
    )

    $dnsRecords = @()

    $fileContent = Get-Content -Path $FilePath -Raw
    $recordPatterns = @{
        SOA   = "(?msi)^(\S+)\s+\S+\s+IN\s+SOA\s+([^\s]+)\s+([^\s]+)\s+\((\s+[\d\s]+)+\)"
        A     = "(?msi)^(\S+)\s+\d+\s+IN\s+A\s+(\S+)"
        TXT   = "(?msi)^(\S+)\s+\d+\s+IN\s+TXT\s+(""[^""]+"")"
        CNAME = "(?msi)^(\S+)\s+\d+\s+IN\s+CNAME\s+(\S+)"
        MX    = "(?msi)^(\S+)\s+\d+\s+IN\s+MX\s+(\d+)\s+(\S+)"
        SRV   = "(?msi)^(\S+)\s+\d+\s+IN\s+SRV\s+(\d+)\s+(\d+)\s+(\d+)\s+(\S+)"
        NS    = "(?msi)^(\S+)\s+\d+\s+IN\s+NS\s+(\S+)"
    }

    foreach ($recordType in $recordPatterns.Keys) {
        [regex]::Matches($fileContent, $recordPatterns[$recordType]) | ForEach-Object {
            $record = [pscustomobject]@{
                Type    = $recordType
                Name    = $_.Groups[1].Value.Trim()
                Content = $_.Groups[2].Value.Trim()
                Additional = $_.Groups[3..$_Groups.Count] | Where-Object { $_ } | ForEach-Object { $_.Value.Trim() }
            }
            $dnsRecords += $record
        }
    }

    return $dnsRecords
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Convert-DnsZoneFile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Convert-DnsZoneFile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

