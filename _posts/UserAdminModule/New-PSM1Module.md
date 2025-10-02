---
layout: post
title: New-PSM1Module.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/new-psm1module/
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

Creates a new PowerShell module (.psm1) file and its associated folder structure.

#### Detailed Description

The New-PSM1Module function automates the creation of a PowerShell module by generating a .psm1 file and ensuring the required folder structure exists. It creates Public and Private subfolders within the specified folder path if they do not already exist. The .psm1 file is populated with boilerplate code to automatically dot-source .ps1 files from the Public and Private folders and export public functions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-PSM1Module -folderPath "C:\Modules\MyModule"
```

This example creates a new PowerShell module in the C:\Modules\MyModule folder. It ensures the Public and Private subfolders exist and generates a .psm1 file named MyModule.psm1.

**Example 2**

```powershell
New-PSM1Module -folderPath "D:\Scripts\CustomModule" -Verbose
```

This example creates a new PowerShell module in the D:\Scripts\CustomModule folder with verbose output enabled.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: [Your Name] Date: April 3, 2025 Requires: PowerShell 5.0 or later

- PowerShell Version: This function requires PowerShell 5.0 or later.

- Write Permissions: The user running this function must have write permissions to the specified folder path.

- Organize Functions: Place public functions in the Public folder and private/internal functions in the Private folder.

- Version Control: Use version control (e.g., Git) to track changes to the module and its functions.

- Test the Module: After creating the module, test it to ensure all functions are properly imported and exported.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

    .SYNOPSIS
    Creates a new PowerShell module (.psm1) file and its associated folder structure.

    .DESCRIPTION
    The New-PSM1Module function automates the creation of a PowerShell module by generating a .psm1 file and ensuring the required folder structure exists.
    It creates Public and Private subfolders within the specified folder path if they do not already exist.
    The .psm1 file is populated with boilerplate code to automatically dot-source .ps1 files from the Public and Private folders and export public functions.

    .PARAMETER folderPath
    Specifies the path to the folder where the module will be created. The name of the .psm1 file will match the name of the parent folder.

    .EXAMPLE
    New-PSM1Module -folderPath "C:\Modules\MyModule"
    This example creates a new PowerShell module in the C:\Modules\MyModule folder. It ensures the Public and Private subfolders exist and generates a .psm1 file named MyModule.psm1.

    .EXAMPLE
    New-PSM1Module -folderPath "D:\Scripts\CustomModule" -Verbose
    This example creates a new PowerShell module in the D:\Scripts\CustomModule folder with verbose output enabled.

    .NOTES
    Author: [Your Name]
    Date: April 3, 2025
    Requires: PowerShell 5.0 or later
    - PowerShell Version: This function requires PowerShell 5.0 or later.
    - Write Permissions: The user running this function must have write permissions to the specified folder path.
    - Organize Functions: Place public functions in the Public folder and private/internal functions in the Private folder.
    - Version Control: Use version control (e.g., Git) to track changes to the module and its functions.
    - Test the Module: After creating the module, test it to ensure all functions are properly imported and exported.

    #>

function New-PSM1Module {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string]$folderPath
    )

    # Get the name of the parent folder (this will be the name of the .psm1 file)
    $parentFolderName = Split-Path -Leaf $folderPath
    $psm1FilePath = Join-Path -Path $folderPath -ChildPath "$parentFolderName.psm1"

    # Define the paths for Public, Private, Classes, Configuration, and Resources subfolders
    $publicFolderPath = Join-Path -Path $folderPath -ChildPath "Public"
    $privateFolderPath = Join-Path -Path $folderPath -ChildPath "Private"
    $classesFolderPath = Join-Path -Path $folderPath -ChildPath "Classes"
    $configurationFolderPath = Join-Path -Path $folderPath -ChildPath "Configuration"
    $resourcesFolderPath = Join-Path -Path $folderPath -ChildPath "Resources"

    # Check and create Public folder if missing
    if (-not (Test-Path -Path $publicFolderPath)) {
        Write-Verbose "Public folder is missing. Creating Public folder..."
        New-Item -Path $publicFolderPath -ItemType Directory
    }
    else {
        Write-Verbose "Public folder already exists."
    }

    # Check and create Private folder if missing
    if (-not (Test-Path -Path $privateFolderPath)) {
        Write-Verbose "Private folder is missing. Creating Private folder..."
        New-Item -Path $privateFolderPath -ItemType Directory | Out-Null
        # Ensure git tracks the directory
        New-Item -Path (Join-Path -Path $privateFolderPath -ChildPath '.gitkeep') -ItemType File -Force | Out-Null
    }
    else {
        Write-Verbose "Private folder already exists."
    }

    # Check and create Classes folder if missing
    if (-not (Test-Path -Path $classesFolderPath)) {
        Write-Verbose "Classes folder is missing. Creating Classes folder..."
        New-Item -Path $classesFolderPath -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $classesFolderPath -ChildPath '.gitkeep') -ItemType File -Force | Out-Null
    }
    else {
        Write-Verbose "Classes folder already exists."
    }

    # Check and create Configuration folder if missing
    if (-not (Test-Path -Path $configurationFolderPath)) {
        Write-Verbose "Configuration folder is missing. Creating Configuration folder..."
        New-Item -Path $configurationFolderPath -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $configurationFolderPath -ChildPath '.gitkeep') -ItemType File -Force | Out-Null
    }
    else {
        Write-Verbose "Configuration folder already exists."
    }

    # Check and create Resources folder if missing
    if (-not (Test-Path -Path $resourcesFolderPath)) {
        Write-Verbose "Resources folder is missing. Creating Resources folder..."
        New-Item -Path $resourcesFolderPath -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $resourcesFolderPath -ChildPath '.gitkeep') -ItemType File -Force | Out-Null
    }
    else {
        Write-Verbose "Resources folder already exists."
    }

    # Define the exact content for the .psm1 file
    $content = @'
# Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

Export-ModuleMember -Function $Public.Basename
'@

    # Create the .psm1 file and add the content
    Set-Content -Path $psm1FilePath -Value $content -Force

    Write-Verbose "Created psm1 file: $psm1FilePath"
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-PSM1Module.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-PSM1Module.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

