<#
.SYNOPSIS
    Retrieves port service information based on a search query.

.DESCRIPTION
    The Get-PortService function retrieves port service information based on a search query. The search query can be performed on the port number, service name, or description. The function reads the port service data from a JSON file located in the same directory as the script.

.PARAMETER Query
    The search query to use for retrieving port service information.

.PARAMETER SearchField
    The field to search for the query. Valid values are 'PortNumber', 'ServiceName', and 'Description'. The default value is 'ServiceName'.

.PARAMETER SearchAllFields
    If specified, the search query will be performed on all fields.

.OUTPUTS
    Returns an array of PortService objects that match the search query.

.EXAMPLE
    Get-PortService -Query '80'

    Retrieves port service information for port number 80.

.EXAMPLE
    Get-PortService -Query 'http' -SearchField 'Description'

    Retrieves port service information for services with 'http' in the description.

.EXAMPLE
    Get-PortService -Query 'ftp' -SearchAllFields

    Retrieves port service information for services with 'ftp' in any field.
#>

class PortService {
    [string]$ServiceName
    [string]$PortNumber
    [string]$Description
    [string]$Reference

    PortService([string]$ServiceName, [string]$PortNumber, [string]$Description, [string]$Reference) {
        $this.ServiceName = $ServiceName
        $this.PortNumber = $PortNumber
        $this.Description = $Description
        $this.Reference = $Reference
    }

    [bool] MatchPortNumber([string]$PortNumber) {
        if ($this.PortNumber -eq $PortNumber) {
            return $true
        }
        return $false
    }

    [bool] MatchServiceName([string]$ServiceName) {
        if ($this.ServiceName -eq $ServiceName) {
            return $true
        }
        return $false
    }

    [bool] MatchDescription($query) {
        if ($this.Description -like "*$query*") {
            return $true
        }
        return $false
    }

    [string] ToString() {
        return "ServiceName: $($this.ServiceName), PortNumber: $($this.PortNumber), Description: $($this.Description), Reference: $($this.Reference)"
    }
}

function Get-PortService {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        [Parameter()]
        [ValidateSet('PortNumber', 'ServiceName', 'Description')]
        [string]$SearchField = 'ServiceName',
        [Parameter()]
        [switch]$SearchAllFields
    )

    $portServiceData = Get-Content -Raw -Path $PSScriptRoot\resources\port_service_data.json | ConvertFrom-Json
    $portServices = @()

    foreach ($entry in $portServiceData) {
        $portService = [PortService]::new($entry.ServiceName, $entry.PortNumber, $entry.Description, $entry.Reference)

        if ($SearchAllFields) {
            if ($portService.MatchPortNumber($Query) -or $portService.MatchServiceName($Query) -or $portService.MatchDescription($Query)) {
                $portServices += $portService
            }
        }
        else {
            switch ($SearchField) {
                'PortNumber' {
                    if ($portService.MatchPortNumber($Query)) {
                        $portServices += $portService
                    }
                }
                'ServiceName' {
                    if ($portService.MatchServiceName($Query)) {
                        $portServices += $portService
                    }
                }
                'Description' {
                    if ($portService.MatchDescription($Query)) {
                        $portServices += $portService
                    }
                }
            }
        }
    }

    return $portServices
}
