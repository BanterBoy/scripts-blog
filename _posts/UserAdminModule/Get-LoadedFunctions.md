---
layout: post
title: Get-LoadedFunctions.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/get-loadedfunctions/
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

Gets a list of loaded functions based on the specified verb and noun.

#### Detailed Description

This function retrieves a list of loaded functions based on the specified verb and noun. If no verb or noun is specified, all loaded functions are returned.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LoadedFunctions -Verb Get -Noun Item
```

This command retrieves a list of loaded functions that have "Get" as the verb and "Item" as the noun.

**Example 2**

```powershell
Get-LoadedFunctions -Wide
```

This command retrieves a list of all loaded functions and displays the output in a wide format.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-LoadedFunctions {
    <#
    .SYNOPSIS
        Gets a list of loaded functions based on the specified verb and noun.
    
    .DESCRIPTION
        This function retrieves a list of loaded functions based on the specified verb and noun. If no verb or noun is specified, all loaded functions are returned.
    
    .PARAMETER Verb
        Specifies the verb to filter the loaded functions by. Wildcards are supported.
    
    .PARAMETER Noun
        Specifies the noun to filter the loaded functions by. Wildcards are supported.
    
    .PARAMETER Wide
        If specified, the output is displayed in a wide format.
    
    .EXAMPLE
        Get-LoadedFunctions -Verb Get -Noun Item
    
        This command retrieves a list of loaded functions that have "Get" as the verb and "Item" as the noun.
    
    .EXAMPLE
        Get-LoadedFunctions -Wide
    
        This command retrieves a list of all loaded functions and displays the output in a wide format.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Verb = "*",
        [Parameter(Mandatory = $false)]
        [string]$Noun = "*",
        [Parameter(Mandatory = $false)]
        [switch]$Wide
    )

    $funcs = Get-Command -CommandType Function | Where-Object -FilterScript { ( $_.Source -eq '' ) -and ( $_.Name -like '*-*' ) } | Select-Object -Property Name

    if ($Verb -ne "*") {
        $funcs = $funcs | Where-Object { $_.Name -like "$Verb-*" }
    }

    if ($Noun -ne "*") {
        $funcs = $funcs | Where-Object { $_.Name -like "*-$Noun" }
    }

    if ($Wide) {
        $funcs | Format-Wide -Autosize
    }
    else {
        return $funcs
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-LoadedFunctions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LoadedFunctions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

