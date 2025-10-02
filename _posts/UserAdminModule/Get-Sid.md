---
layout: post
title: Get-Sid.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-sid/
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

Translate a security principal's Security Identifier (SID).

#### Detailed Description

Use this script to translate a user or computer security principal to its corresponding SID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-Sid -SidType User
```

Returns the SID for the current user.

**Example 2**

```powershell
Get-Sid -SidType Computer
```

Returns the SID for the current computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        2.0.1 Creation Date:  March 27, 2023 Last Updated:   August 9, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Translate a security principal's Security Identifier (SID).

.PARAMETER SidType
    Specifies the type of SID to translate - user or computer.

.EXAMPLE
    Get-Sid -SidType User

    Returns the SID for the current user.

.EXAMPLE
    Get-Sid -SidType Computer

    Returns the SID for the current computer.

.DESCRIPTION
    Use this script to translate a user or computer security principal to its corresponding SID.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Get-Sid.ps1

.LINK
    https://directaccess.richardhicks.com/

.NOTES
    Version:        2.0.1
    Creation Date:  March 27, 2023
    Last Updated:   August 9, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Get-Sid {

    [CmdletBinding()]

    Param (

        [ValidateSet("User", "Machine")]
        [string]$SidType = 'User'

    )

    # Establish security principal - user or device
    Switch ($SidType) {

        User { $Principal = "$env:username" }
        Machine { $Principal = "$env:computername$" }

    }

    Write-Verbose "Identifying SID for $($SidType.ToLower()) $Principal..."

    # Translate principal to SID
    Try {

        $Id = New-Object System.Security.Principal.NTAccount($Principal)
        $Sid = $Id.Translate([System.Security.Principal.SecurityIdentifier]).Value

    }

    Catch {

        Write-Warning "Unable to translate $SidType $Principal to SID."
        Write-Warning $_.Exception.Message
        Return

    }

    Finally {

        # Create object for return
        $SidObject = New-Object PSobject -Property @{

            Principal = $Principal
            SID       = $Sid

        }

    }

    Return $SidObject

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-Sid.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Sid.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

