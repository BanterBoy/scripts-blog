---
layout: post
title: Get-TeamsFolderStructure.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-TeamsFolderStructure/
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

Gets the folder structure for Microsoft Teams backgrounds.

#### Detailed Description

This function retrieves the folder structure for Microsoft Teams backgrounds. It determines whether the old or new folder structure is being used and returns the appropriate base path and upload path.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-TeamsFolderStructure
```

Returns a hashtable with the folder structure for Microsoft Teams backgrounds.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-TeamsFolderStructure {
    <#
    .SYNOPSIS
        Gets the folder structure for Microsoft Teams backgrounds.
    
    .DESCRIPTION
        This function retrieves the folder structure for Microsoft Teams backgrounds. It determines whether the old or new folder structure is being used and returns the appropriate base path and upload path.
    
    .OUTPUTS
        Returns a hashtable with the following keys:
        - "Structure": Indicates whether the old or new folder structure is being used.
        - "BasePath": The base path for the Microsoft Teams backgrounds.
        - "UploadPath": The upload path for the Microsoft Teams backgrounds.
    
    .EXAMPLE
        PS C:\> Get-TeamsFolderStructure
        Returns a hashtable with the folder structure for Microsoft Teams backgrounds.
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    $TeamsBackgroundBasePath = $env:APPDATA + "\Microsoft\Teams\Backgrounds\"
    $TeamsBackgroundUploadPath = $TeamsBackgroundBasePath + "Uploads\"

    $NewTeamsBackgroundBasePath = $env:LOCALAPPDATA + "\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
    $NewTeamsBackgroundUploadPath = $NewTeamsBackgroundBasePath + "Uploads\"

    $TeamsFolderStructure = @{
        "Structure"  = "Old";
        "BasePath"   = $TeamsBackgroundBasePath;
        "UploadPath" = $TeamsBackgroundUploadPath;
    }

    if (Test-Path $NewTeamsBackgroundUploadPath) {
        $TeamsFolderStructure["Structure"] = "New"
        $TeamsFolderStructure["BasePath"] = $NewTeamsBackgroundBasePath
        $TeamsFolderStructure["UploadPath"] = $NewTeamsBackgroundUploadPath
    }

    return $TeamsFolderStructure
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/Get-TeamsFolderStructure.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TeamsFolderStructure.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

