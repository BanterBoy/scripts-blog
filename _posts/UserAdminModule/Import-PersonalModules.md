---
layout: post
title: Import-PersonalModules.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Import-PersonalModules/
categories:
  - UserAdminModule
  - ModuleManagement
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

Imports PowerShell modules from a specified category.

#### Detailed Description

The Import-PersonalModules function automates the process of importing PowerShell modules from a specified category. It uses a predefined list of module paths organized by category and ensures that only valid categories are processed. The function supports verbose output for detailed logging and adheres to best practices by using ShouldProcess for confirmation before importing modules.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Import-PersonalModules -Category "Logging"
```

This example imports all modules in the Logging category.

**Example 2**

```powershell
Import-PersonalModules -Category "Azure" -Verbose
```

This example imports all modules in the Azure category with verbose output enabled.

**Example 3**

```powershell
Import-PersonalModules -Category "Security" -WhatIf
```

This example simulates the import process for the Security category without making any changes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: PowerShell 5.0 or later

REQUIREMENTS

- **PowerShell Version**: This function requires PowerShell 5.0 or later.

- **Module Paths**: The modules must exist in the specified paths relative to the script's location ($PSScriptRoot).

BEST PRACTICES

- **Validate Module Paths**: Ensure that the module paths are correct and accessible before running the function.

- **Use Verbose Output**: Enable verbose output (-Verbose) to monitor the import process and troubleshoot issues.

- **Test with WhatIf**: Use the -WhatIf parameter to simulate the import process without making changes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Imports PowerShell modules from a specified category.

.DESCRIPTION
The Import-PersonalModules function automates the process of importing PowerShell modules from a specified category.
It uses a predefined list of module paths organized by category and ensures that only valid categories are processed.
The function supports verbose output for detailed logging and adheres to best practices by using ShouldProcess for confirmation before importing modules.

.PARAMETER Category
Specifies the category of modules to import. Valid categories include:
 - ADFunctions
 - Azure
 - EnvironmentManagement
 - Exchange
 - FileOperations
 - Logging
 - MediaManagement
 - Network
 - PKICertificateTools
 - RemoteConnections
 - Replication
 - Security
 - Shell
 - ShutdownCommands
 - Teams
 - Testing
 - CertificateUtilities
 - JekyllBlog
 - Virtualization
 - PrintManagement
 - Utilities

This parameter is mandatory and defaults to the Category parameter set.

.EXAMPLE
Import-PersonalModules -Category "Logging"
This example imports all modules in the Logging category.

.EXAMPLE
Import-PersonalModules -Category "Azure" -Verbose
This example imports all modules in the Azure category with verbose output enabled.

.EXAMPLE
Import-PersonalModules -Category "Security" -WhatIf
This example simulates the import process for the Security category without making any changes.

.NOTES
Author: Luke Leigh
Date: April 3, 2025
Requires: PowerShell 5.0 or later

REQUIREMENTS
- **PowerShell Version**: This function requires PowerShell 5.0 or later.
- **Module Paths**: The modules must exist in the specified paths relative to the script's location ($PSScriptRoot).

BEST PRACTICES
- **Validate Module Paths**: Ensure that the module paths are correct and accessible before running the function.
- **Use Verbose Output**: Enable verbose output (-Verbose) to monitor the import process and troubleshoot issues.
- **Test with WhatIf**: Use the -WhatIf parameter to simulate the import process without making changes.

#>

function Import-PersonalModules {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "Category")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Category")]
        [ValidateSet(
            "ADFunctions",
            "Azure",
            "CertificateUtilities",
            "Database",
            "EnvironmentManagement",
            "Exchange",
            "FileOperations",
            "JekyllBlog",
            "Logging",
            "MediaManagement",
            "Network",
            "PKICertificateTools",
            "PrintManagement",
            "ProcessServiceSchedules",
            "RemoteConnections",
            "Replication",
            "Security",
            "Shell",
            "ShutdownCommands",
            "Teams",
            "Testing",
            "Virtualization",
            "Utilities",
            "Weather"
        )]
        [string]$Category
    )

    begin {
        # Define the modules based on your provided list for the selected category
        $modules = @{
            "ADFunctions"             = @(
                "$PSScriptRoot\ADFunctions\ADFunctions.psm1"
            )
            "Azure"                   = @(
                "$PSScriptRoot\Azure\Azure.psm1"
            )
            "CertificateUtilities"    = @(
                "$PSScriptRoot\CertificateUtilities\CertificateUtilities.psm1"
            )
            "Database"                = @(
                "$PSScriptRoot\Database\Database.psm1"
            )
            "EnvironmentManagement"   = @(
                "$PSScriptRoot\EnvironmentManagement\EnvironmentManagement.psm1"
            )
            "Exchange"                = @(
                "$PSScriptRoot\Exchange\Exchange.psm1"
            )
            "FileOperations"          = @(
                "$PSScriptRoot\FileOperations\FileOperations.psm1"
            )
            "JekyllBlog"              = @(
                "$PSScriptRoot\JekyllBlog\JekyllBlog.psm1"
            )
            "Logging"                 = @(
                "$PSScriptRoot\Logging\Logging.psm1"
            )
            "MediaManagement"         = @(
                "$PSScriptRoot\MediaManagement\MediaManagement.psm1"
            )
            "Network"                 = @(
                "$PSScriptRoot\Network\Network.psm1"
            )
            "PKICertificateTools"     = @(
                "$PSScriptRoot\PKICertificateTools\PKICertificateTools.psm1"
            )
            "PrintManagement"         = @(
                "$PSScriptRoot\PrintManagement\PrintManagement.psm1"
            )
            "RemoteConnections"       = @(
                "$PSScriptRoot\RemoteConnections\RemoteConnections.psm1"
            )
            "Replication"             = @(
                "$PSScriptRoot\Replication\Replication.psm1"
            )
            "Security"                = @(
                "$PSScriptRoot\Security\Security.psm1"
            )
            "Shell"                   = @(
                "$PSScriptRoot\Shell\Shell.psm1"
            )
            "ShutdownCommands"        = @(
                "$PSScriptRoot\ShutdownCommands\ShutdownCommands.psm1"
            )
            "ProcessServiceSchedules" = @(
                "$PSScriptRoot\ProcessServiceSchedules\ProcessServiceSchedules.psm1"
            )
            "Teams"                   = @(
                "$PSScriptRoot\Teams\Teams.psm1"
            )
            "Testing"                 = @(
                "$PSScriptRoot\Testing\Testing.psm1"
            )
            "Virtualization"          = @(
                "$PSScriptRoot\Virtualization\Virtualization.psm1"
            )
            "Utilities"               = @(
                "$PSScriptRoot\Utilities\Utilities.psm1"
            )
            "Weather"                 = @(
                "$PSScriptRoot\Weather\Weather.psm1"
            )
        }

        # Initialize an array to store timing results
        $timingResults = @()
    }

    process {
        # Ensure the category exists in the hash table
        if ($modules.ContainsKey($Category)) {
            Write-Verbose "Category '$Category' found. Preparing to import modules."
            $selectedModules = $modules[$Category]

            # Attempt to import each module
            foreach ($module in $selectedModules) {
                if ($PSCmdlet.ShouldProcess($module, "Importing module")) {
                    $moduleStartTime = Get-Date
                    try {
                        if (Test-Path $module) {
                            Write-Verbose "Importing module: $module"
                            Import-Module -Name $module -Force -DisableNameChecking
                            Write-Verbose "Successfully imported module: $module"
                        }
                        else {
                            Write-Warning "Module not found: $module"
                        }
                    }
                    catch {
                        Write-Error "Failed to import module $module. Error: $_"
                    }
                    finally {
                        $moduleEndTime = Get-Date
                        $moduleDuration = $moduleEndTime - $moduleStartTime

                        # Add the timing result to the array
                        $timingResults += [PSCustomObject]@{
                            ModuleName = $module
                            Duration   = "$($moduleDuration.TotalSeconds) seconds"
                        }
                    }
                }
            }

            # Display the timing results as a table if verbose output is enabled
            if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Verbose')) {
                Write-Verbose "Timing results for imported modules:"
                $timingResults | Format-Table -AutoSize
            }
        }
        else {
            Write-Error "Invalid category specified. Please choose from: ADFunctions, Azure, CustomRDGCommands, Database, EnvironmentManagement, Exchange, FileOperations, Logging, MediaManagement, Network, PKICertificateTools, RemoteConnections, Replication, Security, Shell, ShutdownCommands, Teams, CertificateUtilities, JekyllBlog, ProcessServiceSchedules, Virtualization, PrintManagement, Utilities, Weather."
        }
    }

    end {
        Write-Verbose "Import-PersonalModules function completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Import-PersonalModules.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Import-PersonalModules.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

