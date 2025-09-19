<#
    .SYNOPSIS
        Retrieves bank holidays for the UK regions (England and Wales, Scotland, or Northern Ireland).
    
    .DESCRIPTION
        This function fetches bank holiday data from the UK Government API and returns a list of holidays for the selected region.
        It also provides options to filter holidays by year or to retrieve the next upcoming holiday.
    
    .PARAMETER Region
        Specifies the UK region for which to retrieve bank holidays.
        Valid options are "EnglandAndWales", "Scotland", and "NorthernIreland".

    .PARAMETER NextUpcoming
        If specified, the function returns only the next upcoming bank holiday for the selected region.

    .PARAMETER Year
        If specified, the function filters and returns only bank holidays that occur in the given year.

    .EXAMPLE
        Get-BankHolidays -Region EnglandAndWales
        Retrieves all bank holidays for England and Wales.
    
    .EXAMPLE
        Get-BankHolidays -Region Scotland -NextUpcoming
        Retrieves the next upcoming bank holiday for Scotland.
    
    .EXAMPLE
        Get-BankHolidays -Region NorthernIreland -Year 2025
        Retrieves bank holidays for Northern Ireland in the year 2025.
    
    .NOTES
        Author: Luke Leigh
        Version: 1.1
        Source: https://www.gov.uk/bank-holidays.json
#>

function Get-BankHolidays {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("EnglandAndWales", "Scotland", "NorthernIreland")]
        [string]$Region = "EnglandAndWales",

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [switch]$NextUpcoming,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1900, 2100)]
        [int]$Year
    )
    
    begin {
        $url = "https://www.gov.uk/bank-holidays.json"
    }
    
    process {
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            
            if (-not $response) {
                Write-Error "Failed to retrieve bank holiday data."
                return
            }

            $bankHolidays = [BankHolidays]::new()

            $bankHolidays.englandAndWales = [EnglandAndWales]::new()
            $bankHolidays.englandAndWales.division = "england-and-wales"
            $bankHolidays.englandAndWales.events = $response."england-and-wales".events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $bankHolidays.scotland = [Scotland]::new()
            $bankHolidays.scotland.division = "scotland"
            $bankHolidays.scotland.events = $response.scotland.events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $bankHolidays.northernIreland = [NorthernIreland]::new()
            $bankHolidays.northernIreland.division = "northern-ireland"
            $bankHolidays.northernIreland.events = $response."northern-ireland".events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $events = switch ($Region) {
                "EnglandAndWales" { $bankHolidays.englandAndWales.events }
                "Scotland" { $bankHolidays.scotland.events }
                "NorthernIreland" { $bankHolidays.northernIreland.events }
            }
            
            if ($Year) {
                $events = $events | Where-Object { (Get-Date $_.date -Format "yyyy") -eq $Year }
            }

            if ($NextUpcoming) {
                $today = (Get-Date).ToString("yyyy-MM-dd")
                $upcomingHoliday = $events | Where-Object { $_.date -gt $today } | Sort-Object date | Select-Object -First 1
                return $upcomingHoliday
            }
            
            return $events
        }
        catch {
            Write-Error "Error retrieving data: $_"
        }
    }
}

class Event {
    [string] $title
    [string] $date
    [string] $notes
    [bool] $bunting
}

class EnglandAndWales {
    [string] $division
    [Event[]] $events
}

class Scotland {
    [string] $division
    [Event[]] $events
}

class NorthernIreland {
    [string] $division
    [Event[]] $events
}

class BankHolidays {
    [EnglandAndWales] $englandAndWales
    [Scotland] $scotland
    [NorthernIreland] $northernIreland
}