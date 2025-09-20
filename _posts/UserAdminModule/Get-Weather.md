---
layout: post
title: Get-Weather.ps1
date: 2025-09-19
permalink: /useradminmodule/weather/get-weather/
categories:
  - UserAdminModule
  - Weather
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

Get the weather information for a specific city.

#### Detailed Description

The Get-Weather function retrieves the current weather information for a specified city using the wttr.in service.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-Weather -City 'Southend-on-Sea'
```

Retrieves the weather information for the city of Southend-on-Sea.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires an internet connection to retrieve the weather information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-Weather {
    <#
    .SYNOPSIS
    Get the weather information for a specific city.

    .DESCRIPTION
    The Get-Weather function retrieves the current weather information for a specified city using the wttr.in service.

    .PARAMETER City
    The name of the city for which to retrieve the weather information.

    .EXAMPLE
    Get-Weather -City 'Southend-on-Sea'
    Retrieves the weather information for the city of Southend-on-Sea.

    .NOTES
    This function requires an internet connection to retrieve the weather information.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$City
    )

    Begin {
        $Protocols = [Net.SecurityProtocolType]::Tls12
        [Net.ServicePointManager]::SecurityProtocol = $Protocols
    }

    Process {
        try {
            $Weather = Invoke-RestMethod -Uri "http://wttr.in/$City" -ErrorAction Stop
            if ($Weather) {
                Write-Output $Weather
            }
            else {
                Write-Warning "No weather information found for city: $City"
            }
        }
        catch {
            Write-Error "Failed to retrieve weather information for city: $City. Error: $_"
        }
    }

    End {}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Weather/Public/Get-Weather.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Weather.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

