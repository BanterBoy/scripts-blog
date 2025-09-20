[CmdletBinding()]

param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your API Key.")]
    [Alias('API')]
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your website uri.")]
    [Alias('ws')]
    [string[]]$Website

)

BEGIN {}

PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = "https://urlscan.io/api/v1/scan/"
    $urlscan = Invoke-RestMethod -Method Post -Uri $Uri -ContentType "application/json" -Headers @{"API-Key" = "$ApiKey" } -Body "{`"url`":`"$Website`"}"

    foreach ( $scan in $urlscan ) {
        $item = $scan | Select-Object -Property *
        try {
            $scanProperties = @{
                message    = $item.message
                uuid       = $item.uuid
                result     = $item.result
                api        = $item.api
                visibility = $item.visibility
                url        = $item.url
            }
        }
        catch {
            $scanProperties = @{
                message    = $item.message
                uuid       = $item.uuid
                result     = $item.result
                api        = $item.api
                visibility = $item.visibility
                url        = $item.url
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $scanProperties
            Write-Output $obj
        }
    }
}

END {}