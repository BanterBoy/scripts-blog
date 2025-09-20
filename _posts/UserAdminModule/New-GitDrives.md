---
layout: post
title: New-GitDrives.ps1
date: 2025-09-19
permalink: /useradminmodule/shell/new-gitdrives/
categories:
  - UserAdminModule
  - Shell
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`New-GitDrives` prompts for a root folder (via the `Select-FolderLocation` helper) and then creates a PowerShell drive for each immediate child directory. It is ideal for quickly mounting a series of Git repositories as PSDrives for easy navigation.

**Usage examples**

```powershell
New-GitDrives
```

Select the directory that contains your repository folders when prompted. The script assumes each child directory should become a file-system drive named after the folder.

---

#### Script

```powershell
function New-GitDrives {
        $PSRootFolder = Select-FolderLocation
        $Exist = Test-Path -Path $PSRootFolder
        if (($Exist) = $true) {
                $PSDrivePaths = Get-ChildItem -Path "$PSRootFolder\"
                foreach ($item in $PSDrivePaths) {
                        $paths = Test-Path -Path $item.FullName
                        if (($paths) = $true) {
                                New-PSDrive -Name $item.Name -PSProvider "FileSystem" -Root $item.FullName
                        }
                }
        }
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-GitDrives.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-GitDrives.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
