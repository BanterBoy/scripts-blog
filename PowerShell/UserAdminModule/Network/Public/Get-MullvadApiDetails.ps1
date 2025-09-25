<#
.SYNOPSIS
Queries Mullvad’s public status API.

.DESCRIPTION
Get-MullvadApiDetails sends a GET request to https://am.i.mullvad.net/<Endpoint> and returns:
  • connected – a user-friendly status message (e.g. “You are not connected to Mullvad. Your IP address is …”)  
  • ip        – your current public IP address as a string  
  • city      – the city of the exit node  
  • country   – the country of the exit node  
  • json      – a PSCustomObject with all fields (ip, country, city, longitude, latitude, mullvad_exit_ip, blacklisted, results, organization)

.PARAMETER Endpoint
The API resource to query. Valid values: connected, ip, city, country, json.

.OUTPUTS
If Endpoint is 'json', returns a PSCustomObject with:
  ip              [string]
  country         [string]
  city            [string]
  longitude       [double]
  latitude        [double]
  mullvad_exit_ip [bool]
  blacklisted     [bool]
  results         [object[]]
  organization    [string]
Otherwise returns a simple string.

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint connected
You are not connected to Mullvad. Your IP address is 77.99.103.120

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint ip
77.99.103.120

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint city
Southend-on-Sea

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint country
United Kingdom

.EXAMPLE
PS> Get-MullvadApiDetails -Endpoint json | Format-List *
ip              : 77.99.103.120
country         : United Kingdom
city            : Southend-on-Sea
longitude       : 0.7101
latitude        : 51.5323
mullvad_exit_ip : False
blacklisted     : False
results         : {}
organization    : Virgin Media
#>

#requires -PSEdition Desktop
function Get-MullvadApiDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('connected', 'ip', 'city', 'country', 'json')]
        [string]$Endpoint
    )

    $url = "https://am.i.mullvad.net/$Endpoint"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        if ($Endpoint -eq 'json') {
            $jsonResponse = $response.Content | ConvertFrom-Json

            # build a PSCustomObject so 'results' comes back as a real array
            return [PSCustomObject]@{
                ip              = $jsonResponse.ip
                country         = $jsonResponse.country
                city            = $jsonResponse.city
                longitude       = $jsonResponse.longitude
                latitude        = $jsonResponse.latitude
                mullvad_exit_ip = $jsonResponse.mullvad_exit_ip
                blacklisted     = $jsonResponse.blacklisted.blacklisted
                results         = $jsonResponse.blacklisted.results
                organization    = $jsonResponse.organization
            }
        }
        else {
            return $response.Content
        }
    }
    catch {
        Write-Error "Failed to retrieve data from Mullvad API: $_"
    }
}
