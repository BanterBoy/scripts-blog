Function Get-LastxOfMonth {            
    [CmdletBinding()]            
    param(            
        [parameter(Mandatory)]            
        [String]
        $Day,            
            
        [parameter(ParameterSetName = 'ByDate',
            Mandatory,
            ValueFromPipeline)]            
        [System.DateTime]
        $Date,            
            
        [parameter(ParameterSetName = 'ByString',
            Mandatory,
            ValueFromPipelineByPropertyName)]            
        [ValidateRange(1, 12)]            
        [int]
        $Month,

        [parameter(ParameterSetName = 'ByString',
            Mandatory,
            ValueFromPipelineByPropertyName)]            
        [ValidatePattern('^\d{4}$')]            
        [int]
        $Year,            
            
        [switch]
        $asDate = $false            
    )            
    Begin {            
        $alldays = @()            
    }            
    Process {            
        # Validate the Day string passed as parameter by casting it into            
        if (-not([System.DayOfWeek]::$Day -in 0..6)) {            
            Write-Warning -Message 'Invalid string submitted as Day parameter'            
            return            
        }            
            
        Switch ($PSCmdlet.ParameterSetName) {            
            ByString {            
                # Do nothing, variables are already defined and validated            
            }            
            ByDate {            
                $Month = $Date.Month            
                $Year = $Date.Year            
            }            
        }            
        # There aren't 32 days in any month so we make sure we iterate through all days in a month            
        0..31 | ForEach-Object -Process {            
            $evaldate = (Get-Date -Year $Year -Month $Month -Day 1).AddDays($_)            
            if ($evaldate.Month -eq $Month) {            
                if ($evaldate.DayOfWeek -eq $Day) {            
                    $alldays += $evaldate.Day            
                }            
            }            
        }            
        # Output            
        if ($asDate) {            
            Get-Date -Year $Year -Month $Month -Day $alldays[-1]            
        }
        else {            
            $alldays[-1]            
        }            
    }            
    End {}            
}

<#

# Find the last  Wednesday of each month of 2013            
1..12 | ForEach-Object -Process {            
    Get-LastxOfMonth -Day Wednesday -Month $_ -Year 2013 -asDate            
}            
            
# Make a mistake in the spelling of the day name            
Get-LastxOfMonth -Day FridayZ -Month 10 -Year 2010            
            
# Get the last Sunday of this month            
Get-LastxOfMonth -Day Sunday -Month 10 -Year 2012            
            
# Find the last Friday of the current month but next year            
Get-LastxOfMonth -Day Friday -Date (Get-Date).AddYears(1) -asDate            
            
# Submit a Datetime object through the pipeline            
(Get-Date).AddMonths(-4).AddYears(1) | Get-LastxOfMonth -Day Friday -asDate            
            
# Use the other parameter set that uses only a value from the pipeline by property name            
New-Object -TypeName psobject -Property @{            
    Month = 10;            
    Year = 2013;            
} | Get-LastxOfMonth -Day Friday -asDate

#>
