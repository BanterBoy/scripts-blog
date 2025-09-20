---
layout: post
title: Remove-EnvPath.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-EnvPath/
categories:
- UserAdminModule
- EnvironmentManagement
tags:
- PowerShell
- User Admin Module
- Env Path
description: Removes a path from the environment variable 'Path' for the specified
  container.
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

Removes a path from the environment variable 'Path' for the specified container.

#### Detailed Description

This function removes a path from the environment variable 'Path' for the specified container. The container can be 'Machine', 'User', or 'Session'. If the container is 'Session', the function only removes the path from the current session's environment variable 'Path'. If the container is 'Machine' or 'User', the function also removes the path from the persisted environment variable 'Path' for the specified container.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-EnvPath -Path 'C:\temp' -Container 'User'
```

This example removes the path 'C:\temp' from the environment variable 'Path' for the user container.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-EnvPath {
    <#
    .SYNOPSIS
        Removes a path from the environment variable 'Path' for the specified container.
    .DESCRIPTION
        This function removes a path from the environment variable 'Path' for the specified container. The container can be 'Machine', 'User', or 'Session'. If the container is 'Session', the function only removes the path from the current session's environment variable 'Path'. If the container is 'Machine' or 'User', the function also removes the path from the persisted environment variable 'Path' for the specified container.
    .PARAMETER Path
        The path to remove from the environment variable 'Path'.
    .PARAMETER Container
        The container for the environment variable 'Path'. The default value is 'Session'.
        Valid values are:
        - Machine
        - User
        - Session
    .EXAMPLE
        Remove-EnvPath -Path 'C:\temp' -Container 'User'
        This example removes the path 'C:\temp' from the environment variable 'Path' for the user container.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )
    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -contains $Path) {
            $persistedPaths = $persistedPaths | Where-Object { $_ -and $_ -ne $Path }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }
    $envPaths = $env:Path -split ';'
    if ($envPaths -contains $Path) {
        $envPaths = $envPaths | Where-Object { $_ -and $_ -ne $Path }
        $env:Path = $envPaths -join ';'
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/EnvironmentManagement/Public/Remove-EnvPath.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-EnvPath.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

