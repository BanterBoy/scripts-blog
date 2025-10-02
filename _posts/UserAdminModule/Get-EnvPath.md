---
layout: post
title: Get-EnvPath.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/environmentmanagement/get-envpath/
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

Gets the environment path for the specified container.

#### Detailed Description

This function retrieves the environment path for the specified container (Machine, User, or Process).

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-EnvPath -Container User
```

Returns the environment path for the current user.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-EnvPath {
    <#
    .SYNOPSIS
        Gets the environment path for the specified container.
    .DESCRIPTION
        This function retrieves the environment path for the specified container (Machine, User, or Process).
    .PARAMETER Container
        Specifies the container for which to retrieve the environment path. Valid values are Machine, User, and Process.
    .EXAMPLE
        PS C:\> Get-EnvPath -Container User
        Returns the environment path for the current user.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Machine', 'User', 'Process')]
        [string] $Container
    )
    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User    = [EnvironmentVariableTarget]::User
        Process = [EnvironmentVariableTarget]::Process
    }
    $containerType = $containerMapping[$Container]
    [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' |
    Where-Object { $_ }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/EnvironmentManagement/Public/Get-EnvPath.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-EnvPath.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

