---
layout: post
title: Move-FilesByType.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/move-filesbytype/
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

Moves files to subfolders based on their file extensions.

#### Detailed Description

The Move-FilesByType function moves files to subfolders based on their file extensions. It takes a base directory as input and searches for all files in that directory. For each file, it extracts the file extension and creates a subfolder with the same name as the file extension. It then moves the file to the corresponding subfolder.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Move-FilesByType -baseDirectory "C:\Path\To\Your\Files"
```

Moves all files in the "C:\Path\To\Your\Files" directory to subfolders based on their file extensions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Moves files to subfolders based on their file extensions.

.DESCRIPTION
The Move-FilesByType function moves files to subfolders based on their file extensions. It takes a base directory as input and searches for all files in that directory. For each file, it extracts the file extension and creates a subfolder with the same name as the file extension. It then moves the file to the corresponding subfolder.

.PARAMETER baseDirectory
The base directory where the files are located.

.EXAMPLE
Move-FilesByType -baseDirectory "C:\Path\To\Your\Files"
Moves all files in the "C:\Path\To\Your\Files" directory to subfolders based on their file extensions.

.NOTES
Author: Your Name
Date:   Current Date
#>

function Move-FilesByType {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory
    )

    # Check if the directory exists
    if (-Not (Test-Path -Path $baseDirectory)) {
        Write-Error "The directory '$baseDirectory' does not exist."
        return
    }

    # Get all files in the directory
    $files = Get-ChildItem -Path $baseDirectory -File

    # Loop through each file
    foreach ($file in $files) {
        # Extract the file extension and prepare the target subfolder path
        $fileExtension = $file.Extension.TrimStart('.')
        $targetFolder = Join-Path -Path $baseDirectory -ChildPath $fileExtension

        # Create the subfolder if it doesn't exist
        if (-Not (Test-Path -Path $targetFolder)) {
            New-Item -Path $targetFolder -ItemType Directory | Out-Null
        }

        # Move the file to the target subfolder
        $targetFilePath = Join-Path -Path $targetFolder -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $targetFilePath
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Move-FilesByType.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Move-FilesByType.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

