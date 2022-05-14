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
