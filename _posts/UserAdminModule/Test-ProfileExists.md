---
layout: post
title: Test-ProfileExists.ps1
date: 2025-09-19
permalink: /useradminmodule/testing/test-profileexists/
categories:
  - UserAdminModule
  - Testing
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

Checks if PowerShell profile paths exist.

#### Detailed Description

This function checks if the standard PowerShell profile paths exist and provides detailed information about each profile.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-ProfileExists -Verbose
```

Checks if the PowerShell profile paths exist and provides detailed information about each profile.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Checks if PowerShell profile paths exist.

.DESCRIPTION
    This function checks if the standard PowerShell profile paths exist and provides detailed information about each profile.

.EXAMPLE
    PS C:\> Test-ProfileExists -Verbose
    Checks if the PowerShell profile paths exist and provides detailed information about each profile.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-ProfileExists {
    [CmdletBinding()]
    param ()

    BEGIN {
        Write-Verbose "Starting the Test-ProfileExists function."
    }

    PROCESS {
        $profile.PSObject.Properties.Name |
        Where-Object { $_ -ne 'Length' } |
        ForEach-Object {
            $profileName = $_
            $profilePath = $profile.$profileName
            $profileExists = Test-Path $profilePath

            Write-Verbose "Checking profile: $profileName"
            Write-Verbose "Profile path: $profilePath"
            Write-Verbose "Profile exists: $profileExists"

            [PSCustomObject]@{
                Profile = $profileName
                Present = $profileExists
                Path    = $profilePath
            }
        }
    }

    END {
        Write-Verbose "Test-ProfileExists function completed."
    }
}

# Example call to the function with verbose output
# Test-ProfileExists -Verbose | Format-Table -AutoSize
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-ProfileExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ProfileExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

