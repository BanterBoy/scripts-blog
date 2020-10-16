function Test-DNSPropagation {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter DNS record to be tested)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $Records,

        [Parameter(Mandatory = $True,
            HelpMessage = "Please select DNS record type)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('A', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT')]
        [string[]]
        $Type
    )

    begin {
        
    }
    
    process {

        foreach ($Record in $Records) {
            Try {
                # Google
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 8.8.8.8
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 8.8.4.4
        
                # Quad9
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 9.9.9.9
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 149.112.112.112
        
                # OpenDNS Home
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 208.67.222.222
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 208.67.220.220
        
                # Cloudflare
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 1.1.1.1
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 1.0.0.1
        
                # CleanBrowsing
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 185.228.168.9
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 185.228.169.9
        
                # Verisign
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 64.6.64.6
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 64.6.65.6
        
                # Alternate DNS
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 198.101.242.72
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 23.253.163.53
        
                # AdGuard DNS
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 176.103.130.130
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 176.103.130.131
            }
            Catch [System.Exception] {
                Write-Verbose "$Record not found!" -Verbose
            }
            Catch {
                Write-Verbose "Catch all" -Verbose
            }
        }

    }
    
    end {
        
    }
}

# Test-DNSPropagation -Records "mail.example.co.uk", "mail2.example.co.uk", "mail3.example.co.uk" -Type A