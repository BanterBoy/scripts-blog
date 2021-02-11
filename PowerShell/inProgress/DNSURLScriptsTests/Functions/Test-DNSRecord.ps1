<#

    .SYNOPSIS
    A simple wrapper for the function Resolve-DNSName to perform DNS queries against specific DNS Servers. The parameters enable you to select from a list of Pubic DNS servers to test DNS resolution for a domain. The DNSProvider switch parameter can also be used to select your internal DNS servers and to test against the domains own Name Servers.

    .DESCRIPTION
    A simple wrapper for the function Resolve-DNSName to perform DNS queries against specific DNS Servers. This in no way replaces Resolve-DNSName but provides some simple enhanced queries that do not require you to remember the names or IP Addresses of the Name Servers that you wish to query. This tool does not include all of the functionality of Resolve-DNSName but will speed up everyday DNS queries and diagnostics.
    
    The parameters enable you to select from a list of Pubic DNS servers to test DNS resolution for a domain. The DNSProvider switch parameter can also be used to select you internal DNS servers and to test against the domains own Name Servers.

    The internalDNSservers option for the DNSProviders switch performs an AD query to determine the hostname of the Domain Controllers, performs a DNS query against each Domain Controller and displays the results.

    The DNSProvider Switch utilises external servers and queries to populate the switch with the relevant internal/external/zone servers to perform the query. Further information can be found in the parameter section.

    The list of popular Public DNS Servers was taken from the article - https://www.lifewire.com/free-and-public-dns-servers-2626062 which also provides some useful information regarding DNS and why you might select different public dns servers for your name resolution.

    .PARAMETER recordName
    This is a string and which should container either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6)
    
    e.g. example.com or 151.101.0.81

    .PARAMETER Type
    You can specify any record type using tab complete. If this parameter is not defined, it defaults to performing an A record DNS query.
    
    The following are contained in a ValidateSet so you can cycle through the record types or manually enter the record type you require.

    You can tab complete through a complete list of dns record types or you can enter the record type manually.

    Commonly used record types                  Less commonly used record types:
        A (Host address)                            AFSDB (AFS Data Base location)
        AAAA (IPv6 host address)                    ATMA (Asynchronous Transfer Mode address)
        ALIAS (Auto resolved alias)                 CAA (Certification Authority Authorization)
        CNAME (Canonical name for an alias)         CERT (Certificate / CRL)
        MX (Mail eXchange)                          DHCID (DHCP Information)
        NS (Name Server)                            DNAME (Non-Terminal DNS Name Redirection)
        PTR (Pointer)                               HINFO (Host information)
        SOA (Start Of Authority)                    ISDN (ISDN address)
        SRV (location of service)                   LOC (Location information)
        TXT (Descriptive text)                      MB, MG, MINFO, MR (mailbox records)
                                                    NAPTR (Naming Authority Pointer)
    Records types used for DNSSEC                   NSAP (NSAP address)
        DNSKEY (DNSSEC public key)                  RP (Responsible person)
        DS (Delegation Signer)                      RT (Route through)
        NSEC (Next Secure)                          TLSA (Transport Layer Security Authentication)
        NSEC3 (Next Secure v. 3)                    X25 (X.25 PSDN address)
        NSEC3PARAM (NSEC3 Parameters)
        RRSIG (RRset Signature)

    .PARAMETER DNSProvider
    The DNSProvider Switch utilises the external servers and settings detailed below.

    The parameter is not mandatory and if not selected will default to using Google's Primary and Secondary public DNS servers.

    The switch options are defined as follows:-
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
        InternalDNSserver      = Performs an AD query to determine the hostname of the Domain Controllers
        DNSZoneNameServers     = Performs a query against the recordname to determine the NameServers for the zone
        AllPublic              = Performs a query using all the Primary and Secondary public servers.

    .EXAMPLE
    Test-DNSRecord

    cmdlet Test-DNSRecord at command pipeline position 1
    Supply values for the following parameters:
    (Type !? for Help.)
    recordName[0]: !?
    Please enter DNS record name to be tested. Expectd format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or
    151.101.0.81)
    recordName[0]: example.com
    recordName[1]:

    Name                                           Type   TTL   Section    IPAddress
    ----                                           ----   ---   -------    ---------
    example.com                                    A      19451 Answer     93.184.216.34
    example.com                                    A      19954 Answer     93.184.216.34

    This example shows Test-DNSRecord without any options. As recordname is a mandatory field, you are prompted to enter a FQDN or an IP.

    .EXAMPLE
    Test-DNSRecord -recordName example.com -Type A -DNSProvider GooglePrimary

    Name                                           Type   TTL   Section    IPAddress
    ----                                           ----   ---   -------    ---------
    example.com                                    A      20182 Answer     93.184.216.34
    
    This example shows an 'A' record query against Google's Primary Public DNS server.

    .EXAMPLE
    Test-DNSRecord -recordName bbc.co.uk -Type CNAME -DNSProvider AllPublic

    Name                        Type TTL   Section    PrimaryServer               NameAdministrator           SerialNumber
    ----                        ---- ---   -------    -------------               -----------------           ------------
    bbc.co.uk                   SOA  899   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  899   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  898   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800
    bbc.co.uk                   SOA  900   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800

    This example shows the results from a CNAME lookup queried against the complete list of Public DNS Servers defined in the DNSProviders parameter.

    .EXAMPLE
    Test-DNSRecord -recordName bbc.co.uk -Type CNAME -DNSProvider GooglePrimary -Verbose
    VERBOSE: bbc.co.uk
    VERBOSE: Checking Google Primary...

    Name                        Type TTL   Section    PrimaryServer               NameAdministrator           SerialNumber
    ----                        ---- ---   -------    -------------               -----------------           ------------
    bbc.co.uk                   SOA  899   Authority  ns.bbc.co.uk                hostmaster.bbc.co.uk        2021011800

    This example displays the output with the verbose option enabled. The function performs the search and details which DNS Provider is being queried.

    .INPUTS
    You can pipe objects to these perameters.

    - recordName [string - The expected format is a fully qualified domain name or an IP address]

    - Type ['A', 'AAAA', 'ALIAS', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT', 'DNSKEY', 'DS', 'NSEC', 'NSEC3', 'NSEC3PARAM', 'RRSIG', 'AFSDB', 'ATMA', 'CAA', 'CERT', 'DHCID', 'DNAME', 'HINFO', 'ISDN', 'LOC', 'MB', 'MG', 'MINFO', 'MR', 'NAPTR', 'NSAP', 'RP', 'RT', 'TLSA', 'X25']

    - DNSProvider ['GooglePrimary', 'GoogleSecondary', 'Quad9Primary', 'Quad9Secondary', 'OpenDNSHomePrimary', 'OpenDNSHomeSecondary', 'CloudflarePrimary', 'CloudflareSecondary', 'CleanBrowsingPrimary', 'CleanBrowsingSecondary', 'AlternateDNSPrimary', 'AlternateDNSSecondary', 'AdGuardDNSPrimary', 'AdGuardDNSSecondary', 'InternalDNSserver', 'DNSZoneNameServers', 'AllPublic']

    .OUTPUTS
    System.String. The output returned from Test-DNSRecord is a string

    .NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/scripts-blog
    https://www.lifewire.com/free-and-public-dns-servers-2626062
    Resolve-DNSName - https://docs.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname
    Where-Object - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object

#>
function Test-DNSRecord {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter DNS record name to be tested. Expectd format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or 151.101.0.81)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $recordName,

        [Parameter(Mandatory = $false,
            HelpMessage = "Please select DNS record type. Undefined, this parameter defaults to 'A' record lookups. You can tab complete through the list. A complete list of DNS Record Types is available.)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('A', 'AAAA', 'ALIAS', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT', 'DNSKEY', 'DS', 'NSEC', 'NSEC3', 'NSEC3PARAM', 'RRSIG', 'AFSDB', 'ATMA', 'CAA', 'CERT', 'DHCID', 'DNAME', 'HINFO', 'ISDN', 'LOC', 'MB', 'MG', 'MINFO', 'MR', 'NAPTR', 'NSAP', 'RP', 'RT', 'TLSA', 'X25')]
        $Type = 'A',

        [Parameter(Mandatory = $false,
            HelpMessage = "Please select the DNS server to perform the DNS query against. This is a tab complete list. Please check the help for more details. Get-Help Test-DNSRecord -Parameter DNSProvider)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet ('GooglePrimary', 'GoogleSecondary', 'Quad9Primary', 'Quad9Secondary', 'OpenDNSHomePrimary', 'OpenDNSHomeSecondary', 'CloudflarePrimary', 'CloudflareSecondary', 'CleanBrowsingPrimary', 'CleanBrowsingSecondary', 'AlternateDNSPrimary', 'AlternateDNSSecondary', 'AdGuardDNSPrimary', 'AdGuardDNSSecondary', 'InternalDNSserver', 'DNSZoneNameServers', 'AllPublic')]
        $DNSProvider
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
                        Write-Verbose -Message "Checking Google Primary..."
                        Write-Output $result
                    }
                    GoogleSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.GoogleSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking Google Secondary..."
                        Write-Output $result
                    }
                    Quad9Primary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.Quad9Primary -ErrorAction Stop
                        Write-Verbose -Message "Checking Quad9 Primary..."
                        Write-Output $result
                    }
                    Quad9Secondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.Quad9Secondary -ErrorAction Stop
                        Write-Verbose -Message "Checking Quad9 Secondary..."
                        Write-Output $result
                    }
                    OpenDNSHomePrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.OpenDNSHomePrimary -ErrorAction Stop
                        Write-Verbose -Message "Checking OpenDNSHome Primary..."
                        Write-Output $result
                    }
                    OpenDNSHomeSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.OpenDNSHomeSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking OpenDNSHome Secondary..."
                        Write-Output $result
                    }
                    CloudflarePrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CloudflarePrimary -ErrorAction Stop
                        Write-Verbose -Message "Checking Cloudflare Primary..."
                        Write-Output $result
                    }
                    CloudflareSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CloudflareSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking Cloudflare Secondary..."
                        Write-Output $result
                    }
                    CleanBrowsingPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CleanBrowsingPrimary -ErrorAction Stop
                        Write-Verbose -Message "Checking CleanBrowsing Primary..."
                        Write-Output $result
                    }
                    CleanBrowsingSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.CleanBrowsingSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking CleanBrowsing Secondary..."
                        Write-Output $result
                    }
                    AlternateDNSPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AlternateDNSPrimary -ErrorAction Stop
                        Write-Verbose -Message "Checking AlternateDNS Primary..."
                        Write-Output $result
                    }
                    AlternateDNSSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AlternateDNSSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking AlternateDNS Secondary..."
                        Write-Output $result
                    }
                    AdGuardDNSPrimary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AdGuardDNSPrimary -ErrorAction Stop
                        Write-Verbose -Message "Checking AdGuardDNS Primary..."
                        Write-Output $result
                    }
                    AdGuardDNSSecondary { 
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.AdGuardDNSSecondary -ErrorAction Stop
                        Write-Verbose -Message "Checking AdGuardDNS Secondary..."
                        Write-Output $result
                    }
                    InternalDNSserver {
                        $internalDNS = (Get-ADDomainController -Filter { Name -like "*" }).HostName
                        foreach ($PSItem in $internalDNS) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $PSItem -ErrorAction Stop
                            Write-Verbose -Message "Checking $PSItem..."
                            Write-Output $result
                        }
                    }
                    DNSZoneNameServers {
                        $query = Resolve-DnsName -Name $record -Type NS | Where-Object NameHost
                        $GlueServers = $query.NameHost
                        foreach ($PSItem in $GlueServers) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $PSItem -ErrorAction Stop
                            Write-Verbose -Message "Checking $PSItem..."
                            Write-Output $result
                        }
                    }
                    AllPublic {
                        $Servers = $DNSservers.Values
                        foreach ($server in $Servers) {
                            $result = Resolve-DnsName -Name $record -Type $Type -Server $server -ErrorAction Stop
                            Write-Verbose -Message "Checking $server ..."
                            Write-Output $result
                        }
                    }
                    Default {
                        Write-Verbose -Message "Checking Google Primary..."
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.GooglePrimary -ErrorAction Stop
                        Write-Output $result
                        Write-Verbose -Message "Checking Google Secondary..."
                        $result = Resolve-DnsName -Name $record -Type $Type -Server $DNSservers.GoogleSecondary -ErrorAction Stop
                        Write-Output $result
                    }
                }
            }
            catch [System.Exception] {
                Write-Warning "$record not found!"
            }
            catch {
                Write-Warning "Catch all"
            }
        }
    }
    end {

    }
}
