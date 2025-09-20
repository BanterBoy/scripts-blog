---
layout: post
title: Initialize-TeamsLocalUploadFolder.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Initialize-TeamsLocalUploadFolder/
categories:
  - UserAdminModule
  - Teams
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

Initializes the local upload folder for Microsoft Teams backgrounds.

#### Detailed Description

This function checks if the local upload folder for Microsoft Teams backgrounds exists and creates it if it doesn't. It also checks if the local folder for new Teams exists and sets a flag accordingly.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Initialize-TeamsLocalUploadFolder -IncludeNewTeams $true
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Initialize-TeamsLocalUploadFolder {
    <#
    .SYNOPSIS
        Initializes the local upload folder for Microsoft Teams backgrounds.
    
    .DESCRIPTION
        This function checks if the local upload folder for Microsoft Teams backgrounds exists and creates it if it doesn't. 
        It also checks if the local folder for new Teams exists and sets a flag accordingly.
    
    .PARAMETER IncludeNewTeams
        Specifies whether to include the local folder for new Teams in the check. Default is $false.
    
    .EXAMPLE
        Initialize-TeamsLocalUploadFolder -IncludeNewTeams $true
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)] [boolean]$IncludeNewTeams
    )

    $TeamsBackgroundBasePath = $env:APPDATA + "\Microsoft\Teams\Backgrounds\"
    $TeamsBackgroundUploadPath = $TeamsBackgroundBasePath + "\Uploads\"

    If (!(Test-Path $TeamsBackgroundUploadPath)) {
        $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Local AppData\Microsoft\Teams\Backgrounds\ folder does not exist. Trying to create it..."
        Log-Event -message $Message
        try {
            New-Item -ItemType Directory -Path $TeamsBackgroundBasePath -Name "Uploads"
            $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Successfully created Uploads folder in AppData\Microsoft\Teams\Backgrounds\."
            Log-Event -message $Message

            $teamsLocalUploadFolderExists = $true
        }
        catch {
            $Message = "Initialize-TeamsLocalUploadFolder @ " + (Get-Date) + ": ERROR trying to create local Upload Folder: " + $_.Exception.Message
            Log-Event -message $message
            $teamsLocalUploadFolderExists = $false
        }
    }
    else {
        $teamsLocalUploadFolderExists = $true 
    }
    if ($IncludeNewTeams -eq $true) {
        $NewTeamsBackgroundBasePath = $env:LOCALAPPDATA + "\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
        $NewTeamsBackgroundUploadPath = $NewTeamsBackgroundBasePath + "\Uploads\"
        If (!(Test-Path $NewTeamsBackgroundUploadPath)) {
            $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Local folder for new Teams does not exist. Indicates New Teams is not present on this system."
            Log-Event -message $Message
            $NewTeamsLocalUploadFolderExists = $false
        }
        else {
            $NewTeamsLocalUploadFolderExists = $true
        }
    }
    return $NewTeamsLocalUploadFolderExists
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/Initialize-TeamsLocalUploadFolder.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Initialize-TeamsLocalUploadFolder.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

