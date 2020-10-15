function Get-SslLabsScore {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [String[]]$UrlList
    )

    Begin {
        [int]$i = 0
    }
    Process {
        Foreach ($Url in $UrlList) {  
            try { 
                $i++ 
                Write-Progress -Activity "Checking URI" -Status "$Url - $i/$(@($UrlList).count) $($i/$(@($UrlList).count)*100 -as [int])%" -PercentComplete ($i / $(@($UrlList).count) * 100 -as [int]) 

                #API Doc https://github.com/ssllabs/ssllabs-scan/blob/master/ssllabs-api-docs-v3.md
                $API = "https://api.ssllabs.com/api/v2/analyze?host=$url&all=on&maxAge=24&"

                do {
                    $JsonData = Invoke-WebRequest -Uri $API -ErrorAction SilentlyContinue | ConvertFrom-Json  
                    Write-Verbose -Message "$($Url): Status is $($JsonData.status), sleeping for 20 seconds"  
                    Start-Sleep -seconds 20  
                }
                while ((-Not($JsonData.status -eq "Ready") ))
                
                New-Object -TypeName PSObject -Property @{
                    Host            = $JsonData.Host
                    IPAddress       = $JsonData.endpoints.ipAddress
                    Grade           = $JsonData.endpoints.grade
                    StatusMessage   = $JsonData.endpoints.statusMessage
                    DurationSeconds = $JsonData.endpoints.duration / 1000 -as [int]
            
                    #Key
                    KeyStrength     = $JsonData.endpoints.details.key.size
            
                    #Cert
                    CommonName      = $JsonData.endpoints.details.cert | Select-Object -ExpandProperty commonNames
                    SAN             = ($JsonData.endpoints.details.cert | Select-Object -ExpandProperty altNames) -join ','
                    Issuer          = $JsonData.endpoints.details.cert.issuerLabel
                    notBefore       = ([DateTime]'1/1/1970').AddMilliseconds($JsonData.endpoints.details.cert.notBefore)
                    notAfter        = ([DateTime]'1/1/1970').AddMilliseconds($JsonData.endpoints.details.cert.notAfter)
                    sigAlg          = $JsonData.endpoints.details.cert.sigAlg
                }
            } 
            catch { 
                Write-Warning -Message "$Url failed: $_ !"
            } 
        }
    }
    End {
    }
}
