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
