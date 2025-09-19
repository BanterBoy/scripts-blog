---
layout: post
title: Test-Surname.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-Surname/
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

Checks if a given surname exists in Active Directory.

#### Detailed Description

This function searches Active Directory for a given surname (sn attribute) and returns whether the surname exists.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-Surname -Surname "Smith" -Verbose
```

Checks if the surname "Smith" exists in Active Directory.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Checks if a given surname exists in Active Directory.

.DESCRIPTION
    This function searches Active Directory for a given surname (sn attribute) and returns whether the surname exists.

.PARAMETER Surname
    The surname to search for in Active Directory.

.EXAMPLE
    PS C:\> Test-Surname -Surname "Smith" -Verbose
    Checks if the surname "Smith" exists in Active Directory.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-Surname {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String] $Surname
    )

    BEGIN {
        Write-Verbose "Starting the Test-Surname function."
        Write-Verbose "Surname parameter value: $Surname"
    }

    PROCESS {
        Write-Verbose "Creating an ADSI searcher for surname: $Surname"
        $searcher = [ADSISearcher] "(sn=$Surname)"
        
        Write-Verbose "Executing the search."
        $result = $searcher.FindOne()

        if ($null -ne $result) {
            Write-Verbose "Surname '$Surname' found in Active Directory."
            $true
        }
        else {
            Write-Verbose "Surname '$Surname' not found in Active Directory."
            $false
        }
    }

    END {
        Write-Verbose "Test-Surname function completed."
    }
}

# Example call to the function with verbose output
# Test-Surname -Surname "Smith" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-Surname.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-Surname.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

