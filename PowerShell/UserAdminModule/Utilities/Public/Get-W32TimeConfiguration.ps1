<#
.SYNOPSIS
Retrieves the W32Time configuration for a specified computer.

.DESCRIPTION
The Get-W32TimeConfiguration function retrieves the W32Time configuration for a specified computer. It uses the w32tm command-line tool to query the configuration and parses the output to create a custom PSObject with the configuration properties.

.PARAMETER ComputerName
Specifies the name of the computer for which to retrieve the W32Time configuration. If not specified, the local computer is used.

.EXAMPLE
Get-W32TimeConfiguration -ComputerName "Server01"
Retrieves the W32Time configuration for the computer named "Server01".

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject
A custom PSObject representing the W32Time configuration with the following properties:
- ComputerName
- EventLogFlags
- AnnounceFlags
- TimeJumpAuditOffset
- MinPollInterval
- MaxPollInterval
- MaxNegPhaseCorrection
- MaxPosPhaseCorrection
- MaxAllowedPhaseOffset
- FrequencyCorrectRate
- PollAdjustFactor
- LargePhaseOffset
- SpikeWatchPeriod
- LocalClockDispersion
- HoldPeriod
- PhaseCorrectRate
- UpdateInterval
- DllName
- Enabled
- InputProvider
- CrossSiteSyncFlags
- AllowNonstandardModeCombinations
- ResolvePeerBackoffMinutes
- ResolvePeerBackoffMaxTimes
- CompatibilityFlags
- LargeSampleSkew
- SpecialPollInterval
- Type

.NOTES
Author: Your Name
Date:   Current Date
#>

function Get-W32TimeConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $w32tmOutput = w32tm /query /configuration /computer:$ComputerName
    } catch {
        Write-Error "Failed to run w32tm command: $_"
        return
    }

    $outputLines = $w32tmOutput -split "`n"

    $outputObject = New-Object PSObject

    $outputObject | Add-Member -NotePropertyName "ComputerName" -NotePropertyValue $ComputerName

    $headings = @{
        "EventLogFlags" = "EventLogFlags";
        "AnnounceFlags" = "AnnounceFlags";
        "TimeJumpAuditOffset" = "TimeJumpAuditOffset";
        "MinPollInterval" = "MinPollInterval";
        "MaxPollInterval" = "MaxPollInterval";
        "MaxNegPhaseCorrection" = "MaxNegPhaseCorrection";
        "MaxPosPhaseCorrection" = "MaxPosPhaseCorrection";
        "MaxAllowedPhaseOffset" = "MaxAllowedPhaseOffset";
        "FrequencyCorrectRate" = "FrequencyCorrectRate";
        "PollAdjustFactor" = "PollAdjustFactor";
        "LargePhaseOffset" = "LargePhaseOffset";
        "SpikeWatchPeriod" = "SpikeWatchPeriod";
        "LocalClockDispersion" = "LocalClockDispersion";
        "HoldPeriod" = "HoldPeriod";
        "PhaseCorrectRate" = "PhaseCorrectRate";
        "UpdateInterval" = "UpdateInterval";
        "DllName" = "DllName";
        "Enabled" = "Enabled";
        "InputProvider" = "InputProvider";
        "CrossSiteSyncFlags" = "CrossSiteSyncFlags";
        "AllowNonstandardModeCombinations" = "AllowNonstandardModeCombinations";
        "ResolvePeerBackoffMinutes" = "ResolvePeerBackoffMinutes";
        "ResolvePeerBackoffMaxTimes" = "ResolvePeerBackoffMaxTimes";
        "CompatibilityFlags" = "CompatibilityFlags";
        "LargeSampleSkew" = "LargeSampleSkew";
        "SpecialPollInterval" = "SpecialPollInterval";
        "Type" = "Type"
    }

    foreach ($line in $outputLines) {
        foreach ($heading in $headings.Keys) {
            if ($line -match "$($heading):\s(.*)") {
                if (!($outputObject | Get-Member -Name $headings[$heading])) {
                    $outputObject | Add-Member -NotePropertyName $headings[$heading] -NotePropertyValue $Matches[1]
                }
                break
            }
        }
    }

    return $outputObject
}