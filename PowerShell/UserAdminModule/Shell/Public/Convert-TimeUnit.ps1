function Convert-TimeUnit {
    <#
    .SYNOPSIS
    Converts a time value between seconds, minutes, hours, and days.

    .DESCRIPTION
    Accepts a numeric value and converts it from one time unit to another.

    .PARAMETER Value
    The numeric time value to convert.

    .PARAMETER From
    The unit of the provided value. Supported units are Seconds, Minutes, Hours, and Days.

    .PARAMETER To
    The unit to convert the value into. Supported units are Seconds, Minutes, Hours, and Days.

    .EXAMPLE
    Convert-TimeUnit -Value 120 -From Seconds -To Minutes
    Converts 120 seconds to minutes.

    .EXAMPLE
    Convert-TimeUnit -Value 2 -From Days -To Hours
    Converts 2 days to hours.

    .NOTES
    Author: ChatGPT
    Date: 2025-06-01
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [double]$Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds','Minutes','Hours','Days')]
        [string]$From,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds','Minutes','Hours','Days')]
        [string]$To
    )

    $multipliers = @{
        Seconds = 1
        Minutes = 60
        Hours   = 3600
        Days    = 86400
    }

    ($Value * $multipliers[$From]) / $multipliers[$To]
}
