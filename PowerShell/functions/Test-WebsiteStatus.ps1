function Test-WebsiteStatus {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Url
    )

    Add-Type -AssemblyName System.Web
    $check = "https://isitdown.site/api/v3/"
    $encoded = [System.Web.HttpUtility]::UrlEncode($url )
    $callUrl = "$check$encoded"
    $response = @{
        Name       = 'Response'
        Expression = {
            '{0} ({1})' -f
            ($_.Response_Code -as [System.Net.HttpStatusCode] ),
            $_.Response_Code
        }
    }
    Invoke-RestMethod -Uri $callUrl |
    Select-Object -Property Host, IsItDown, $response
}
