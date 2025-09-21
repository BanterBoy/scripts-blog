---
layout: post
title: Get-PatchTue.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/get-patchtue/
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

Gets the Patch Tuesday date of a specified month and year.

#### Detailed Description

This function calculates and returns the date of Patch Tuesday for a given month and year. Patch Tuesday is the second Tuesday of each month when Microsoft releases updates for its software products.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-PatchTue -Month 6 -Year 2015
```

Returns the date of Patch Tuesday in June 2015.

**Example 2**

```powershell
Get-PatchTue -Month June -Year 2015
```

Returns the date of Patch Tuesday in June 2015.

**Example 3**

```powershell
Get-PatchTue
```

Returns the date of Patch Tuesday for the current month and year.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function uses the current date if no month and year are specified.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-PatchTue {
	<#
    .SYNOPSIS
        Gets the Patch Tuesday date of a specified month and year.

    .DESCRIPTION
        This function calculates and returns the date of Patch Tuesday for a given month and year. Patch Tuesday is the second Tuesday of each month when Microsoft releases updates for its software products.

    .PARAMETER Month
        The month for which to calculate Patch Tuesday. Defaults to the current month if not specified.

    .PARAMETER Year
        The year for which to calculate Patch Tuesday. Defaults to the current year if not specified.

    .EXAMPLE
        Get-PatchTue -Month 6 -Year 2015
        Returns the date of Patch Tuesday in June 2015.

    .EXAMPLE
        Get-PatchTue -Month June -Year 2015
        Returns the date of Patch Tuesday in June 2015.

    .EXAMPLE
        Get-PatchTue
        Returns the date of Patch Tuesday for the current month and year.

    .NOTES
        This function uses the current date if no month and year are specified.

    .LINK
        https://docs.microsoft.com/en-us/windows/release-information/
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[ValidateSet("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")]
		[string]$Month = (Get-Date).Month.ToString(),

		[Parameter(Mandatory = $false)]
		[ValidatePattern('^\d{4}$')]
		[int]$Year = (Get-Date).Year
	)

	Begin {
		# Convert the month name to a number if necessary
		if ($Month -match '^\D+$') {
			$MonthNumber = [datetime]::ParseExact($Month, 'MMMM', [cultureinfo]::CurrentCulture).Month
		}
		else {
			$MonthNumber = [int]$Month
		}

		# Ensure the month number is valid
		if ($MonthNumber -lt 1 -or $MonthNumber -gt 12) {
			throw "Invalid month value: $Month. Please provide a month between 1 and 12 or the full month name."
		}
	}

	Process {
		# Get the first day of the specified month and year
		$firstDayOfMonth = Get-Date -Year $Year -Month $MonthNumber -Day 1

		# Calculate Patch Tuesday (second Tuesday of the month)
		$patchTuesday = 1..31 | ForEach-Object {
			$currentDate = $firstDayOfMonth.AddDays($_ - 1)
			if ($currentDate.Month -eq $MonthNumber -and $currentDate.DayOfWeek -eq [DayOfWeek]::Tuesday) {
				$currentDate
			}
		} | Select-Object -Index 1

		# Output the Patch Tuesday date
		$patchTuesday
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-PatchTue.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PatchTue.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

