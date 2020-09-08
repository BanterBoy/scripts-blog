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
    [string[]]$Website,

    [Parameter(Mandatory = $false,
        ValueFromPipeline = $True,
        HelpMessage = "Make public.")]
    [Alias('pub')]
    [switch[]]$Public

)

BEGIN {}

PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = @{
        "urlscan" = "https://urlscan.io/api/v1/scan/"
    }

    $Header = @{
        'API-Key' = "$ApiKey"
        'Content-Type' = 'application/json'
    }


    $url = "\$Website\"
    $public = "\$Public\"
    $urlscan = Invoke-RestMethod -Uri $Uri.urlscan -Method Post -Headers $Header -Body $Body

    foreach ( $scan in $urlscan ) {
        $item = $scan | Select-Object -Property *
        try {
            $scanProperties = @{
                message = $item.message
                uuid = $item.uuid
                result = $item.result
                api = $item.api
                visibility = $item.visibility
                url = $item.url
            }
        }
        catch {
            $scanProperties = @{
                message = $item.message
                uuid = $item.uuid
                result = $item.result
                api = $item.api
                visibility = $item.visibility
                url = $item.url
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $scanProperties
            Write-Output $obj
        }
    }
}

END {}