---
layout: post
title: Test-UserExists.ps1
date: 2025-09-19
permalink: /useradminmodule/testing/test-userexists/
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

Checks if a user with the given SAMAccountName exists in Active Directory.

#### Detailed Description

This function searches Active Directory for a user with the specified SAMAccountName and returns whether the user exists.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-UserExists -SAMAccountName "jdoe" -Verbose
```

Checks if the user with the SAMAccountName "jdoe" exists in Active Directory.

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
    Checks if a user with the given SAMAccountName exists in Active Directory.

.DESCRIPTION
    This function searches Active Directory for a user with the specified SAMAccountName and returns whether the user exists.

.PARAMETER SAMAccountName
    The SAMAccountName to search for in Active Directory.

.EXAMPLE
    PS C:\> Test-UserExists -SAMAccountName "jdoe" -Verbose
    Checks if the user with the SAMAccountName "jdoe" exists in Active Directory.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-UserExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $SAMAccountName
    )

    BEGIN {
        Write-Verbose "Starting the Test-UserExists function."
        Write-Verbose "SAMAccountName parameter value: $SAMAccountName"
    }

    PROCESS {
        Write-Verbose "Searching for user with SAMAccountName: $SAMAccountName"
        
        try {
            $userCount = @(Get-ADUser -LDAPFilter "(samaccountname=$SAMAccountName)").Count

            if ($userCount -ne 0) {
                Write-Verbose "User with SAMAccountName '$SAMAccountName' found in Active Directory."
                $true
            }
            else {
                Write-Verbose "User with SAMAccountName '$SAMAccountName' not found in Active Directory."
                $false
            }
        }
        catch {
            Write-Error "Failed to search for user with SAMAccountName '$SAMAccountName': $_"
            $false
        }
    }

    END {
        Write-Verbose "Test-UserExists function completed."
    }
}

# Example call to the function with verbose output
# Test-UserExists -SAMAccountName "jdoe" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-UserExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-UserExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

