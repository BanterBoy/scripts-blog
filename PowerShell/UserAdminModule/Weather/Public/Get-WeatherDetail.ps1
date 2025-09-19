function Get-WeatherDetails {
    <#
    .SYNOPSIS
    Get-WeatherDetails - Cmdlet to get the weather details for a specific town and country.

    .DESCRIPTION
    The Get-WeatherDetails Cmdlet can get the weather details for a specific town and country using the Weatherstack API.

    .PARAMETER      Town
    The name of the town for which you want to get the weather details.

    .PARAMETER      Country
    The country code of the country in which the town is located.

    .PARAMETER      Units
    Available on: All plans
    By default, the API will return all results in metric units. Aside from metric units, other common unit formats are supported as well. You can use the units parameter to switch between the different unit formats Metric, Scientific and Fahrenheit.

    m for Metric:
    Parameter	Units
    units = m	temperature: Celsius
    units = m	Wind Speed/Visibility: Kilometers/Hour
    units = m	Pressure: MB - Millibar
    units = m	Precip: MM - Millimeters
    units = m	Total Snow: CM - Centimeters

    s for Scientific:
    Parameter	Units
    units = s	temperature: Kelvin
    units = s	Wind Speed/Visibility: Kilometers/Hour
    units = s	Pressure: MB - Millibar
    units = s	Precip: MM - Millimeters
    units = s	Total Snow: CM - Centimeters

    f for Fahrenheit:
    Parameter	Units
    units = f	temperature: Fahrenheit
    units = f	Wind Speed/Visibility: Miles/Hour
    units = f	Pressure: MB - Millibar
    units = f	Precip: IN - Inches
    units = f	Total Snow: IN - Inches
    
    .PARAMETER      access_key
    Your API key for the Weatherstack API.

    .INPUTS
    [string]Town
    [string]Country
    [string]Unit
    [string]access_key

    .OUTPUTS
    A PSObject with the weather details for the specified town and country.

    .EXAMPLE
    Get-WeatherDetails -Town "London" -Country "GB" -Unit "m" -access_key "[Your API Key]"

    This command will get the weather details for London, GB in metric units.

    .LINK
    https://weatherstack.com/documentation

    .NOTES
    Author  : Your Name
    Website : Your Website
    Twitter : Your Twitter

    Using Weatherstack API

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Low')]
    [OutputType([PSObject])]
    Param (
        # This field will accept a string value for the town entered - e.g. 'London'
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "This field will accept a string value for the town entered - e.g. 'London'")]
        [String]
        $Town,

        # This field will accept a string value for the country code - e.g. 'GB'
        [ArgumentCompleter( {
                $Content = Invoke-RestMethod -Uri 'https://datahub.io/core/country-list/r/data.json'
                foreach ($Code in $Content) {
                    $Code.Code
                }
            }) ]
        [string]
        $Country,

        # This field will accept a string value for the unit of measurement - e.g. 'm'
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "This field will accept a string value for the unit of measurement - e.g. 'm'")]
        [String]
        $Unit,

        # This field will accept a string value for your API Key - e.g. '[access_key]'
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "This field will accept a string value for your API Key - e.g. '[access_key]'")]
        [String]
        $access_key

    )

    begin {
        $location = "$Town", "'$Country'"
    }

    process {
        try {
            $Weather = Invoke-RestMethod -Method Get -Uri "http://api.weatherstack.com/current?access_key=$access_key&query=$location&units=$Unit"
            $properties = @{
                type                 = $Weather.request.type
                query                = $Weather.request.query
                language             = $Weather.request.language
                unit                 = $Weather.request.unit
                observation_time     = $Weather.current.observation_time
                temperature          = $Weather.current.temperature
                weather_code         = $Weather.current.weather_code
                weather_icons        = $Weather.current.weather_icons
                weather_descriptions = $Weather.current.weather_descriptions
                wind_speed           = $Weather.current.wind_speed
                wind_degree          = $Weather.current.wind_degree
                wind_dir             = $Weather.current.wind_dir
                pressure             = $Weather.current.pressure
                precip               = $Weather.current.precip
                humidity             = $Weather.current.humidity
                cloudcover           = $Weather.current.cloudcover
                feelslike            = $Weather.current.feelslike
                uv_index             = $Weather.current.uv_index
                visibility           = $Weather.current.visibility
                is_day               = $Weather.current.is_day
                name                 = $Weather.location.name
                country              = $Weather.location.country
                region               = $Weather.location.region
                lat                  = $Weather.location.lat
                lon                  = $Weather.location.lon
                timezone_id          = $Weather.location.timezone_id
                localtime            = $Weather.location.localtime
                localtime_epoch      = $Weather.location.localtime_epoch
                utc_offset           = $Weather.location.utc_offset
            }
            $obj = New-Object -TypeName psobject -Property $properties
            Write-Output -InputObject $obj
        }
        catch {
        
        }
    }
    end {
    
    }
}
