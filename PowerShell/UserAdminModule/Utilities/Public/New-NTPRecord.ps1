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