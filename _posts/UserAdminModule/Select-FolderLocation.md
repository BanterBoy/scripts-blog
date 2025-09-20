---
layout: post
title: Select-FolderLocation.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Select-FolderLocation/
categories:
  - UserAdminModule
  - Shell
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

Prompts the user to select a folder location using a graphical user interface.

#### Detailed Description

This function displays a FolderBrowserDialog to prompt the user to select a folder location. It ensures that the user selects a folder and provides options to retry or cancel if the selection is not made.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$directoryPath = Select-FolderLocation
```

if (![string]::IsNullOrEmpty($directoryPath)) { Write-Host "You selected the directory: $directoryPath" } else { Write-Host "You did not select a directory." } This example prompts the user to select a folder location and displays the selected directory path.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Select-FolderLocation {
    <#
    .SYNOPSIS
        Prompts the user to select a folder location using a graphical user interface.

    .DESCRIPTION
        This function displays a FolderBrowserDialog to prompt the user to select a folder location.
        It ensures that the user selects a folder and provides options to retry or cancel if the selection is not made.

    .EXAMPLE
        $directoryPath = Select-FolderLocation
        if (![string]::IsNullOrEmpty($directoryPath)) {
            Write-Host "You selected the directory: $directoryPath"
        }
        else {
            Write-Host "You did not select a directory."
        }

        This example prompts the user to select a folder location and displays the selected directory path.

    .OUTPUTS
        System.String

        The function returns the selected directory path as a string. If the user cancels the selection, it returns $null.

    .NOTES
        Author: Luke Leigh
        Date: [Date]

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog?view=windowsdesktop-6.0
    #>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "Loading System.Windows.Forms assembly."
        [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        [System.Windows.Forms.Application]::EnableVisualStyles()
    }

    process {
        Write-Verbose "Initializing FolderBrowserDialog."
        $browse = New-Object System.Windows.Forms.FolderBrowserDialog
        $browse.SelectedPath = "C:\"
        $browse.ShowNewFolderButton = $true
        $browse.Description = "Select a directory for your report"

        $loop = $true

        while ($loop) {
            Write-Verbose "Displaying FolderBrowserDialog."
            if ($browse.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                Write-Verbose "User selected directory: $($browse.SelectedPath)"
                $loop = $false
            }
            else {
                Write-Verbose "User clicked Cancel."
                $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
                if ($res -eq [System.Windows.Forms.DialogResult]::Cancel) {
                    Write-Verbose "User chose to exit."
                    return $null
                }
                else {
                    Write-Verbose "User chose to retry."
                }
            }
        }
    }

    end {
        Write-Verbose "Returning selected path: $($browse.SelectedPath)"
        $selectedPath = $browse.SelectedPath
        $browse.Dispose()
        return $selectedPath
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Select-FolderLocation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Select-FolderLocation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

