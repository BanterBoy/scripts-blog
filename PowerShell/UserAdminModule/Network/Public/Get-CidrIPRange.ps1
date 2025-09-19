function Get-CidrIPRange {

    <#
    .SYNOPSIS
    Short function to display the details for a CIDR range

    .DESCRIPTION
    This function was created to output the details of a CIDR range using the API from hackertarget.com

    .EXAMPLE
    Get-CidrIPRange -cidrAddress 192.168.1.1 -prefix 24
    
    Address       = 192.168.1.1
    Network       = 192.168.1.0 / 24
    Netmask       = 255.255.255.0
    Broadcast     = 192.168.1.255
    Wildcard Mask = 0.0.0.255
    Hosts Bits    = 8
    Max. Hosts    = 254   (2^8 - 2)
    Host Range    = { 192.168.1.1 - 192.168.1.254 }

    .INPUTS
    cidrAddress [string]
    prefix [int]

    .OUTPUTS
    Output is simple and of content type text

    .NOTES
    Author:     Luke Leigh
    Website:    https://admintoolkit.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/adminToolkit/wiki

    .PARAMETER cidrAddress
    The network address in CIDR notation (e.g., 10.0.0.0).

    .PARAMETER prefix
    The prefix length of the CIDR range (e.g., 29).

    .EXAMPLE
    Get-CidrIPRange -cidrAddress 192.168.1.1 -prefix 24

    This example retrieves the details for the CIDR range 192.168.1.0/24.

    #>

    [cmdletbinding(DefaultParameterSetName = 'default')]
    param([Parameter(Mandatory = $True,
            HelpMessage = "Please enter a network address e.g. 10.0.0.0",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string]$cidrAddress,
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter a prefix e.g. 29",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [int]$prefix
    )
    
    begin { }
    
    process {
        $cidrRange = $cidrAddress + '/' + $prefix
        Invoke-RestMethod -Method Default -Uri "https://api.hackertarget.com/subnetcalc/?q=$CidrRange"
    }
    
    end { }
}
