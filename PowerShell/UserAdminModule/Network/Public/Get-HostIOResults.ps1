<#
.SYNOPSIS
    Retrieves host I/O results for a given domain name using the host.io API.

.DESCRIPTION
    The Get-HostIOResults function retrieves host I/O results for a given domain name using the host.io API. It makes a GET request to the host.io API and returns the results as a PowerShell object.

.PARAMETER domainName
    Specifies the domain name for which to retrieve host I/O results.

.PARAMETER apiKey
    Specifies the API key to authenticate the request to the host.io API.

.EXAMPLE
    Get-HostIOResults -domainName "example.com" -apiKey "YOUR_API_KEY"

    Retrieves host I/O results for the domain "example.com" using the specified API key.

.NOTES
    This function requires an active internet connection to access the host.io API.
#>
function Get-HostIOResults {
    [CmdletBinding()]

    param (
        [Parameter()]
        [string[]]
        $domainName,

        [Parameter()]
        [string[]]
        $apiKey
    )
        
    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $siteURL = "https://host.io/api/full/"
        $accessKey = ("?token=" + "$ApiKey")
        $fullresults = Invoke-RestMethod -Method Get -Uri ($siteURL + $domainName + $accessKey)
    }
    
    process {
        try {
            foreach ($result in $fullresults) {
                $properties = @{
                    "Domain"       = $fullresults.domain
                    "WEB"          = $fullresults.web
                    "DomainRecord" = $fullresults.dns.domain
                    "ARecord"      = $fullresults.dns.a
                    "AAAADomain"   = $fullresults.dns.aaaa
                    "MXDomain"     = $fullresults.dns.mx
                    "NSDomain"     = $fullresults.dns.ns
                    
                }
            }
        }
        finally {
            $object = New-Object -TypeName PSObject -Property $properties
            Write-Output $object
        }
    }
    
    end {
        
    }
}
