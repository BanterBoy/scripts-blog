---
layout: post
title: New-CountdownDate.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-CountdownDate/
categories:
  - UserAdminModule
  - Shell
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

Creates a CountdownDate object and calculates the days left until the specified countdown date.

#### Detailed Description

The CountdownDate class represents a countdown date and provides a method to calculate the days left until the countdown date. The New-CountdownDate function creates a CountdownDate object and returns the countdown information.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> New-CountdownDate -CountdownDay "25/12/2022"
```

Returns the days left until Christmas Day (25th December 2022).

**Example 2**

```powershell
PS C:\> New-CountdownDate -DaysUntilCountdown 30
```

Returns the days left until 30 days from the current date.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Creates a CountdownDate object and calculates the days left until the specified countdown date.

.DESCRIPTION
    The CountdownDate class represents a countdown date and provides a method to calculate the days left until the countdown date.
    The New-CountdownDate function creates a CountdownDate object and returns the countdown information.

.PARAMETER CountdownDay
    Specifies the countdown date as a string in the format "dd/MM/yyyy" or as a DateTime object.
    Either CountdownDay or DaysUntilCountdown must be specified.

.PARAMETER DaysUntilCountdown
    Specifies the number of days until the countdown date.
    Either CountdownDay or DaysUntilCountdown must be specified.

.OUTPUTS
    Returns a PSObject with the following properties:
    - CurrentDate: The current date in the format "dd/MM/yyyy".
    - CountdownDate: The countdown date in the format "dd/MM/yyyy".
    - CountdownDay: The countdown day of the week and month in the format "dddd dd MMMM".
    - DaysLeft: The number of days left until the countdown date.

.EXAMPLE
    PS C:\> New-CountdownDate -CountdownDay "25/12/2022"
    Returns the days left until Christmas Day (25th December 2022).

.EXAMPLE
    PS C:\> New-CountdownDate -DaysUntilCountdown 30
    Returns the days left until 30 days from the current date.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

class CountdownDate {
    [string]$CountdownDay
    [int]$DaysUntilCountdown

    CountdownDate([string]$CountdownDay, [int]$DaysUntilCountdown) {
        $this.CountdownDay = $CountdownDay
        $this.DaysUntilCountdown = $DaysUntilCountdown
    }

    [PSObject]GetCountdown() {
        if ($this.CountdownDay) {
            try {
                $CountdownDate = [datetime]::ParseExact($this.CountdownDay, "dd/MM/yyyy", $null)
            }
            catch {
                $CountdownDate = [datetime]$this.CountdownDay
            }
        }
        elseif ($this.DaysUntilCountdown) {
            $CountdownDate = (Get-Date).AddDays($this.DaysUntilCountdown)
        }
        else {
            throw "Please specify either CountdownDay or DaysUntilCountdown"
        }

        $Today = Get-Date
        $DaysLeft = New-TimeSpan -Start $Today -End $CountdownDate

        $output = New-Object PSObject
        $output | Add-Member -MemberType NoteProperty -Name "CurrentDate" -Value $Today.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDate" -Value $CountdownDate.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDay" -Value $CountdownDate.ToString("dddd dd MMMM")
        $output | Add-Member -MemberType NoteProperty -Name "DaysLeft" -Value "$($DaysLeft.Days) Days"

        return $output
    }
}

function New-CountdownDate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$CountdownDay,
        [Parameter(Mandatory = $false)]
        [int]$DaysUntilCountdown
    )

    try {
        $countdown = [CountdownDate]::new($CountdownDay, $DaysUntilCountdown)
        return $countdown.GetCountdown()
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-CountdownDate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-CountdownDate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

