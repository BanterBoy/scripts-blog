---
layout: post
title: Get-W32TimeConfiguration.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/get-w32timeconfiguration/
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

Retrieves the W32Time configuration for a specified computer.

#### Detailed Description

The Get-W32TimeConfiguration function retrieves the W32Time configuration for a specified computer. It uses the w32tm command-line tool to query the configuration and parses the output to create a custom PSObject with the configuration properties.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-W32TimeConfiguration -ComputerName "Server01"
```

Retrieves the W32Time configuration for the computer named "Server01".

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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-W32TimeConfiguration.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-W32TimeConfiguration.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

