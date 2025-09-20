---
layout: post
title: Export-SingleFunction.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/export-singlefunction/
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

Exports a specific function from a PowerShell script/module to a separate .ps1 file.

#### Detailed Description

The Export-SingleFunction function reads a PowerShell script/module, identifies a specific function by name, and exports that function's definition to a new .ps1 file in a specified output directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Export-SingleFunction -Path "C:\Scripts\MyModule.psm1" -OutputDirectory "C:\ExportedFunctions" -FunctionName "Get-Data"
```

This example exports the Get-Data function from MyModule.psm1 to a new file named Get-Data.ps1 in the C:\ExportedFunctions directory.

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
    Exports a specific function from a PowerShell script/module to a separate .ps1 file.

.DESCRIPTION
    The Export-SingleFunction function reads a PowerShell script/module, identifies a specific function by name,
    and exports that function's definition to a new .ps1 file in a specified output directory. 

.PARAMETER Path
    The path to the PowerShell script/module file that contains the function.

.PARAMETER OutputDirectory
    The directory where the exported function will be saved as a .ps1 file.

.PARAMETER FunctionName
    The name of the function to export.

.EXAMPLE
    Export-SingleFunction -Path "C:\Scripts\MyModule.psm1" -OutputDirectory "C:\ExportedFunctions" -FunctionName "Get-Data"

    This example exports the Get-Data function from MyModule.psm1 to a new file named Get-Data.ps1 in the C:\ExportedFunctions directory.

.NOTES
    Author: Your Name
    Date: June 30, 2024
#>
function Export-SingleFunction {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory,
        
        [Parameter(Mandatory = $true)]
        [string]$FunctionName
    )

    # Ensure the output directory exists
    Write-Verbose "Checking if the output directory exists."
    if (-not (Test-Path -Path $OutputDirectory)) {
        Write-Verbose "Creating output directory at $OutputDirectory."
        New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    }
    
    # Check if the path is valid
    Write-Verbose "Validating the script path."
    if (-not (Test-Path -Path $Path)) {
        Write-Error "The specified path is empty or the file does not exist."
        return
    }
    
    Write-Verbose "Reading content from $Path."
    $scriptContent = Get-Content -Path $Path -Raw

    # Regex to find the function content
    $functionPattern = "([Ff]unction\s+$FunctionName\s*\{.*?^\})"
    $functionMatch = [regex]::Match($scriptContent, $functionPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if ($functionMatch.Success) {
        $functionContent = $functionMatch.Groups[1].Value
        Write-Verbose "Function $FunctionName found. Length: $($functionContent.Length) characters."

        $outputFilePath = Join-Path -Path $OutputDirectory -ChildPath "$FunctionName.ps1"
        
        # Save the function to a .ps1 file
        Write-Output "Exporting function to $outputFilePath."
        try {
            Set-Content -Path $outputFilePath -Value $functionContent
            Write-Verbose "Successfully exported function to $outputFilePath."
        }
        catch {
            Write-Error "Error exporting the function to file: $_"
            return
        }

        Write-Output "Exported function $FunctionName to $outputFilePath."
    }
    else {
        Write-Error "Function $FunctionName not found in the specified script."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Export-SingleFunction.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-SingleFunction.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

