<#
.SYNOPSIS
Retrieves the last Group Policy update time for a specified computer.

.DESCRIPTION
The Get-LastGPOUpdateTime function queries the registry of a remote or local computer to retrieve the last Group Policy update time. It calculates the time span since the last update and returns the result as a custom object.

.PARAMETER ComputerName
The name of the computer to query. If not specified, the function will query the local computer.

.EXAMPLE
Get-LastGPOUpdateTime -ComputerName "Computer01"
This example retrieves the last Group Policy update time for the computer named "Computer01".

.EXAMPLE
Get-LastGPOUpdateTime
This example retrieves the last Group Policy update time for the local computer.

.OUTPUTS
The function returns a custom object with the following properties:
- ComputerName: The name of the computer.
- LastGPOUpdateTime: The date and time of the last Group Policy update.
- DaysSinceLastUpdate: The number of days since the last update.
- TimeSinceLastUpdate: The time span since the last update in the format "hours, minutes, seconds".

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>
function Get-LastGPOUpdateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $gpResult = if ($ComputerName -eq $env:COMPUTERNAME) {
            # Local computer
            [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
        } else {
            # Remote computer
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            }
        }
        $lastGPUpdateDate = Get-Date ($gpResult)
        $timeSinceLastUpdate = New-TimeSpan -Start $lastGPUpdateDate -End (Get-Date)

        $result = [PSCustomObject]@{
            ComputerName         = $ComputerName
            LastGPOUpdateTime    = $lastGPUpdateDate
            DaysSinceLastUpdate  = $timeSinceLastUpdate.Days
            TimeSinceLastUpdate  = ("{0} hours, {1} minutes, {2} seconds" -f $timeSinceLastUpdate.Hours, $timeSinceLastUpdate.Minutes, $timeSinceLastUpdate.Seconds)
        }

        return $result
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Verbose "An error occurred while querying the Group Policy update time on $($ComputerName): $errMsg"

        $errorDetails = [PSCustomObject]@{
            ComputerName = $ComputerName
            Error        = $errMsg
        }

        return $errorDetails
    }
}
