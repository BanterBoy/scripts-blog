---
layout: post
title: Show-RandomCommand.ps1
date: 2025-09-19
permalink: /useradminmodule/shell/show-randomcommand/
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

Displays the help for a random PowerShell command.

#### Detailed Description

The Show-RandomCommand function gets a random command from the Microsoft*, Cim*, and PS* modules and displays its help. If the -showWindow switch is specified, the help is displayed in a separate window.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Show-RandomCommand
```

Displays the help for a random command in the console.

**Example 2**

```powershell
Show-RandomCommand -showWindow
```

Displays the help for a random command in a separate window.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: [Author Name] Date: [Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Show-RandomCommand {

    <#
    .SYNOPSIS
    Displays the help for a random PowerShell command.
    
    .DESCRIPTION
    The Show-RandomCommand function gets a random command from the Microsoft*, Cim*, and PS* modules and displays its help. 
    If the -showWindow switch is specified, the help is displayed in a separate window.
    
    .PARAMETER showWindow
    Displays the help in a separate window.
    
    .EXAMPLE
    Show-RandomCommand
    Displays the help for a random command in the console.
    
    .EXAMPLE
    Show-RandomCommand -showWindow
    Displays the help for a random command in a separate window.
    
    .NOTES
    Author: [Author Name]
    Date: [Date]
    #>

    param (
        [Parameter(ValueFromPipeline = $True)]
        [switch]$showWindow
    )
    if ($showWindow) {
        Get-Command -Module Microsoft*, Cim*, PS* | Get-Random | Get-Help -ShowWindow
    }
    else {
        Get-Command -Module Microsoft*, Cim*, PS* | Get-Random | Get-Help
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Show-RandomCommand.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Show-RandomCommand.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

