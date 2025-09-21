---
layout: post
title: Get-AdminURL.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/get-adminurl/
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

Retrieves a list of admin URLs from a CSV file and filters them based on specified parameters.

#### Detailed Description

The Get-AdminURL function reads a CSV file containing a list of admin URLs and filters them based on specified parameters. The function can filter URLs by service, site, and server. The function can also test the availability of a server and open URLs in the default browser.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-AdminURL -Server "server01"
```

This example retrieves all admin URLs for server01.

**Example 2**

```powershell
Get-AdminURL -Service "Exchange" -Site "Site01" -Open
```

This example retrieves all admin URLs for Exchange service and Site01 site, and opens them in the default browser.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh/Github Copilot Date: 2023-08-03 Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-AdminUrls {

    <#

    .SYNOPSIS
    Retrieves a list of admin URLs from a CSV file and filters them based on specified parameters.

    .DESCRIPTION
    The Get-AdminURL function reads a CSV file containing a list of admin URLs and filters them based on specified parameters. The function can filter URLs by service, site, and server. The function can also test the availability of a server and open URLs in the default browser.

    .PARAMETER Service
    Filters URLs by service name.

    .PARAMETER Site
    Filters URLs by site name.

    .PARAMETER Server
    Filters URLs by server name. The parameter supports tab completion.

    .PARAMETER Open
    Opens filtered URLs in the default browser.

    .PARAMETER TestServer
    Tests the availability of the specified server before returning URLs.

    .EXAMPLE
    Get-AdminURL -Server "server01"

    This example retrieves all admin URLs for server01.

    .EXAMPLE
    Get-AdminURL -Service "Exchange" -Site "Site01" -Open

    This example retrieves all admin URLs for Exchange service and Site01 site, and opens them in the default browser.

    .INPUTS
    None.

    .OUTPUTS
    A list of admin URLs filtered by specified parameters.

    .NOTES
    Author: Luke Leigh/Github Copilot
    Date: 2023-08-03
    Version: 1.0

    #>

    [CmdletBinding(DefaultParameterSetName = 'DefaultParameterSet')]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ArgumentCompleter( {
                $Services = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Service
                foreach ($Service in $Services) {
                    $Service.Service
                }
            })]
        [string]$Service,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ArgumentCompleter( {
                $Sites = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Site
                foreach ($Site in $Sites) {
                    $Site.Site
                }
            })]
        [string]$Site,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DefaultParameterSet')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter( {
                $Servers = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv | Sort-Object -Property Server
                foreach ($Server in $Servers) {
                    $Server.Server
                }
            })]
        [string]$Server,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet')]
        [switch]$Open,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet')]
        [switch]$TestServer
    
    )

    $urls = Import-Csv -Path $PSScriptRoot\resources\AdminUrls.csv

    $filteredUrls = $urls
    if ($Service) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Service -eq $Service }
    }
    if ($Site) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Site -eq $Site }
    }
    if ($Server) {
        $filteredUrls = $filteredUrls | Where-Object { $_.Server -eq $Server }
    }
    if ($Open) {
        $filteredUrls | ForEach-Object -ThrottleLimit 5 -Parallel {
            Start-Process -FilePath $_.URL
        }
    }

    if ($TestServer) {
        if ($null -eq $Server -or $Server -eq "") {
            Write-Output "The `$Server variable is null or empty. Please enter a valid server name or IP address."
            $Server = Read-Host "Enter the name or IP address of the server to test"
        }
        
        Write-Output "Testing server $Server..."
        $ping = $false
        while (-not $ping) {
            $ping = Test-Connection -ComputerName $Server -Count 1 -Quiet
            if ($ping) {
                Write-Output "Server $Server is online."
            }
            else {
                Write-Output "Server $Server is offline. Retrying in 5 seconds..."
                Start-Sleep -Seconds 5
            }
        }
    }
    
    return $filteredUrls
}


<#
        Write-Output "Testing server $Server..."
        $ping = $false
        while (-not $ping) {
            $ping = Test-Connection -ComputerName $Server -Count 1 -Quiet
            if ($ping) {
                Write-Output "Server $Server is online."
            }
            else {
                Write-Output "Server $Server is offline. Retrying in 5 seconds..."
                Start-Sleep -Seconds 5
            }
        }
#>
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-AdminURL.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AdminURL.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

