---
layout: post
title: PersonalModules.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/PersonalModules/
categories:
- UserAdminModule
- Shell
tags:
- PowerShell
- User Admin Module
- Personal Modules
description: No synopsis provided.
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function PersonalModules {
    [CmdletBinding(DefaultParameterSetName = "AllModules")]
    param (
        [Parameter(ParameterSetName = "AllModules", Mandatory = $false)]
        [Parameter(ParameterSetName = "CategoryFilter", Mandatory = $false)]
        [ValidateSet("All", "ADFunctions", "Azure", "EnvironmentManagement", "Exchange", "FileOperations", "Logging", "MediaManagement", "Network", "PKIdecommission", "RemoteConnections", "Replication", "Security", "Shell", "Teams", "Testing", "Utilities", "Database", "Weather")]
        [string]$Category = "All",

        [Parameter(ParameterSetName = "ExcludeADTools", Mandatory = $true)]
        [switch]$ADTools
    )

    $PersonalModules = @(
        "ADFunctions",
        "Azure",
        "EnvironmentManagement",
        "Exchange",
        "FileOperations",
        "Logging",
        "MediaManagement",
        "Network",
        "PKIdecommission",
        "RemoteConnections",
        "Replication",
        "Security",
        "Shell",
        "Teams",
        "Testing",
        "Utilities",
        "Database",
        "Weather"
    )

    switch ($PSCmdlet.ParameterSetName) {
        "AllModules" {
            # Return all modules
            if ($Category -ne "All") {
                # Filter the modules based on the selected category
                $PersonalModules = $PersonalModules | Where-Object { $_ -eq $Category }
            }
        }
        "ExcludeADTools" {
            # Exclude ADFunctions if -ADTools is specified
            $PersonalModules = $PersonalModules | Where-Object { $_ -ne "ADFunctions" }
        }
        "CategoryFilter" {
            # Filter the modules based on the selected category
            $PersonalModules = $PersonalModules | Where-Object { $_ -eq $Category }
        }
    }

    return $PersonalModules
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/PersonalModules.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=PersonalModules.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

