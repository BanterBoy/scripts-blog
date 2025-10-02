---
layout: post
title: Get-PortService.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/network/get-portservice/
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

Retrieves port service information based on a search query.

#### Detailed Description

The Get-PortService function retrieves port service information based on a search query. The search query can be performed on the port number, service name, or description. The function reads the port service data from a JSON file located in the same directory as the script.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-PortService -Query '80'
```

Retrieves port service information for port number 80.

**Example 2**

```powershell
Get-PortService -Query 'http' -SearchField 'Description'
```

Retrieves port service information for services with 'http' in the description.

**Example 3**

```powershell
Get-PortService -Query 'ftp' -SearchAllFields
```

Retrieves port service information for services with 'ftp' in any field.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Get-PortService {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        [Parameter()]
        [ValidateSet('PortNumber', 'ServiceName', 'Description')]
        [string]$SearchField = 'ServiceName',
        [Parameter()]
        [switch]$SearchAllFields
    )

    $portServiceData = Get-Content -Raw -Path $PSScriptRoot\resources\port_service_data.json | ConvertFrom-Json
    $portServices = @()

    foreach ($entry in $portServiceData) {
        $portService = [PortService]::new($entry.ServiceName, $entry.PortNumber, $entry.Description, $entry.Reference)

        if ($SearchAllFields) {
            if ($portService.MatchPortNumber($Query) -or $portService.MatchServiceName($Query) -or $portService.MatchDescription($Query)) {
                $portServices += $portService
            }
        }
        else {
            switch ($SearchField) {
                'PortNumber' {
                    if ($portService.MatchPortNumber($Query)) {
                        $portServices += $portService
                    }
                }
                'ServiceName' {
                    if ($portService.MatchServiceName($Query)) {
                        $portServices += $portService
                    }
                }
                'Description' {
                    if ($portService.MatchDescription($Query)) {
                        $portServices += $portService
                    }
                }
            }
        }
    }

    return $portServices
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-PortService.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PortService.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

