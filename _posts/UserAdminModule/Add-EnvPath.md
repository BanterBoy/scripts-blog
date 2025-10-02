---
layout: post
title: Add-EnvPath.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/environmentmanagement/add-envpath/
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

Adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'.

#### Detailed Description

The Add-EnvPath function adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'. If the specified path already exists in the environment variable, it will not be added again.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Add-EnvPath -Path 'C:\Program Files\MyApp'
```

This example adds 'C:\Program Files\MyApp' to the current session's environment variable 'Path'.

**Example 2**

```powershell
Add-EnvPath -Path 'C:\Program Files\MyApp' -Container 'Machine'
```

This example adds 'C:\Program Files\MyApp' to the system environment variable 'Path'.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Date: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Add-EnvPath {
    <#
    .SYNOPSIS
    Adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'.
    
    .DESCRIPTION
    The Add-EnvPath function adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'. If the specified path already exists in the environment variable, it will not be added again.
    
    .PARAMETER Path
    The path to add to the environment variable 'Path'.
    
    .PARAMETER Container
    Specifies the environment variable container to add the path to. Valid values are 'Machine', 'User', and 'Session'. The default value is 'Session'.
    
    .EXAMPLE
    Add-EnvPath -Path 'C:\Program Files\MyApp'
    
    This example adds 'C:\Program Files\MyApp' to the current session's environment variable 'Path'.
    
    .EXAMPLE
    Add-EnvPath -Path 'C:\Program Files\MyApp' -Container 'Machine'
    
    This example adds 'C:\Program Files\MyApp' to the system environment variable 'Path'.
    
    .NOTES
    Author: Unknown
    Date: Unknown
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
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }
    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/EnvironmentManagement/Public/Add-EnvPath.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Add-EnvPath.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

