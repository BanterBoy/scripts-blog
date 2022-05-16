function Get-HostIOResults {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter()]
        [string[]]
        $domainName,

        [Parameter()]
        [string[]]
        $apiKey
    )
    begin {
        $siteURL = "https://host.io/api/full/"
        $accessKey = ("?token=" + "$ApiKey")
        $fullresults = Invoke-RestMethod -Method Get -Uri ($siteURL + $domainName + $accessKey)
    }
    process {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
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
    }
    end {
    }
}
