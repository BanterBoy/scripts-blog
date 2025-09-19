function Get-Weather {
    <#
    .SYNOPSIS
    Get the weather information for a specific city.

    .DESCRIPTION
    The Get-Weather function retrieves the current weather information for a specified city using the wttr.in service.

    .PARAMETER City
    The name of the city for which to retrieve the weather information.

    .EXAMPLE
    Get-Weather -City 'Southend-on-Sea'
    Retrieves the weather information for the city of Southend-on-Sea.

    .NOTES
    This function requires an internet connection to retrieve the weather information.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$City
    )

    Begin {
        $Protocols = [Net.SecurityProtocolType]::Tls12
        [Net.ServicePointManager]::SecurityProtocol = $Protocols
    }

    Process {
        try {
            $Weather = Invoke-RestMethod -Uri "http://wttr.in/$City" -ErrorAction Stop
            if ($Weather) {
                Write-Output $Weather
            }
            else {
                Write-Warning "No weather information found for city: $City"
            }
        }
        catch {
            Write-Error "Failed to retrieve weather information for city: $City. Error: $_"
        }
    }

    End {}
}
