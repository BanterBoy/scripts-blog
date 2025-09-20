---
layout: post
title: Restore-Location.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Restore-Location/
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

Changes the current location back to the previously stored location.

#### Detailed Description

The Restore-Location function pops the last stored location from the stack and changes the current location to it.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Restore-Location
```

Changes back to the last stored location.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Uses a script-scoped stack to manage location history.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Store the previous locations in a script-scoped stack
$script:locationStack = [System.Collections.Generic.Stack[string]]::new()

function Restore-Location {
    <#
    .SYNOPSIS
        Changes the current location back to the previously stored location.

    .DESCRIPTION
        The Restore-Location function pops the last stored location from the stack and changes the current location to it.

    .EXAMPLE
        Restore-Location
        Changes back to the last stored location.

    .NOTES
        Uses a script-scoped stack to manage location history.
    #>

    [CmdletBinding()]
    param ()

    try {
        if ($script:locationStack.Count -eq 0) {
            Write-Warning "No previous location stored."
            return
        }

        $previousLocation = $script:locationStack.Pop()
        Write-Verbose "Retrieving previous location: $previousLocation"

        # Validate previous location
        if (-not (Test-Path $previousLocation)) {
            Write-Warning "Previous location '$previousLocation' no longer exists. Removing from stack."
            return
        }

        # Change location
        Set-Location $previousLocation
        Write-Verbose "Changed location back to: $previousLocation"
    }
    catch {
        Write-Error "Failed to change location back. Error: $($_.Exception.Message)"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Restore-Location.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Restore-Location.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

