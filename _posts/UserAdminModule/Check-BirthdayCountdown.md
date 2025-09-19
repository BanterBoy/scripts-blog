---
layout: post
title: Check-BirthdayCountdown.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Check-BirthdayCountdown/
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

Checks the number of days until a person's birthday.

#### Detailed Description

The Check-BirthdayCountdown function calculates the number of days until a person's birthday based on their date of birth (DOB) provided in a CSV file. It then checks if the birthday is within the next 14 days and outputs a message accordingly.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Check-BirthdayCountdown -CsvPath "C:\Path\To\Birthdays.csv"
```

Calculates the number of days until each person's birthday in the specified CSV file and outputs a message if the birthday is within the next 14 days.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires PowerShell version 3.0 or above.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Checks the number of days until a person's birthday.

.DESCRIPTION
The Check-BirthdayCountdown function calculates the number of days until a person's birthday based on their date of birth (DOB) provided in a CSV file. It then checks if the birthday is within the next 14 days and outputs a message accordingly.

.PARAMETER CsvPath
The path to the CSV file containing the list of people and their DOBs.

.PARAMETER ShowAll
If specified, the function will output the number of days until or since each person's birthday, regardless of whether it is within the next 14 days.

.PARAMETER ShowNext
If specified, the function will output the next upcoming birthday and the number of days until it occurs.

.EXAMPLE
Check-BirthdayCountdown -CsvPath "C:\Path\To\Birthdays.csv"
Calculates the number of days until each person's birthday in the specified CSV file and outputs a message if the birthday is within the next 14 days.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.String. The function outputs a message indicating the number of days until each person's birthday if it is within the next 14 days.

.NOTES
This function requires PowerShell version 3.0 or above.

.LINK
https://github.com/your-repo/Check-BirthdayCountdown.ps1
#>
function Check-BirthdayCountdown {
    param (
        [string]$CsvPath,
        [switch]$ShowAll,
        [switch]$ShowNext
    )

    # Import the CSV file
    $birthdays = Import-Csv -Path $CsvPath

    # Get today's date
    $today = Get-Date

    $results = @()
    $nextBirthday = $null
    $minDaysUntilBirthday = [int]::MaxValue

    foreach ($person in $birthdays) {
        # Extract the day and month from the DOB
        $dob = [datetime]::ParseExact($person.DOB, 'dd/MM/yyyy', $null)
        $dobDay = $dob.Day
        $dobMonth = $dob.Month

        # Create a new date for this year's birthday
        $birthdayThisYear = Get-Date -Year $today.Year -Month $dobMonth -Day $dobDay

        # Calculate the difference in days between today and the birthday
        $daysUntilBirthday = ($birthdayThisYear - $today).Days

        if ($ShowAll) {
            $status = if ($daysUntilBirthday -ge 0) { "will pass in $daysUntilBirthday days" } else { "passed $(-$daysUntilBirthday) days ago" }
            $results += [pscustomobject]@{
                Forename = $person.Forename
                Surname  = $person.Surname
                DOB      = $person.DOB
                Status   = $status
            }
        }
        else {
            # Check if the birthday is within the next 14 days
            if ($daysUntilBirthday -le 14 -and $daysUntilBirthday -ge 0) {
                if ($daysUntilBirthday -eq 0) {
                    Write-Output "Happy Birthday, $($person.Forename) $($person.Surname)!"
                }
                else {
                    Write-Output "$($person.Forename) $($person.Surname)'s birthday is in $daysUntilBirthday days!"
                }
            }
        }

        if ($ShowNext -and $daysUntilBirthday -ge 0 -and $daysUntilBirthday -lt $minDaysUntilBirthday) {
            $minDaysUntilBirthday = $daysUntilBirthday
            $nextBirthday = [pscustomobject]@{
                Forename          = $person.Forename
                Surname           = $person.Surname
                DOB               = $person.DOB
                DaysUntilBirthday = $daysUntilBirthday
            }
        }
    }

    if ($ShowAll) {
        return $results
    }

    if ($ShowNext -and $nextBirthday) {
        Write-Output "The next upcoming birthday is $($nextBirthday.Forename) $($nextBirthday.Surname)'s in $($nextBirthday.DaysUntilBirthday) days."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Check-BirthdayCountdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Check-BirthdayCountdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

