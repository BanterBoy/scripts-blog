---
layout: post
title: Test-RemoteTimeSettings.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/testing/test-remotetimesettings/
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

Tests the time settings on remote computers.

#### Detailed Description

The Test-RemoteTimeSettings function is used to test the time settings on multiple remote computers. It checks the time configuration, time source, time status, and performs a stripchart to monitor time synchronization.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$computers = @("RemotePC1", "RemotePC2", "RemotePC3")
```

$testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10 # Display results $testResults | Format-Table -Property ComputerName, Success, ErrorMessage

**Example 2**

```powershell
$computers = @("RemotePC1", "RemotePC2", "RemotePC3")
```

$testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10 # Display detailed results $testResults | Format-List

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Tests the time settings on remote computers.

.DESCRIPTION
    The Test-RemoteTimeSettings function is used to test the time settings on multiple remote computers. It checks the time configuration, time source, time status, and performs a stripchart to monitor time synchronization.

.PARAMETER ComputerNames
    Specifies an array of computer names on which the time settings need to be tested.

.PARAMETER Duration
    Specifies the duration (in seconds) for which the stripchart will be monitored. The default value is 60 seconds.

.PARAMETER Interval
    Specifies the interval (in seconds) between each stripchart sample. The default value is 5 seconds.

.EXAMPLE
    $computers = @("RemotePC1", "RemotePC2", "RemotePC3")
    $testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10

    # Display results
    $testResults | Format-Table -Property ComputerName, Success, ErrorMessage

.EXAMPLE
    $computers = @("RemotePC1", "RemotePC2", "RemotePC3")
    $testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10

    # Display detailed results
    $testResults | Format-List
#>

#requires -PSEdition Desktop
function Test-RemoteTimeSettings {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerNames,
        
        [Parameter(Mandatory = $false)]
        [int]$Duration = 60,

        [Parameter(Mandatory = $false)]
        [int]$Interval = 5
    )

    function Get-TimeSettings {
        param (
            [string]$ComputerName,
            [int]$Duration,
            [int]$Interval
        )
        
        $result = [PSCustomObject]@{
            ComputerName  = $ComputerName
            TimeConfig    = $null
            TimeSource    = $null
            TimeStatus    = $null
            Stripchart    = @()
            Success       = $true
            ErrorMessage  = $null
        }

        try {
            # Checking time configuration
            $result.TimeConfig = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /configuration
            }

            # Checking time source
            $result.TimeSource = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /source
            }

            # Checking time status
            $result.TimeStatus = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /status
            }

            # Using stripchart to monitor time synchronization
            $stripchartResults = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param ($Duration, $Interval)
                $end = (Get-Date).AddSeconds($Duration)
                $results = @()

                while ((Get-Date) -lt $end) {
                    $result = w32tm /stripchart /computer:localhost /dataonly /samples:1
                    $results += $result
                    Start-Sleep -Seconds $Interval
                }
                return $results
            } -ArgumentList $Duration, $Interval

            $result.Stripchart = $stripchartResults

        } catch {
            $result.Success = $false
            $result.ErrorMessage = $_.Exception.Message
        }

        return $result
    }

    $results = @()
    $totalComputers = $ComputerNames.Count
    $currentIndex = 0

    foreach ($computer in $ComputerNames) {
        $currentIndex++
        Write-Progress -Activity "Testing time settings on remote computers" -Status "Processing $computer" -PercentComplete (($currentIndex / $totalComputers) * 100)
        $results += Get-TimeSettings -ComputerName $computer -Duration $Duration -Interval $Interval
    }

    Write-Progress -Activity "Testing time settings on remote computers" -Status "Completed" -PercentComplete 100 -Completed

    return $results
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-RemoteTimeSettings.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-RemoteTimeSettings.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

