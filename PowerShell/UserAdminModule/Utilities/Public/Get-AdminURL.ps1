function Get-AdminUrls {

    <#

    .SYNOPSIS
    Retrieves a list of admin URLs from a CSV file and filters them based on specified parameters.

    .DESCRIPTION
    The Get-AdminURL function reads a CSV file containing a list of admin URLs and filters them based on specified parameters. The function can filter URLs by service, site, and server. The function can also test the availability of a server and open URLs in the default browser.

    .PARAMETER Service
    Filters URLs by service name.

    .PARAMETER Site
    Filters URLs by site name.

    .PARAMETER Server
    Filters URLs by server name. The parameter supports tab completion.

    .PARAMETER Open
    Opens filtered URLs in the default browser.

    .PARAMETER TestServer
    Tests the availability of the specified server before returning URLs.

    .EXAMPLE
    Get-AdminURL -Server "server01"

    This example retrieves all admin URLs for server01.

    .EXAMPLE
    Get-AdminURL -Service "Exchange" -Site "Site01" -Open

    This example retrieves all admin URLs for Exchange service and Site01 site, and opens them in the default browser.

    .INPUTS
    None.

    .OUTPUTS
    A list of admin URLs filtered by specified parameters.

    .NOTES
    Author: Luke Leigh/Github Copilot
    Date: 2023-08-03
    Version: 1.0

    #>

    [CmdletBinding(DefaultParameterSetName = 'DefaultParameterSet')]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ArgumentCompleter( {
                $Services = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Service
                foreach ($Service in $Services) {
                    $Service.Service
                }
            })]
        [string]$Service,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ArgumentCompleter( {
                $Sites = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Site
                foreach ($Site in $Sites) {
                    $Site.Site
                }
            })]
        [string]$Site,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter( {
                $Servers = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Server
                foreach ($Server in $Servers) {
                    $Server.Server
                }
            })]
        [string]$Server,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet')]
        [switch]$Open,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet')]
        [switch]$TestServer
    
    )

    $urls = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv

    $filteredUrls = $urls
    if ($Service) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Service -eq $Service }
    }
    if ($Site) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Site -eq $Site }
    }
    if ($Server) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Server -eq $Server }
    }
    if ($Open) {
        $filteredUrls | ForEach-Object -ThrottleLimit 5 -Parallel {
            Start-Process -FilePath $_.URL
        }
    }

    if ($TestServer) {
        if ($null -eq $Server -or $Server -eq "") {
            Write-Output "The `$Server variable is null or empty. Please enter a valid server name or IP address."
            $Server = Read-Host "Enter the name or IP address of the server to test"
        }
        
        Write-Output "Testing server $Server..."
        $ping = $false
        while (-not $ping) {
            $ping = Test-Connection -ComputerName $Server -Count 1 -Quiet
            if ($ping) {
                Write-Output "Server $Server is online."
            }
            else {
                Write-Output "Server $Server is offline. Retrying in 5 seconds..."
                Start-Sleep -Seconds 5
            }
        }
    }
    
    return $filteredUrls
}


<#
        Write-Output "Testing server $Server..."
        $ping = $false
        while (-not $ping) {
            $ping = Test-Connection -ComputerName $Server -Count 1 -Quiet
            if ($ping) {
                Write-Output "Server $Server is online."
            }
            else {
                Write-Output "Server $Server is offline. Retrying in 5 seconds..."
                Start-Sleep -Seconds 5
            }
        }
#>