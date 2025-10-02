---
layout: post
title: New-Shortcut.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/new-shortcut/
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

Creates a new shortcut with a specified icon.

#### Detailed Description

This function creates a new shortcut at the specified location with a given source file location and icon.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Install-Module -Name IconExport
```

Import-Module -Name IconExport # Set Icon Storage Location $IconStorage = [Environment]::GetFolderPath("ApplicationData") + "\Icons" # Export Icon Export-Icon -Path 'C:\Program Files\Microsoft VS Code\Code.exe' -Type ico -Directory $IconStorage # Create a new Shortcut with the icon specified New-Shortcut -SourceFileLocation 'https://www.google.co.uk' -ShortcutLocation "$DesktopPath\Google.lnk" -IconLocation "$IconStorage\pwsh-0.ico"

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Website: https://blog.lukeleigh.com Twitter: https://twitter.com/luke_leighs

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function New-Shortcut {
    <#
    .SYNOPSIS
        Creates a new shortcut with a specified icon.

    .DESCRIPTION
        This function creates a new shortcut at the specified location with a given source file location and icon.

    .PARAMETER SourceFileLocation
        Specifies the source file location or URL for the shortcut target.

    .PARAMETER ShortcutLocation
        Specifies the location where the shortcut will be created.

    .PARAMETER IconLocation
        Specifies the location of the icon file to be used for the shortcut.

    .NOTES
        Author: Luke Leigh
        Website: https://blog.lukeleigh.com
        Twitter: https://twitter.com/luke_leighs

    .EXAMPLE
        Install-Module -Name IconExport
        Import-Module -Name IconExport

        # Set Icon Storage Location
        $IconStorage = [Environment]::GetFolderPath("ApplicationData") + "\Icons"

        # Export Icon
        Export-Icon -Path 'C:\Program Files\Microsoft VS Code\Code.exe' -Type ico -Directory $IconStorage

        # Create a new Shortcut with the icon specified
        New-Shortcut -SourceFileLocation 'https://www.google.co.uk' -ShortcutLocation "$DesktopPath\Google.lnk" -IconLocation "$IconStorage\pwsh-0.ico"

    .LINK
        [Your Blog URL]
        [Reference URL]

    .FUNCTIONALITY
        Creates a shortcut with the specified target and icon.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the source file location or URL for the shortcut target.")]
        [ValidateNotNullOrEmpty()]
        [string]$SourceFileLocation,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the location where the shortcut will be created.")]
        [ValidateNotNullOrEmpty()]
        [string]$ShortcutLocation,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Specifies the location of the icon file to be used for the shortcut.")]
        [ValidateNotNullOrEmpty()]
        [string]$IconLocation
    )

    begin {
        Write-Verbose "Starting New-Shortcut function."
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess("$SourceFileLocation", "Create shortcut with icon.")) {
                Write-Verbose "Creating a new COM object for WScript.Shell."
                $WScriptShell = New-Object -ComObject WScript.Shell
                
                Write-Verbose "Creating a shortcut at $ShortcutLocation."
                $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
                
                Write-Verbose "Setting target path to $SourceFileLocation."
                $Shortcut.TargetPath = $SourceFileLocation
                
                Write-Verbose "Setting icon location to $IconLocation."
                $Shortcut.IconLocation = $IconLocation
                
                Write-Verbose "Setting additional shortcut properties."
                $Shortcut.Arguments = "/s /t 0"
                
                Write-Verbose "Saving the shortcut."
                $Shortcut.Save()

                Write-Output "Shortcut created successfully at $ShortcutLocation."
            }
        }
        catch {
            Write-Error "Failed to create shortcut: $_"
        }
    }

    end {
        Write-Verbose "New-Shortcut function execution completed."
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/New-Shortcut.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Shortcut.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

