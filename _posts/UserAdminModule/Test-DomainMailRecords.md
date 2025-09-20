---
layout: post
title: Test-DomainMailRecords.ps1
date: 2025-09-19
permalink: /useradminmodule/testing/test-domainmailrecords/
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

Tests the mail records (MX, SPF, DKIM, DMARC) for a given domain using a specified DNS server.

#### Detailed Description

This function queries the MX, SPF, DKIM, and DMARC records for a specified domain using a given DNS server. It returns a custom object containing the results of these queries.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Test-DomainMailRecords -DomainName "example.com"
```

This example tests the mail records for the domain "example.com" using the default DNS server.

**Example 2**

```powershell
Test-DomainMailRecords -DomainName "example.com" -DnsServer "8.8.8.8"
```

This example tests the mail records for the domain "example.com" using the DNS server "8.8.8.8".

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
    Tests the mail records (MX, SPF, DKIM, DMARC) for a given domain using a specified DNS server.

.DESCRIPTION
    This function queries the MX, SPF, DKIM, and DMARC records for a specified domain using a given DNS server.
    It returns a custom object containing the results of these queries.

.PARAMETER DomainName
    The domain name for which the mail records are to be tested. This parameter is mandatory.

.PARAMETER DnsServer
    The DNS server to be used for the queries. If not specified, the default value of "1.1.1.1" will be used.

.EXAMPLE
    Test-DomainMailRecords -DomainName "example.com"

    This example tests the mail records for the domain "example.com" using the default DNS server.

.EXAMPLE
    Test-DomainMailRecords -DomainName "example.com" -DnsServer "8.8.8.8"

    This example tests the mail records for the domain "example.com" using the DNS server "8.8.8.8".

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Test-DomainMailRecords {
    [CmdletBinding()]
    param (
        # Domain name to be tested
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$DomainName,

        # DNS server to be used for the queries
        [Parameter(Mandatory = $false)]
        [string]$DnsServer = "1.1.1.1"
    )

    begin {
        Write-Verbose "Starting to test mail records for domain: $DomainName using DNS server: $DnsServer"
    }

    process {
        # Initialize the result object with default values
        $result = [PSCustomObject]@{
            DomainName  = $DomainName
            MXRecords   = $null
            SPFRecord   = $null
            DKIMRecords = @()
            DMARCRecord = $null
            QueryServer = $DnsServer
            Errors      = @()
        }

        # Query MX records
        try {
            Write-Verbose "Querying MX records for $DomainName using DNS server $DnsServer"
            $mxRecords = Resolve-DnsName -Name $DomainName -Type MX -Server $DnsServer
            if ($mxRecords) {
                $result.MXRecords = $mxRecords
                Write-Verbose "MX records found: $($mxRecords -join ', ')"
            }
        }
        catch {
            $errorMsg = "Failed to query MX records for {$DomainName}: $_"
            Write-Warning $errorMsg
            $result.Errors += $errorMsg
        }

        # Query SPF record using Find-SPFRecord
        try {
            Write-Verbose "Querying SPF record for $DomainName using DNS server $DnsServer"
            $spfRecord = Find-SPFRecord -DomainName $DomainName -DnsServer $DnsServer
            if ($spfRecord) {
                $result.SPFRecord = $spfRecord
                Write-Verbose "SPF record found: $spfRecord"
            }
        }
        catch {
            $errorMsg = "Failed to query SPF record for {$DomainName}: $_"
            Write-Warning $errorMsg
            $result.Errors += $errorMsg
        }

        # Query DKIM records using Find-DKIMRecord
        try {
            Write-Verbose "Querying DKIM records for $DomainName using DNS server $DnsServer"
            $dkimRecords = Find-DKIMRecord -DomainName $DomainName -DnsServer $DnsServer
            if ($dkimRecords) {
                $result.DKIMRecords = $dkimRecords
                Write-Verbose "DKIM records found: $($dkimRecords -join ', ')"
            }
        }
        catch {
            $errorMsg = "Failed to query DKIM records for {$DomainName}: $_"
            Write-Warning $errorMsg
            $result.Errors += $errorMsg
        }

        # Query DMARC record using Find-DMARCRecord
        try {
            Write-Verbose "Querying DMARC record for $DomainName using DNS server $DnsServer"
            $dmarcRecord = Find-DMARCRecord -DomainName $DomainName -DnsServer $DnsServer
            if ($dmarcRecord) {
                $result.DMARCRecord = $dmarcRecord
                Write-Verbose "DMARC record found: $dmarcRecord"
            }
        }
        catch {
            $errorMsg = "Failed to query DMARC record for {$DomainName}: $_"
            Write-Warning $errorMsg
            $result.Errors += $errorMsg
        }

        # Return the result object
        $result
    }
}

# Example usage
# Test-DomainMailRecords -DomainName "raildeliverygroup.com" -DnsServer "1.1.1.1" -Verbose | Format-List
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-DomainMailRecords.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-DomainMailRecords.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

