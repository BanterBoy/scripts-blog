---
layout: post
title: Get-DayOfWeek.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-DayOfWeek/
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

Returns the current day of the week, a random day, or a shuffled list of all days.

#### Detailed Description

This function generates the current day of the week by default. If the `-Random` switch is provided, it returns a single random day. If the `-ShuffleList` switch is provided, it returns a shuffled list of all days.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DayOfWeek
```

Returns the current day of the week, e.g., "Wednesday".

**Example 2**

```powershell
Get-DayOfWeek -Random
```

Returns a single random day of the week, e.g., "Monday".

**Example 3**

```powershell
Get-DayOfWeek -ShuffleList
```

Returns a shuffled list of all days of the week, e.g., "Friday", "Monday", "Sunday", etc.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Version: 1.1 This function uses the `Get-Random` cmdlet with the `-Shuffle` parameter for shuffling.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Returns the current day of the week, a random day, or a shuffled list of all days.

.DESCRIPTION
    This function generates the current day of the week by default. If the `-Random` switch is provided, 
    it returns a single random day. If the `-ShuffleList` switch is provided, it returns a shuffled list 
    of all days.

.PARAMETER ShuffleList
    If specified, the function returns a shuffled list of all days of the week.

.PARAMETER Random
    If specified, the function returns a single random day of the week.

.EXAMPLE
    Get-DayOfWeek
    Returns the current day of the week, e.g., "Wednesday".

.EXAMPLE
    Get-DayOfWeek -Random
    Returns a single random day of the week, e.g., "Monday".

.EXAMPLE
    Get-DayOfWeek -ShuffleList
    Returns a shuffled list of all days of the week, e.g., "Friday", "Monday", "Sunday", etc.

.NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Version: 1.1
    This function uses the `Get-Random` cmdlet with the `-Shuffle` parameter for shuffling.

#>
function Get-DayOfWeek {
    [CmdletBinding()]
    param (
        [switch]$ShuffleList,
        [switch]$Random
    )

    # Define the days of the week
    $daysOfWeek = @("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

    if ($ShuffleList) {
        # Use the -Shuffle parameter to shuffle the list
        return $daysOfWeek | Get-Random -Shuffle
    }
    elseif ($Random) {
        # Return a single random day
        return Get-Random -InputObject $daysOfWeek
    }
    else {
        # Return the current day of the week
        return (Get-Date).DayOfWeek
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-DayOfWeek.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DayOfWeek.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

