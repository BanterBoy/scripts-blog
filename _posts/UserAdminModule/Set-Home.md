---
layout: post
title: Set-Home.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/set-home/
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

Changes the current location to the root of the current drive and stores the previous location.

#### Detailed Description

The Set-Home function pushes the current location onto a stack and then changes the current location to the root of the current drive. Supports navigation back with Restore-Location.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-Home
```

Changes to the root of the current drive and stores the previous location.

**Example 2**

```powershell
Set-Home -CustomHome "C:\Users"
```

Changes to "C:\Users" and stores the previous location.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Locations are stored in a script-scoped stack for multiple levels of navigation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Set-Home {
    <#
    .SYNOPSIS
        Changes the current location to the root of the current drive and stores the previous location.

    .DESCRIPTION
        The Set-Home function pushes the current location onto a stack and then changes the current location to the root of the current drive. Supports navigation back with Restore-Location.

    .PARAMETER CustomHome
        Optional custom path to use as "home" instead of the drive root.

    .EXAMPLE
        Set-Home
        Changes to the root of the current drive and stores the previous location.

    .EXAMPLE
        Set-Home -CustomHome "C:\Users"
        Changes to "C:\Users" and stores the previous location.

    .NOTES
        Locations are stored in a script-scoped stack for multiple levels of navigation.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Custom path to use as home.")]
        [string]$CustomHome
    )

    try {
        $currentLocation = Get-Location
        Write-Verbose "Storing current location: $currentLocation"

        # Push current location to stack
        $script:locationStack.Push($currentLocation.Path)

        # Determine target location
        if ($CustomHome) {
            $target = $CustomHome
        } else {
            $currentDrive = $currentLocation.Drive.Name
            if (-not $currentDrive) {
                Write-Error "Unable to determine current drive."
                return
            }
            $target = "$currentDrive`:\"
        }

        # Validate target path
        if (-not (Test-Path $target)) {
            Write-Error "Target path '$target' does not exist."
            return
        }

        # Change location with ShouldProcess
        if ($PSCmdlet.ShouldProcess($target, "Change current location")) {
            Set-Location $target
            Write-Verbose "Changed location to: $target"
        }
    }
    catch {
        Write-Error "Failed to change location. Error: $($_.Exception.Message)"
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Set-Home.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-Home.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

