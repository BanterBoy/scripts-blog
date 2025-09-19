function Set-DnsRecord {
    <#
    .SYNOPSIS
        Modifies a DNS record in a specified zone on a specified DNS server.
    
    .DESCRIPTION
        The Set-DnsRecord function modifies a DNS record in a specified zone on a specified DNS server. 
        It allows you to change the IP address and TTL (Time to Live) of a DNS record. 
        This function is useful for managing DNS records in an automated manner, 
        such as in a scripting or DevOps context.
    
    .PARAMETER ComputerName
        Specifies the DNS server that this cmdlet modifies the DNS record on. 
        This should be the hostname or IP address of the DNS server.
    
    .PARAMETER ZoneName
        Specifies the DNS zone that this cmdlet modifies the DNS record in. 
        This should be the fully qualified domain name (FQDN) of the DNS zone.
    
    .PARAMETER RecordName
        Specifies the DNS record that this cmdlet modifies. 
        This should be the hostname of the record within the DNS zone.
    
    .PARAMETER TtlHours
        Specifies the time-to-live (TTL) value for the DNS record, in hours. 
        TTL is the time period that the DNS record is considered valid by DNS clients. 
        After this period, DNS clients will query the DNS server again for this record.
    
    .PARAMETER NewIpAddress
        Specifies the new IP address for the DNS record. 
        This should be a valid IPv4 address in the format x.x.x.x.
    
    .EXAMPLE
        Set-DnsRecord -ComputerName "dns-server01" -ZoneName "example.com" -RecordName "www" -NewIpAddress "192.168.1.100"
        This example modifies the DNS record for "www.example.com" on "dns-server01" to use the IP address "192.168.1.100".
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]$ZoneName,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]$RecordName,

        [Parameter()]
        [ValidateRange(0, 99999)]
        [int]$TtlHours,

        [Parameter()]
        [ValidatePattern('\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')]
        [string]$NewIpAddress
    )

    begin {
        Write-Verbose "Starting Set-DnsRecord"
    }

    process {
        Write-Verbose "Getting original record"
        try {
            $OrignalRecord = Get-DnsServerResourceRecord -ComputerName $ComputerName -ZoneName $ZoneName -Name $RecordName -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to get original record: $_"
            return
        }

        Write-Verbose "Creating new record object"
        $RecordChange = [ciminstance]::new($OrignalRecord)
        if ($PSBoundParameters.ContainsKey('TtlHours')) {
            $RecordChange.TimeToLive = [System.TimeSpan]::FromHours($TtlHours)
        }
        if ($PSBoundParameters.ContainsKey('NewIpAddress')) {
            $RecordChange.RecordData.IPv4Address = $NewIpAddress
        }

        Write-Verbose "Setting new record"
        if ($PSCmdlet.ShouldProcess("$ComputerName, $ZoneName, $RecordName", "Set-DnsRecord")) {
            try {
                Set-DnsServerResourceRecord -OldInputObject $OrignalRecord -NewInputObject $RecordChange -PassThru -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to set new record: $_"
            }
        }
    }

    end {
        Write-Verbose "Finished Set-DnsRecord"
    }
}
