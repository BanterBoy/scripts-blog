---
layout: post
title: Restart-Profile.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Restart-Profile/
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

Restarts specified PowerShell profiles by reloading them.

#### Detailed Description

This function reloads the specified PowerShell profiles. It checks if the profile path exists before attempting to run it. You can specify which profile(s) to restart using the -ProfileType parameter.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Restart-Profile -ProfileType AllUsersCurrentHost -Verbose
```

This example reloads the AllUsersCurrentHost profile with verbose output enabled.

**Example 2**

```powershell
Restart-Profile -ProfileType All -Verbose
```

This example reloads all profiles with verbose output enabled.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Restart-Profile {

    <#
    .SYNOPSIS
        Restarts specified PowerShell profiles by reloading them.

    .DESCRIPTION
        This function reloads the specified PowerShell profiles. It checks if the profile path exists 
        before attempting to run it. You can specify which profile(s) to restart using the -ProfileType parameter.

    .PARAMETER ProfileType
        Specifies which profile(s) to restart. Possible values are:
        - AllUsersAllHosts: All users, all hosts profile
        - AllUsersCurrentHost: All users, current host profile
        - CurrentUserAllHosts: Current user, all hosts profile
        - CurrentUserCurrentHost: Current user, current host profile
        - All: All profiles (default)

    .EXAMPLE
        Restart-Profile -ProfileType AllUsersCurrentHost -Verbose
        This example reloads the AllUsersCurrentHost profile with verbose output enabled.

    .EXAMPLE
        Restart-Profile -ProfileType All -Verbose
        This example reloads all profiles with verbose output enabled.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('AllUsersAllHosts', 'AllUsersCurrentHost', 'CurrentUserAllHosts', 'CurrentUserCurrentHost', 'All')]
        [string]$ProfileType = 'All'
    )

    # Array of profile paths to be reloaded based on the ProfileType parameter
    switch ($ProfileType) {
        'AllUsersAllHosts' {
            $profilePaths = @($Profile.AllUsersAllHosts)
        }
        'AllUsersCurrentHost' {
            $profilePaths = @($Profile.AllUsersCurrentHost)
        }
        'CurrentUserAllHosts' {
            $profilePaths = @($Profile.CurrentUserAllHosts)
        }
        'CurrentUserCurrentHost' {
            $profilePaths = @($Profile.CurrentUserCurrentHost)
        }
        'All' {
            $profilePaths = @(
                $Profile.AllUsersAllHosts,
                $Profile.AllUsersCurrentHost,
                $Profile.CurrentUserAllHosts,
                $Profile.CurrentUserCurrentHost
            )
        }
    }

    # Iterate through each profile path
    foreach ($profilePath in $profilePaths) {
        if (Test-Path -Path $profilePath) {
            Write-Verbose "Running profile script: $profilePath"
            try {
                . $profilePath
                Write-Verbose "Successfully ran profile script: $profilePath"
            }
            catch {
                Write-Warning "Failed to run profile script: $profilePath - $_"
            }
        }
        else {
            Write-Verbose "Profile path does not exist: $profilePath"
        }
    }
}

# Example Usage:
# Restart-Profile -ProfileType AllUsersCurrentHost -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Restart-Profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Restart-Profile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

