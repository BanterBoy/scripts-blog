---
layout: post
title: Get-PSGalleryItemsForAuthor.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-PSGalleryItemsForAuthor/
categories:
  - UserAdminModule
  - Security
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-PSGalleryItemsForAuthor {
    <#PSScriptInfo

.VERSION 0.1.02

.GUID 788b94eb-f6f0-400d-b259-2e15c3f102ee

.AUTHOR J. Keith Bankston

.COMPANYNAME Microsoft

.COPYRIGHT Microsoft, 2018

.TAGS GalleryUtility,GDPR

.LICENSEURI 

.PROJECTURI https://github.com/PowerShell/PowerShellGallery/

.ICONURI 

.RELEASENOTES
 Version 0.1.02 - Fixing issues noted in GH (see projectURI above).
 Version 0.1.01 - Version change when signed 
 Version 0.1.0 - Initial Version. See description for use information. 


.PRIVATEDATA 

#>

    <# 

.DESCRIPTION 
This script will save all versions of all scripts and modules published to the PowerShell Gallery by a given Author.
The Author is specified in the manifest for each item, and is expected to be consistent for a given user.

The script assumes that there is at least 1 version of every item that is listed. 
This can be verified by logging into the PowerShell Gallery, navigating to https://www.powershellgallery.com/account/Packages.
If there are items that are hidden, they will be shown at the bottom of that page under the header: "Unlisted Items"

Use instructions: 
* Provide the AuthorName, which is the Author used in the item manifest. 
  Note that the Author is not guaranteed to match the Owner, which is the account name for those who publish the item.
* Provide the LocalFolder to place all the PowerShell Gallery items into. 

For questions on this script, email cgadmin@microsoft.com 

.Example 
GetPSGalleryItemsForAuthor -AuthorName 'J. Keith Bankston' -LocalFolder c:\temp\test

This will find all items where 'J. Keith Bankston' is listed as an author, and save them into c:\temp\test. 
The folder will be created if it does not exist.

#> 

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $AuthorName,

        [Parameter(Mandatory = $true)]
        [string] $LocalFolder
    )


    If (-not (test-path -path $LocalFolder)) {
        write-verbose "Creating folder $LocalFolder"
        new-item $LocalFolder -itemtype Directory
    }
    

    Write-Host "Retrieving all modules published by the author $AuthorName"

    find-module -repository psgallery | Where-Object { 
        if ($_.Author.count -eq 1) {
            $_.Author -eq $AuthorName 
        }
        else {
            $_.Author -contains $AuthorName
        }
    } | ForEach-Object {
        Write-Verbose "Retrieving all versions of $($_.Name)"

        Find-Module -Name $_.Name -repository psgallery -AllowPrerelease -AllVersions |  Foreach-Object { 
            Save-Module -Name $_.Name -RequiredVersion $_.Version -Path $LocalFolder -Repository psgallery -AllowPrerelease
        }
    }



    Write-Host "Retrieving all scripts published by the author $AuthorName"

    find-script -repository psgallery | Where-Object { 
        if ($_.Author.count -eq 1) {
            $_.Author -eq $AuthorName 
        }
        else {
            $_.Author -contains $AuthorName
        }
    } | ForEach-Object {
        Write-Verbose "Retrieving all versions of $($_.Name)"

        Find-Script -Name $_.Name -repository psgallery -AllowPrerelease -AllVersions |  Foreach-Object { 
            Save-Script -Name $_.Name -RequiredVersion $_.Version -Path $LocalFolder -Repository psgallery -AllowPrerelease
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Get-PSGalleryItemsForAuthor.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PSGalleryItemsForAuthor.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

