---
layout: post
title: Get-BankHolidays.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-BankHolidays/
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

Retrieves bank holidays for the UK regions (England and Wales, Scotland, or Northern Ireland).

#### Detailed Description

This function fetches bank holiday data from the UK Government API and returns a list of holidays for the selected region. It also provides options to filter holidays by year or to retrieve the next upcoming holiday.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-BankHolidays -Region EnglandAndWales
```

Retrieves all bank holidays for England and Wales.

**Example 2**

```powershell
Get-BankHolidays -Region Scotland -NextUpcoming
```

Retrieves the next upcoming bank holiday for Scotland.

**Example 3**

```powershell
Get-BankHolidays -Region NorthernIreland -Year 2025
```

Retrieves bank holidays for Northern Ireland in the year 2025.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Version: 1.1 Source: https://www.gov.uk/bank-holidays.json

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
        Retrieves bank holidays for the UK regions (England and Wales, Scotland, or Northern Ireland).
    
    .DESCRIPTION
        This function fetches bank holiday data from the UK Government API and returns a list of holidays for the selected region.
        It also provides options to filter holidays by year or to retrieve the next upcoming holiday.
    
    .PARAMETER Region
        Specifies the UK region for which to retrieve bank holidays.
        Valid options are "EnglandAndWales", "Scotland", and "NorthernIreland".

    .PARAMETER NextUpcoming
        If specified, the function returns only the next upcoming bank holiday for the selected region.

    .PARAMETER Year
        If specified, the function filters and returns only bank holidays that occur in the given year.

    .EXAMPLE
        Get-BankHolidays -Region EnglandAndWales
        Retrieves all bank holidays for England and Wales.
    
    .EXAMPLE
        Get-BankHolidays -Region Scotland -NextUpcoming
        Retrieves the next upcoming bank holiday for Scotland.
    
    .EXAMPLE
        Get-BankHolidays -Region NorthernIreland -Year 2025
        Retrieves bank holidays for Northern Ireland in the year 2025.
    
    .NOTES
        Author: Luke Leigh
        Version: 1.1
        Source: https://www.gov.uk/bank-holidays.json
#>

function Get-BankHolidays {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("EnglandAndWales", "Scotland", "NorthernIreland")]
        [string]$Region = "EnglandAndWales",

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [switch]$NextUpcoming,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1900, 2100)]
        [int]$Year
    )
    
    begin {
        $url = "https://www.gov.uk/bank-holidays.json"
    }
    
    process {
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            
            if (-not $response) {
                Write-Error "Failed to retrieve bank holiday data."
                return
            }

            $bankHolidays = [BankHolidays]::new()

            $bankHolidays.englandAndWales = [EnglandAndWales]::new()
            $bankHolidays.englandAndWales.division = "england-and-wales"
            $bankHolidays.englandAndWales.events = $response."england-and-wales".events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $bankHolidays.scotland = [Scotland]::new()
            $bankHolidays.scotland.division = "scotland"
            $bankHolidays.scotland.events = $response.scotland.events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $bankHolidays.northernIreland = [NorthernIreland]::new()
            $bankHolidays.northernIreland.division = "northern-ireland"
            $bankHolidays.northernIreland.events = $response."northern-ireland".events | ForEach-Object {
                $holidayEvent = [Event]::new()
                $holidayEvent.title = $_.title
                $holidayEvent.date = (Get-Date $_.date -Format "dd/MM/yyyy")
                $holidayEvent.notes = $_.notes
                $holidayEvent.bunting = $_.bunting
                $holidayEvent | Add-Member -MemberType NoteProperty -Name "HasPassed" -Value ($(Get-Date $_.date) -lt (Get-Date)) -PassThru
            }
            
            $events = switch ($Region) {
                "EnglandAndWales" { $bankHolidays.englandAndWales.events }
                "Scotland" { $bankHolidays.scotland.events }
                "NorthernIreland" { $bankHolidays.northernIreland.events }
            }
            
            if ($Year) {
                $events = $events | Where-Object { (Get-Date $_.date -Format "yyyy") -eq $Year }
            }

            if ($NextUpcoming) {
                $today = (Get-Date).ToString("yyyy-MM-dd")
                $upcomingHoliday = $events | Where-Object { $_.date -gt $today } | Sort-Object date | Select-Object -First 1
                return $upcomingHoliday
            }
            
            return $events
        }
        catch {
            Write-Error "Error retrieving data: $_"
        }
    }
}

class Event {
    [string] $title
    [string] $date
    [string] $notes
    [bool] $bunting
}

class EnglandAndWales {
    [string] $division
    [Event[]] $events
}

class Scotland {
    [string] $division
    [Event[]] $events
}

class NorthernIreland {
    [string] $division
    [Event[]] $events
}

class BankHolidays {
    [EnglandAndWales] $englandAndWales
    [Scotland] $scotland
    [NorthernIreland] $northernIreland
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-BankHolidays.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-BankHolidays.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

