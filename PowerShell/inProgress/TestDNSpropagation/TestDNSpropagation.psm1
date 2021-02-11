<#

    .SYNOPSIS
    A function to

    .DESCRIPTION

    .PARAMETER Path
    Species the

    .PARAMETER SearchTerm
    Specifies the

    .PARAMETER Extension
    Specifies the

    .PARAMETER SearchType
    Specifies the

    .EXAMPLE

    .INPUTS
    You can pipe objects to these perameters.

    - Path [string]
    - SearchTerm [string]
    - Extension [string]
    - SearchType [string]

    .OUTPUTS
    System.String. Search-Scripts returns a string with

    .NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/scripts-blog
    Resolve-DNSName

#>
function Test-DNSPropagation {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter DNS record name to be tested. e.g. example.com or 151.101.0.81)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $recordName,

        [Parameter(Mandatory = $True,
            HelpMessage = "Please select DNS record type)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('A', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT')]
        [string[]]
        $Type,

        [Parameter(Mandatory = $false,
            HelpMessage = "Please select Public DNS server)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet ('GooglePrimary', 'GoogleSecondary', 'Quad9Primary', 'Quad9Secondary', 'OpenDNSHomePrimary', 'OpenDNSHomeSecondary', 'CloudflarePrimary', 'CloudflareSecondary', 'CleanBrowsingPrimary', 'CleanBrowsingSecondary', 'AlternateDNSPrimary', 'AlternateDNSSecondary', 'AdGuardDNSPrimary', 'AdGuardDNSSecondary', 'InternalDNSserver', 'DNSGlueServers', 'Default')]
        [string[]]
        $DNSProvider = 'Default'
    )

    begin {
        $DNSservers = [ordered]@{
            GooglePrimary          = "8.8.8.8"
            GoogleSecondary        = "8.8.4.4"
            Quad9Primary           = "9.9.9.9"
            Quad9Secondary         = "149.112.112.112"
            OpenDNSHomePrimary     = "208.67.222.222"
            OpenDNSHomeSecondary   = "208.67.220.220"
            CloudflarePrimary      = "1.1.1.1"
            CloudflareSecondary    = "1.0.0.1"
            CleanBrowsingPrimary   = "185.228.168.9"
            CleanBrowsingSecondary = "185.228.169.9"
            AlternateDNSPrimary    = "198.101.242.72"
            AlternateDNSSecondary  = "23.253.163.53"
            AdGuardDNSPrimary      = "94.140.14.14"
            AdGuardDNSSecondary    = "94.140.15.15"
        }
    }

    process {
        foreach ($record in $recordName) {
            try {
                switch ($DNSProvider) {
                    GooglePrimary {
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.GooglePrimary -ErrorAction Stop
                        Write-Warning -Message "Checking Google Primary..."
                        Write-Output $result
                    }
                    GoogleSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.GoogleSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking Google Secondary..."
                        Write-Output $result
                    }
                    Quad9Primary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.Quad9Primary -ErrorAction Stop
                        Write-Warning -Message "Checking Quad9 Primary..."
                        Write-Output $result
                    }
                    Quad9Secondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.Quad9Secondary -ErrorAction Stop
                        Write-Warning -Message "Checking Quad9 Secondary..."
                        Write-Output $result
                    }
                    OpenDNSHomePrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.OpenDNSHomePrimary -ErrorAction Stop
                        Write-Warning -Message "Checking OpenDNSHome Primary..."
                        Write-Output $result
                    }
                    OpenDNSHomeSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.OpenDNSHomeSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking OpenDNSHome Secondary..."
                        Write-Output $result
                    }
                    CloudflarePrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CloudflarePrimary -ErrorAction Stop
                        Write-Warning -Message "Checking Cloudflare Primary..."
                        Write-Output $result
                    }
                    CloudflareSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CloudflareSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking Cloudflare Secondary..."
                        Write-Output $result
                    }
                    CleanBrowsingPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CleanBrowsingPrimary -ErrorAction Stop
                        Write-Warning -Message "Checking CleanBrowsing Primary..."
                        Write-Output $result
                    }
                    CleanBrowsingSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CleanBrowsingSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking CleanBrowsing Secondary..."
                        Write-Output $result
                    }
                    AlternateDNSPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AlternateDNSPrimary -ErrorAction Stop
                        Write-Warning -Message "Checking AlternateDNS Primary..."
                        Write-Output $result
                    }
                    AlternateDNSSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AlternateDNSSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking AlternateDNS Secondary..."
                        Write-Output $result
                    }
                    AdGuardDNSPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AdGuardDNSPrimary -ErrorAction Stop
                        Write-Warning -Message "Checking AdGuardDNS Primary..."
                        Write-Output $result
                    }
                    AdGuardDNSSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AdGuardDNSSecondary -ErrorAction Stop
                        Write-Warning -Message "Checking AdGuardDNS Secondary..."
                        Write-Output $result
                    }
                    InternalDNSserver {
                        $internalDNS = (Get-ADDomainController -Filter { Name -like "*" }).HostName
                        foreach ($PSItem in $internalDNS) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $PSItem -ErrorAction Stop
                            Write-Warning -Message "Checking $PSItem..."
                            Write-Output $result
                        }
                    }
                    DNSGlueServers {
                        $query = Resolve-DnsName -Name $record -Type NS | Where-Object NameHost
                        $GlueServers = $query.NameHost
                        foreach ($PSItem in $GlueServers) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $PSItem -ErrorAction Stop
                            Write-Warning -Message "Checking $PSItem..."
                            Write-Output $result
                        }
                    }
                    Default {
                        $Servers = $DNSservers.Values
                        foreach ($server in $Servers) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $server -ErrorAction Stop
                            Write-Warning -Message "Checking $server ..."
                            Write-Output $result
                        }
                    }
                }
            }
            catch [System.Exception] {
                Write-Verbose "$record not found!" -Verbose
            }
            catch {
                Write-Verbose "Catch all" -Verbose
            }
        }
    }
    end {

    }
}
