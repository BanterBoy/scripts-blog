---
layout: post
title: Get-ExportedFunction.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/get-exportedfunction/
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

Output the commands exported by a specified Module or all currently imported Modules.

#### Detailed Description

This function lists all the commands exported by a specified Module. If no Module is specified, it lists all the commands from all currently imported Modules.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ExportedFunction -Module 'ModuleName'
```

**Example 2**

```powershell
Get-ExportedFunction
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-ExportedFunction {
    <#
    .SYNOPSIS
        Output the commands exported by a specified Module or all currently imported Modules.

    .DESCRIPTION
        This function lists all the commands exported by a specified Module. If no Module is specified,
        it lists all the commands from all currently imported Modules.

    .EXAMPLE
        Get-ExportedFunction -Module 'ModuleName'

    .EXAMPLE
        Get-ExportedFunction
    #>
    param(
        [String]$Module
    )

    if ($Module) {
        # Get commands from the specified Module
        $ModuleObj = Get-Module -Name $Module
        if (-not $ModuleObj) {
            throw "Module '$Module' is not currently imported."
        }
        $functions = $ModuleObj.ExportedCommands.Values.Name
        if (-not $functions) {
            throw "Failed to determine exported commands for: $Module"
        }
        # Output as objects
        foreach ($function in $functions) {
            [PSCustomObject]@{
                Module   = $Module
                Function = $function
            }
        }
    }
    else {
        # Get commands from all currently imported Modules
        $allModules = Get-Module
        if (-not $allModules) {
            throw "No Modules are currently imported."
        }
        foreach ($mod in $allModules) {
            $functions = $mod.ExportedCommands.Values.Name
            if ($functions) {
                foreach ($function in $functions) {
                    [PSCustomObject]@{
                        Module   = $mod.Name
                        Function = $function
                    }
                }
            }
            else {
                [PSCustomObject]@{
                    Module   = $mod.Name
                    Function = "No exported commands"
                }
            }
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-ExportedFunction.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ExportedFunction.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

