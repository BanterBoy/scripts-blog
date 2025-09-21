---
layout: post
title: Get-UsersTeamsFolders.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/teams/get-usersteamsfolders/
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

Gets the Teams folders for all users on the local machine.

#### Detailed Description

This function retrieves the Teams folders for all users on the local machine. It returns an array of objects that contains the user name, Teams folder path, Teams upload folder path, new Teams folder path, and new Teams upload folder path.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-UsersTeamsFolders
```

User      : User1 TeamsFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\ TeamsUploadFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\ NewTeamsFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\ NewTeamsUploadFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\ User      : User2 TeamsFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\ TeamsUploadFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\ NewTeamsFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\ NewTeamsUploadFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Today's date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-UsersTeamsFolders {
    <#
    .SYNOPSIS
        Gets the Teams folders for all users on the local machine.
    
    .DESCRIPTION
        This function retrieves the Teams folders for all users on the local machine. It returns an array of objects that contains the user name, Teams folder path, Teams upload folder path, new Teams folder path, and new Teams upload folder path.
    
    .EXAMPLE
        PS C:\> Get-UsersTeamsFolders
    
        User      : User1
        TeamsFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\
        TeamsUploadFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\
        NewTeamsFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\
        NewTeamsUploadFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\
    
        User      : User2
        TeamsFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\
        TeamsUploadFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\
        NewTeamsFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\
        NewTeamsUploadFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\
    
    .INPUTS
        None
    
    .OUTPUTS
        Array of objects that contains the user name, Teams folder path, Teams upload folder path, new Teams folder path, and new Teams upload folder path.
    
    .NOTES
        Author: Your Name
        Date:   Today's date
    #>
    $SystemAccounts = @("Administrator", "Default", "Public", "All Users", "Default User", "LocalService", "NetworkService", "rdgservice", "ADAxes_SVC", ".admin")
    $Users = Get-ChildItem 'C:\Users\' | Where-Object { ( $_.PSIsContainer -and $SystemAccounts -notcontains $_.Name ) }
    # remove users that are in the format *.admin
    $Users = $Users | Where-Object { $_.Name -notmatch '\.admin$' }
    $UsersTeamsFolders = @()
    foreach ($User in $Users) {
        $TeamsFolder = $User.FullName + "\AppData\Roaming\Microsoft\Teams\Backgrounds\"
        $TeamsUploadFolder = $TeamsFolder + "Uploads\"
        $NewTeamsFolder = $User.FullName + "\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
        $NewTeamsUploadFolder = $NewTeamsFolder + "Uploads\"
        $UsersTeamsFolders += [pscustomobject]@{
            User                 = $User.Name
            TeamsFolder          = $TeamsFolder
            TeamsUploadFolder    = $TeamsUploadFolder
            NewTeamsFolder       = $NewTeamsFolder
            NewTeamsUploadFolder = $NewTeamsUploadFolder
        }
    }
    return $UsersTeamsFolders
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/Get-UsersTeamsFolders.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UsersTeamsFolders.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

