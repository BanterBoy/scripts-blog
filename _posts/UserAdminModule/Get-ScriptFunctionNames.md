---
layout: post
title: Get-ScriptFunctionNames.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/get-scriptfunctionnames/
categories:
  - UserAdminModule
  - Utilities
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

Retrieves the names of all functions defined in a PowerShell script.

#### Detailed Description

The Get-ScriptFunctionNames function reads a PowerShell script, identifies all function definitions, and returns the names of these functions. It uses a regex pattern to match function definitions in the script.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ScriptFunctionNames -Path "C:\Scripts\MyScript.ps1"
```

This example retrieves the names of all functions defined in MyScript.ps1.

**Example 2**

```powershell
"C:\Scripts\MyScript.ps1" | Get-ScriptFunctionNames
```

This example retrieves the names of all functions defined in MyScript.ps1 using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: June 30, 2024

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves the names of all functions defined in a PowerShell script.

.DESCRIPTION
    The Get-ScriptFunctionNames function reads a PowerShell script, identifies all function definitions,
    and returns the names of these functions. It uses a regex pattern to match function definitions in the script.

.PARAMETER Path
    The path to the PowerShell script file that contains the functions.

.EXAMPLE
    Get-ScriptFunctionNames -Path "C:\Scripts\MyScript.ps1"

    This example retrieves the names of all functions defined in MyScript.ps1.

.EXAMPLE
    "C:\Scripts\MyScript.ps1" | Get-ScriptFunctionNames

    This example retrieves the names of all functions defined in MyScript.ps1 using pipeline input.

.NOTES
    Author: Your Name
    Date: June 30, 2024
#>
function Get-ScriptFunctionNames {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Path
    )

    process {
        # Initialize a list to store function names
        [System.Collections.Generic.List[String]]$funcNames = New-Object System.Collections.Generic.List[String]

        # Return the empty list if the path is null or empty
        if ([System.String]::IsNullOrWhiteSpace($Path)) {
            return $funcNames
        }
        
        # Search for function definitions in the script using Select-String
        Select-String -Path "$Path" -Pattern "^[Ff]unction.*[A-Za-z0-9+]-[A-Za-z0-9+]" |
        ForEach-Object {
            # Define the regex pattern to match function definitions
            [System.Text.RegularExpressions.Regex] $regexp = New-Object Regex("(function)( +)([\w-]+)")
            # Match the current line against the regex pattern
            [System.Text.RegularExpressions.Match] $match = $regexp.Match("$_")

            # If a match is found, add the function name to the list
            if ($match.Success) {
                $funcNames.Add($match.Groups[3].Value)
            }   
        }
        
        # Return the list of function names as an array
        return , $funcNames.ToArray()
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-ScriptFunctionNames.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ScriptFunctionNames.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

