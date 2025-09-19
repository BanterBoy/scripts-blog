<#
.SYNOPSIS
    Tests various DNS record endpoints to verify their status.

.DESCRIPTION
    This function takes a list of DNS records and a root domain, resolves the records, and tests their endpoints for availability and other criteria depending on the record type.

.PARAMETER DnsRecords
    An array of DNS record objects to test.

.PARAMETER RootDomain
    The root domain to use for resolving DNS records.

.EXAMPLE
    PS C:\> $RootDomain = "raildeliverygroup.com"
    PS C:\> $dnsRecords = Convert-DnsZoneFile -FilePath "C:\GitRepos\Output\DNSMigration\GoDaddyDomains\raildeliverygroup.com.txt"
    PS C:\> $results = Test-DnsRecordEndpoints -DnsRecords $dnsRecords -RootDomain $RootDomain
    PS C:\> $results | Format-Table -AutoSize
    Tests the DNS records for the specified root domain and displays the results in a table format.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-DnsRecordEndpoints {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [psobject[]]$DnsRecords,
        
        [Parameter(Mandatory = $true)]
        [string]$RootDomain
    )

    $recordPatterns = @{
        SOA   = "(?msi)^(\S+)\s+\S+\s+IN\s+SOA\s+([^\s]+)\s+([^\s]+)\s+\((\s+[\d\s]+)+\)"
        A     = "(?msi)^(\S+)\s+\d+\s+IN\s+A\s+(\S+)"
        TXT   = "(?msi)^(\S+)\s+\d+\s+IN\s+TXT\s+(""[^""]+"")"
        CNAME = "(?msi)^(\S+)\s+\d+\s+IN\s+CNAME\s+(\S+)"
        MX    = "(?msi)^(\S+)\s+\d+\s+IN\s+MX\s+(\d+)\s+(\S+)"
        SRV   = "(?msi)^(\S+)\s+\d+\s+IN\s+SRV\s+(\d+)\s+(\d+)\s+(\d+)\s+(\S+)"
        NS    = "(?msi)^(\S+)\s+\d+\s+IN\s+NS\s+(\S+)"
    }

    $results = @()

    foreach ($record in $DnsRecords) {
        Write-Verbose "Processing DNS record: Type=$($record.Type), Name=$($record.Name), Content=$($record.Content)"

        $resolvedName = if ($record.Name -eq '@') { $RootDomain } else { $record.Name -replace '@', $RootDomain }
        $resolvedContent = if ($record.Content -match '[@#%&*]') { $record.Content -replace '[@#%&*]', $RootDomain } else { $record.Content }

        $result = [PSCustomObject]@{
            Type       = $record.Type
            RecordName = $resolvedName
            Content    = $resolvedContent
            Status     = "Not Tested"
            Details    = "No specific test applied."
        }

        switch ($record.Type) {
            "A" {
                Write-Verbose "Testing A record: $resolvedContent"
                if (Test-Connection -ComputerName $resolvedContent -Count 2 -Quiet) {
                    $result.Status = "Active"
                    $result.Details = "IP $resolvedContent is responding."
                }
                else {
                    $result.Status = "Inactive"
                    $result.Details = "IP $resolvedContent is not responding."
                }
            }
            "DMARC" {
                Write-Verbose "Testing DMARC record for domain: $RootDomain"
                try {
                    $dmarcRecord = Find-DMARCRecord -DomainName $RootDomain -DNSProvider Cloudflare -ErrorAction Stop
                    $result.Status = "Info"
                    $result.Details = "$dmarcRecord.DMARC"
                }
                catch {
                    $result.Status = "Failed"
                    $result.Details = "Failed to resolve DMARC: $_"
                }
            }
            "DKIM" {
                Write-Verbose "Testing DKIM record for domain: $resolvedContent"
                try {
                    $dkimRecord = Find-DKIMRecord -DomainName $resolvedContent -DNSProvider Cloudflare -ErrorAction Stop
                    $result.Status = "Info"
                    $result.Details = "$dkimRecord.DKIM"
                }
                catch {
                    $result.Status = "Failed"
                    $result.Details = "Failed to resolve DKIM: $_"
                }
            }
            "CNAME" {
                Write-Verbose "Testing CNAME record: $resolvedContent"
                try {
                    $resolvedIP = Resolve-DnsName -Name $resolvedContent -Type A -ErrorAction Stop
                    if ($resolvedIP.IPAddress) {
                        if (Test-Connection -ComputerName $resolvedIP.IPAddress -Count 2 -Quiet) {
                            $result.Status = "Active"
                            $result.Details = "IP $($resolvedIP.IPAddress) is responding."
                        }
                        else {
                            $result.Status = "Inactive"
                            $result.Details = "IP $($resolvedIP.IPAddress) is not responding."
                        }
                    }
                    else {
                        $result.Status = "Failed"
                        $result.Details = "Failed to resolve IP address for $resolvedContent."
                    }
                }
                catch {
                    $result.Status = "Failed"
                    $result.Details = "Failed to resolve CNAME record: $_"
                }
            }
            "MX" {
                Write-Verbose "Testing MX record for domain: $resolvedContent"
                try {
                    $mxLookup = Find-MxRecord -DomainName $resolvedContent -DNSProvider Cloudflare -ErrorAction Stop
                    $result.Status = "Resolved"
                    $result.Details = "MX record points to $($mxLookup.MX)"
                }
                catch {
                    $result.Status = "Failed"
                    $result.Details = "Failed to resolve MX record: $_"
                }
            }
            "TXT" {
                Write-Verbose "Testing TXT record: $resolvedContent"
                if ($resolvedContent -match '"(spf1)"') {
                    $resolvedContent = $matches[1]
                    try {
                        $spfRecord = Find-SPFRecord -DomainName $resolvedContent -DNSProvider Cloudflare -ErrorAction Stop
                        $result.Status = "Info"
                        $result.Details = "$spfRecord.SPF"
                    }
                    catch {
                        $result.Status = "Failed"
                        $result.Details = "Failed to resolve SPF record: $_"
                    }
                }
                $result.Status = "Info"
                $result.Details = "TXT record content: '$resolvedContent'"
            }
            "SRV" {
                Write-Verbose "SRV record detected. Marking as present."
                $result.Status = "Info"
                $result.Details = "$($record.Type) record is present."
            }
            "NS" {
                Write-Verbose "NS record detected. Marking as present."
                $result.Status = "Info"
                $result.Details = "$($record.Type) record is present."
            }
            "SOA" {
                Write-Verbose "SOA record detected. Marking as present."
                $result.Status = "Info"
                $result.Details = "$($record.Type) record is present."
            }
            "WWW" {
                Write-Verbose "Testing WWW record: $resolvedContent"
                if ($record.Name -like "*www*") {
                    $url = "http://$resolvedContent"
                    try {
                        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10
                        $result.Status = "Reachable"
                        $result.Details = "HTTP status: $($response.StatusCode)"
                    }
                    catch {
                        $result.Status = "Unreachable"
                        $result.Details = "Website $($url) is not reachable: $_"
                    }
                }
            }
            default {
                Write-Verbose "$($record.Type) record type not actively tested."
                $result.Status = "Not Applicable"
                $result.Details = "$($record.Type) record type not actively tested."
            }
        }

        $results += $result
    }

    return $results
}

<# Example usage
$RootDomain = "raildeliverygroup.com"
$dnsRecords = Convert-DnsZoneFile -FilePath "C:\GitRepos\Output\DNSMigration\GoDaddyDomains\raildeliverygroup.com.txt"
$results = Test-DnsRecordEndpoints -DnsRecords $dnsRecords -RootDomain $RootDomain
$results | Format-Table -AutoSize
#>
