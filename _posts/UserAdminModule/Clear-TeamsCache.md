---
layout: post
title: Clear-TeamsCache.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/teams/clear-teamscache/
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

Get-UsersTeamsCacheSummary function gets a summary of the space used for each user in the Teams cache.

#### Detailed Description

The Get-UsersTeamsCacheSummary function retrieves the size of the Teams cache for each user in the C:\Users directory. It calculates the size in megabytes and displays it in the format "Username - Size MB".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-UsersTeamsCacheSummary
```

This example retrieves the size of the Teams cache for each user in the C:\Users directory and displays it.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Functions and script to clear the Teams cache
# Script will need to close Teams if it is running
# Users Cache: %appdata%\Microsoft\Teams

<#
.SYNOPSIS
    Get-UsersTeamsCacheSummary function gets a summary of the space used for each user in the Teams cache.

.DESCRIPTION
    The Get-UsersTeamsCacheSummary function retrieves the size of the Teams cache for each user in the C:\Users directory. It calculates the size in megabytes and displays it in the format "Username - Size MB".

.EXAMPLE
    Get-UsersTeamsCacheSummary
    This example retrieves the size of the Teams cache for each user in the C:\Users directory and displays it.

#>
function Get-UsersTeamsCacheSummary {
     $users = Get-ChildItem C:\Users | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty Name
     foreach ($user in $users) {
          $path = "C:\Users\$user\AppData\Roaming\Microsoft\Teams"
          if (Test-Path $path) {
                $size = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                $size = $size / 1MB
                $size = [math]::Round($size, 2)
                Write-Host "$user - $size MB"
          }
     }
}

<#
.SYNOPSIS
    Get-TeamsCache function gets the Teams cache for all local users.

.DESCRIPTION
    The Get-TeamsCache function retrieves the Teams cache for all local users. It returns the list of files and directories in the Teams cache directory.

.EXAMPLE
    Get-TeamsCache
    This example retrieves the Teams cache for all local users.

#>
function Get-TeamsCache {
     $path = "$env:APPDATA\Microsoft\Teams"
     if (Test-Path $path) {
          Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue
     }
}

<#
.SYNOPSIS
    Clear-TeamsCacheLM function clears the Teams cache for all local users.

.DESCRIPTION
    The Clear-TeamsCacheLM function removes the Teams cache directory for each user in the C:\Users directory.

.EXAMPLE
    Clear-TeamsCacheLM
    This example clears the Teams cache for all local users.

#>
function Clear-TeamsCacheLM {
     $users = Get-ChildItem C:\Users | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty Name
     foreach ($user in $users) {
          $path = "C:\Users\$user\AppData\Roaming\Microsoft\Teams"
          if (Test-Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
          }
     }
}

<#
.SYNOPSIS
    Clear-TeamsCacheCU function clears the Teams cache for the current user.

.DESCRIPTION
    The Clear-TeamsCacheCU function removes the Teams cache directory for the current user.

.EXAMPLE
    Clear-TeamsCacheCU
    This example clears the Teams cache for the current user.

#>
function Clear-TeamsCacheCU {
     $path = "$env:APPDATA\Microsoft\Teams"
     if (Test-Path $path) {
          Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
     }
}

<#
.SYNOPSIS
    Stop-Teams function checks if Teams is running and closes it if it is.

.DESCRIPTION
    The Stop-Teams function checks if the Teams process is running and forcefully terminates it if it is.

.EXAMPLE
    Stop-Teams
    This example checks if Teams is running and closes it if it is.

#>
function Stop-Teams {
     $TeamsProcess = Get-Process -Name Teams -ErrorAction SilentlyContinue
     if ($TeamsProcess) {
          Stop-Process -Name Teams -Force
     }
}

# Call the function to stop Teams

# Stop-Teams

# Call the function to clear the Teams cache

# Clear-TeamsCacheLM
# Clear-TeamsCacheCU
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/Clear-TeamsCache.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Clear-TeamsCache.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

