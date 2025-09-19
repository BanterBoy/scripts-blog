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
