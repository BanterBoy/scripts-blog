---
layout: post
title: IsAdmin.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/IsAdmin/
categories:
- UserAdminModule
- Shell
tags:
- PowerShell
- User Admin Module
- Is Admin
description: Tests if the user is an administrator
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

Tests if the user is an administrator

#### Detailed Description

Returns true if a user is an administrator, false if the user is not an administrator

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Test-IsAdmin
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Test-IsAdmin {
  <#
  .Synopsis
  Tests if the user is an administrator
  .Description
  Returns true if a user is an administrator, false if the user is not an administrator
  .Example
  Test-IsAdmin
  #>
  
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal $identity
  $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Set-TitleisAdmin {
  <#
  .SYNOPSIS
  Sets the console window title to display the current user's username, privileges, and current path.
  
  .DESCRIPTION
  This function sets the console window title to display the current user's username, followed by their privileges (either "Admin Privileges" or "User Privileges"), and the current path.
  
  .PARAMETER None
  This function does not accept any parameters.
  
  .EXAMPLE
  Set-TitleisAdmin
  #>
  $Username = whoami.exe /upn
  $CurrentPath = $PWD.Path

  if (Test-IsAdmin) {
    $host.UI.RawUI.WindowTitle = "$($Username) - Admin Privileges - Path: $($CurrentPath)"
  }	
  else {
    $host.UI.RawUI.WindowTitle = "$($Username) - User Privileges - Path: $($CurrentPath)"
  }	
}

function Set-PromptisAdmin {
  <#
  .SYNOPSIS
  Sets the PowerShell prompt to display whether the current session is running as an administrator or not.
  
  .DESCRIPTION
  This function sets the PowerShell prompt to display "(Admin)" if the current session is running as an administrator, or "(User)" if it is not.
  
  .PARAMETER None
  This function has no parameters.
  
  .EXAMPLE
  Set-PromptisAdmin
  This example sets the PowerShell prompt to display whether the current session is running as an administrator or not.
  
  .NOTES
  This function requires the Test-IsAdmin and Set-TitleisAdmin functions to be defined.
  #>
  if (Test-IsAdmin) {
    function global:prompt {
      Set-TitleisAdmin
      "(Admin) $PWD> "
    }
  }	
  else {
    function global:prompt {
      Set-TitleisAdmin
      "(User) $PWD> "
    }
  }	
}

function Show-IsAdminOrNot {
  <#
  .SYNOPSIS
      Determines if the current user has administrative privileges.

  .DESCRIPTION
      This function checks if the current user has administrative privileges by calling the `Test-IsAdmin` function. 
      It outputs a warning message indicating whether the user has admin privileges or user privileges.

  .PARAMETER None
      This function does not take any parameters.

  .OUTPUTS
      None. Outputs a warning message indicating the privilege level.

  .EXAMPLE
      PS C:\> Show-IsAdminOrNot
      WARNING: Admin Privileges!

      This example checks the current user's privilege level and outputs "Admin Privileges!" if the user has administrative rights.

  .NOTES
      Author: Your Name
      Date: 30/06/2024
      The function `Test-IsAdmin` must be defined for this function to work correctly.

  .LINK
      https://github.com/YourGitHubProfile
  #>

  # Check if the user is an admin
  $IsAdmin = Test-IsAdmin

  # Output a warning message based on the user's privilege level
  if ($IsAdmin -eq $false) {
    Write-Warning -Message "User Privileges"
  }
  else {
    Write-Warning -Message "Admin Privileges!"
  }
}

# Helper function to determine if the current user is an administrator
function Test-IsAdmin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/IsAdmin.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=IsAdmin.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

