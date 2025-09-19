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
