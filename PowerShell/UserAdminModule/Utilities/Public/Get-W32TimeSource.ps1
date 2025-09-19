<#
.SYNOPSIS
Retrieves detailed information about the Windows Time service (w32time) on a specified computer.

.DESCRIPTION
The Get-W32TimeSource function retrieves detailed information about the Windows Time service (w32time) on a specified computer. It uses the w32tm command to query the status and verbose information of the Windows Time service.

.PARAMETER ComputerName
Specifies the name of the computer to retrieve the Windows Time service information from. If not specified, the local computer name is used.

.EXAMPLE
Get-W32TimeSource -ComputerName "Server01"
Retrieves the Windows Time service information from the remote computer named "Server01".

.EXAMPLE
Get-W32TimeSource
Retrieves the Windows Time service information from the local computer.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject
The function returns a PSObject containing the following properties:
- ComputerName: The name of the computer from which the information is retrieved.
- LeapIndicator: The leap indicator value.
- Stratum: The stratum value.
- Precision: The precision value.
- RootDelay: The root delay value.
- RootDispersion: The root dispersion value.
- ReferenceId: The reference ID value.
- LastSuccessfulSyncTime: The last successful synchronization time.
- Source: The time source.
- PollInterval: The poll interval value.
- PhaseOffset: The phase offset value.
- ClockRate: The clock rate value.
- StateMachine: The state machine value.
- TimeSourceFlags: The time source flags.
- ServerRole: The server role.
- LastSyncError: The last synchronization error.
- TimeSinceLastGoodSyncTime: The time since the last good synchronization time.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0
#>
function Get-W32TimeSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $w32tmOutput = w32tm /query /status /verbose /computer:$ComputerName
    } catch {
        Write-Error "Failed to run w32tm command: $_"
        return
    }

    $outputLines = $w32tmOutput -split "`n"

    $outputObject = New-Object PSObject

    $outputObject | Add-Member -NotePropertyName "ComputerName" -NotePropertyValue $ComputerName

    $headings = @{
        "Leap Indicator" = "LeapIndicator";
        "Stratum" = "Stratum";
        "Precision" = "Precision";
        "Root Delay" = "RootDelay";
        "Root Dispersion" = "RootDispersion";
        "ReferenceId" = "ReferenceId";
        "Last Successful Sync Time" = "LastSuccessfulSyncTime";
        "Source" = "Source";
        "Poll Interval" = "PollInterval";
        "Phase Offset" = "PhaseOffset";
        "ClockRate" = "ClockRate";
        "State Machine" = "StateMachine";
        "Time Source Flags" = "TimeSourceFlags";
        "Server Role" = "ServerRole";
        "Last Sync Error" = "LastSyncError";
        "Time since Last Good Sync Time" = "TimeSinceLastGoodSyncTime"
    }

    foreach ($line in $outputLines) {
        foreach ($heading in $headings.Keys) {
            if ($line -match "$($heading):\s(.*)") {
                $outputObject | Add-Member -NotePropertyName $headings[$heading] -NotePropertyValue $Matches[1]
                break
            }
        }
    }

    return $outputObject
}