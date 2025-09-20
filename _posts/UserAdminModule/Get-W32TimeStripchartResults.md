---
layout: post
title: Get-W32TimeStripchartResults.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-W32TimeStripchartResults/
categories:
  - UserAdminModule
  - Utilities
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Retrieves the W32Time stripchart results for a specified computer.

#### Detailed Description

The Get-W32TimeStripchartResults function retrieves the W32Time stripchart results for a specified computer. It uses the w32tm command to get the output and then parses the output to extract relevant information such as leap indicator, version number, mode, stratum, etc. The function returns a PSObject containing the extracted information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-W32TimeStripchartResults -ComputerName "Server01"
```

Retrieves the W32Time stripchart results for the computer named "Server01".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-W32TimeStripchartResults.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-W32TimeStripchartResults.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

