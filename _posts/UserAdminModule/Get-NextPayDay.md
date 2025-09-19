---
layout: post
title: Get-NextPayDay.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-NextPayDay/
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

Retrieves the next payday from a CSV file.

#### Detailed Description

The Get-NextPayDay function reads a CSV file containing a list of payday dates and returns the next upcoming payday.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-NextPayDay
```

This example retrieves the next payday from the PayDays.csv file and returns the corresponding countdown date.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves the next payday from a CSV file.

.DESCRIPTION
    The Get-NextPayDay function reads a CSV file containing a list of payday dates and returns the next upcoming payday.

.PARAMETER None

.INPUTS
    None

.OUTPUTS
    A custom object representing the next payday, including the number of days left until that payday.

.EXAMPLE
    Get-NextPayDay

    This example retrieves the next payday from the PayDays.csv file and returns the corresponding countdown date.

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Get-NextPayDay {
    $PayDays = Get-Content -Raw -Path $PSScriptRoot\resources\PayDays.csv | ConvertFrom-Csv
    $PayDays | ForEach-Object -Process { New-CountdownDate -CountdownDay $_.PayDay } | Where-Object -FilterScript { $_.DaysLeft -notlike '-*' } | Select-Object -First 1
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-NextPayDay.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-NextPayDay.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

