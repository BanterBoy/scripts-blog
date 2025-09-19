<#
.SYNOPSIS
    Retrieves the W32Time stripchart results for a specified computer.

.DESCRIPTION
    The Get-W32TimeStripchartResults function retrieves the W32Time stripchart results for a specified computer. It uses the w32tm command to get the output and then parses the output to extract relevant information such as leap indicator, version number, mode, stratum, etc. The function returns a PSObject containing the extracted information.

.PARAMETER ComputerName
    Specifies the name of the computer for which to retrieve the W32Time stripchart results.

.EXAMPLE
    Get-W32TimeStripchartResults -ComputerName "Server01"
    Retrieves the W32Time stripchart results for the computer named "Server01".

.INPUTS
    None. You cannot pipe input to this function.

.OUTPUTS
    System.Management.Automation.PSObject
    The function returns a PSObject containing the W32Time stripchart results.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-W32TimeStripchartResults {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName
    )

    try {
        $w32tmOutput = w32tm /stripchart /computer:$ComputerName /packetinfo /samples:1
    } catch {
        Write-Error "Failed to run w32tm command: $_"
        return
    }

    # Parse the w32tm output
    $parsedOutput = $w32tmOutput -split '\r?\n' | ForEach-Object {
        if ($_ -match 'Leap Indicator: (.*)') { $leapIndicator = $matches[1] }
        if ($_ -match 'Version Number: (.*)') { $versionNumber = $matches[1] }
        if ($_ -match 'Mode: (.*)') { $mode = $matches[1] }
        if ($_ -match 'Stratum: (.*)') { $stratum = $matches[1] }
        if ($_ -match 'Poll Interval: (.*)') { $pollInterval = $matches[1] }
        if ($_ -match 'Precision: (.*)') { $precision = $matches[1] }
        if ($_ -match 'Root Delay: (.*)') { $rootDelay = $matches[1] }
        if ($_ -match 'Root Dispersion: (.*)') { $rootDispersion = $matches[1] }
        if ($_ -match 'ReferenceId: (.*)') { $referenceId = $matches[1] }
        if ($_ -match 'Reference Timestamp: (.*)') { $referenceTimestamp = $matches[1] }
        if ($_ -match 'Originate Timestamp: (.*)') { $originateTimestamp = $matches[1] }
        if ($_ -match 'Receive Timestamp: (.*)') { $receiveTimestamp = $matches[1] }
        if ($_ -match 'Transmit Timestamp: (.*)') { $transmitTimestamp = $matches[1] }
        if ($_ -match 'Destination Timestamp: (.*)') { $destinationTimestamp = $matches[1] }
        if ($_ -match 'Roundtrip Delay: (.*)') { $roundtripDelay = $matches[1] }
        if ($_ -match 'Local Clock Offset: (.*)') { $localClockOffset = $matches[1] }
    }

    # Create a PSObject to store the output
    $outputObject = New-Object PSObject
    $outputObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $ComputerName
    $outputObject | Add-Member -MemberType NoteProperty -Name "LeapIndicator" -Value $leapIndicator
    $outputObject | Add-Member -MemberType NoteProperty -Name "VersionNumber" -Value $versionNumber
    $outputObject | Add-Member -MemberType NoteProperty -Name "Mode" -Value $mode
    $outputObject | Add-Member -MemberType NoteProperty -Name "Stratum" -Value $stratum
    $outputObject | Add-Member -MemberType NoteProperty -Name "PollInterval" -Value $pollInterval
    $outputObject | Add-Member -MemberType NoteProperty -Name "Precision" -Value $precision
    $outputObject | Add-Member -MemberType NoteProperty -Name "RootDelay" -Value $rootDelay
    $outputObject | Add-Member -MemberType NoteProperty -Name "RootDispersion" -Value $rootDispersion
    $outputObject | Add-Member -MemberType NoteProperty -Name "ReferenceId" -Value $referenceId
    $outputObject | Add-Member -MemberType NoteProperty -Name "ReferenceTimestamp" -Value $referenceTimestamp
    $outputObject | Add-Member -MemberType NoteProperty -Name "OriginateTimestamp" -Value $originateTimestamp
    $outputObject | Add-Member -MemberType NoteProperty -Name "ReceiveTimestamp" -Value $receiveTimestamp
    $outputObject | Add-Member -MemberType NoteProperty -Name "TransmitTimestamp" -Value $transmitTimestamp
    $outputObject | Add-Member -MemberType NoteProperty -Name "DestinationTimestamp" -Value $destinationTimestamp
    $outputObject | Add-Member -MemberType NoteProperty -Name "RoundtripDelay" -Value $roundtripDelay
    $outputObject | Add-Member -MemberType NoteProperty -Name "LocalClockOffset" -Value $localClockOffset

    return $outputObject
}