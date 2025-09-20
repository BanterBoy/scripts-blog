---
layout: post
title: Get-LastxOfMonth.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-LastxOfMonth/
categories:
- UserAdminModule
- Shell
tags:
- PowerShell
- User Admin Module
- Lastx Of Month
description: Retrieves the last occurrence of a specified day of the week or date
  in a given month and year.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Retrieves the last occurrence of a specified day of the week or date in a given month and year.

#### Detailed Description

This function can find the last occurrence of a specified day of the week (e.g., Tuesday) or a specified date (e.g., the 15th) in a given month and year.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LastxOfMonth -Day Tuesday -MonthNum 1 -Year 2024
```

Retrieves the last Tuesday of January 2024.

**Example 2**

```powershell
Get-LastxOfMonth -DayNum 15 -Month February -Year 2024
```

Retrieves the last occurrence of the 15th in February 2024 and returns the day of the week.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-LastxOfMonth {
    <#
    .SYNOPSIS
        Retrieves the last occurrence of a specified day of the week or date in a given month and year.

    .DESCRIPTION
        This function can find the last occurrence of a specified day of the week (e.g., Tuesday) or a specified date (e.g., the 15th) in a given month and year.

    .PARAMETER DayNum
        The date (1-31) to find the last occurrence of.

    .PARAMETER Day
        The day of the week (e.g., Sunday, Monday, Tuesday, etc.) to find the last occurrence of.

    .PARAMETER MonthNum
        The month number (1-12) for which to find the last occurrence.

    .PARAMETER Month
        The month name (e.g., January, February, etc.) for which to find the last occurrence.

    .PARAMETER Year
        The year for which to find the last occurrence.

    .EXAMPLE
        Get-LastxOfMonth -Day Tuesday -MonthNum 1 -Year 2024
        Retrieves the last Tuesday of January 2024.

    .EXAMPLE
        Get-LastxOfMonth -DayNum 15 -Month February -Year 2024
        Retrieves the last occurrence of the 15th in February 2024 and returns the day of the week.

    .NOTES
        Author: Luke Leigh
    #>

    [CmdletBinding(DefaultParameterSetName = 'DayOfWeekSet')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'DayOfMonthSet', HelpMessage = 'Enter the date (1-31)')]
        [ValidateRange(1, 31)]
        [int]$DayNum,

        [Parameter(Mandatory = $false, ParameterSetName = 'DayOfWeekSet', HelpMessage = 'Enter the day of the week (Sunday, Monday, etc.)')]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [string]$Day,

        [Parameter(Mandatory = $false, HelpMessage = 'Enter the month number (1-12)')]
        [ValidateRange(1, 12)]
        [int]$MonthNum,

        [Parameter(Mandatory = $false, HelpMessage = 'Enter the month name (January, February, etc.)')]
        [ValidateSet('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')]
        [string]$Month,

        [Parameter(Mandatory = $true, HelpMessage = 'Enter the year')]
        [ValidateRange(1, 9999)]
        [int]$Year
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('MonthNum') -and -not $PSBoundParameters.ContainsKey('Month')) {
            throw "You must specify either the MonthNum or Month parameter."
        }
        if ($PSBoundParameters.ContainsKey('Month')) {
            $MonthNum = [datetime]::ParseExact($Month, 'MMMM', [System.Globalization.CultureInfo]::InvariantCulture).Month
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('Day')) {
            $lastDayOfMonth = [datetime]::new($Year, $MonthNum, [datetime]::DaysInMonth($Year, $MonthNum))
            while ($lastDayOfMonth.DayOfWeek -ne [System.DayOfWeek]::$Day) {
                $lastDayOfMonth = $lastDayOfMonth.AddDays(-1)
            }
            return $lastDayOfMonth.ToString('dd MMMM yyyy')
        }
        elseif ($PSBoundParameters.ContainsKey('DayNum')) {
            $lastDayOfMonth = [datetime]::new($Year, $MonthNum, [datetime]::DaysInMonth($Year, $MonthNum))
            if ($DayNum -gt $lastDayOfMonth.Day) {
                throw "The specified day exceeds the number of days in the specified month."
            }
            return ([datetime]::new($Year, $MonthNum, $DayNum)).DayOfWeek.ToString()
        }
    }
}

# Example usage:
# Get-LastxOfMonth -Day Tuesday -MonthNum 1 -Year 2024
# Get-LastxOfMonth -DayNum 15 -Month February -Year 2024
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-LastxOfMonth.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastxOfMonth.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

