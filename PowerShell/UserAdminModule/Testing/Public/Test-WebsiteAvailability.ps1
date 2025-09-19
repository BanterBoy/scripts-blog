function Test-WebsiteAvailability {
    <#
    .SYNOPSIS
        Tests the availability of websites by checking the HTTP status code.
    
    .DESCRIPTION
        This function checks if websites are available by making an HTTP request and checking the response status code.
    
    .PARAMETER WebAddress
        The URL for the website you wish to check.
    
    .PARAMETER TestBothProtocols
        A switch to indicate whether to test both HTTP and HTTPS versions of the URL.
    
    .PARAMETER Timeout
        The timeout duration for the web requests in seconds.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com"
        This will test if the specified website is available.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -TestBothProtocols
        This will test both HTTP and HTTPS versions of the specified website.
    
    .EXAMPLE
        PS C:\> Test-WebsiteAvailability -WebAddress "https://www.google.com" -Timeout 5
        This will test if the specified website is available with a timeout of 5 seconds.
    
    .OUTPUTS
        PSCustomObject with Website, Port, StatusCode, StatusDescription, and ErrorMessage
    
    .NOTES
        Additional information about the function.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$WebAddress,

        [switch]$TestBothProtocols,

        [int]$Timeout = 10
    )

    BEGIN {
        $Results = @()
    }

    PROCESS {
        foreach ($Address in $WebAddress) {
            $urlsToTest = @()

            # Extract the URL components
            try {
                $uri = [System.Uri]::new($Address)
                $hostname = $uri.Host
                $port = $uri.Port
                $portStr = if ($port -ne 80 -and $port -ne 443) { ":$port" } else { "" }
                $pathAndQuery = $uri.PathAndQuery

                # Add URLs based on the TestBothProtocols switch
                if ($TestBothProtocols) {
                    if ($uri.Scheme -eq "https") {
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                    } elseif ($uri.Scheme -eq "http") {
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                    } else {
                        $urlsToTest += @{ Url = "http://$hostname$portStr$pathAndQuery"; Port = $port }
                        $urlsToTest += @{ Url = "https://$hostname$portStr$pathAndQuery"; Port = $port }
                    }
                } else {
                    $urlsToTest += @{ Url = "$($uri.Scheme)://$hostname$portStr$pathAndQuery"; Port = $port }
                }
            }
            catch {
                Write-Verbose "Failed to parse URL: $Address"
                continue
            }
            
            foreach ($url in $urlsToTest) {
                Write-Verbose "Testing website: $($url.Url)"
                try {
                    $response = Invoke-WebRequest -Uri $url.Url -UseBasicParsing -TimeoutSec $Timeout
                    Write-Verbose "Received response from $($url.Url) with status code: $($response.StatusCode)"
                    $Results += [PSCustomObject]@{
                        Website          = $url.Url
                        Port             = $url.Port
                        StatusCode       = $response.StatusCode
                        StatusDescription = $response.StatusDescription
                        ErrorMessage     = $null
                    }
                }
                catch {
                    Write-Verbose "Failed to connect to $($url.Url)"
                    $errorMessage = $_.Exception.Message
                    if ($_.Exception.InnerException) {
                        $errorMessage += " Inner Exception: $($_.Exception.InnerException.Message)"
                    }
                    $Results += [PSCustomObject]@{
                        Website          = $url.Url
                        Port             = $url.Port
                        StatusCode       = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "N/A" }
                        StatusDescription = $_.Exception.Message
                        ErrorMessage     = $errorMessage
                    }
                }
            }
        }
    }

    END {
        $Results
    }
}
