---
layout: post
title: Show-RandomHelpAbout.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/show-randomhelpabout/
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

Displays a random help topic from the about_* help files.

#### Detailed Description

The Show-RandomHelpAbout function displays a random help topic from the about_* help files. By default, the help topic is displayed in the console. If the -showWindow switch is specified, the help topic is displayed in a separate window.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Show-RandomHelpAbout
```

Displays a random help topic in the console.

**Example 2**

```powershell
Show-RandomHelpAbout -showWindow
```

Displays a random help topic in a separate window.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Show-RandomHelpAbout {
    
    <#
    .SYNOPSIS
    Displays a random help topic from the about_* help files.
    
    .DESCRIPTION
    The Show-RandomHelpAbout function displays a random help topic from the about_* help files. By default, the help topic is displayed in the console. If the -showWindow switch is specified, the help topic is displayed in a separate window.
    
    .PARAMETER showWindow
    Displays the help topic in a separate window.
    
    .EXAMPLE
    Show-RandomHelpAbout
    
    Displays a random help topic in the console.
    
    .EXAMPLE
    Show-RandomHelpAbout -showWindow
    
    Displays a random help topic in a separate window.
    
    #>
    
    param (
        [Parameter(ValueFromPipeline = $True)]
        [switch]$showWindow
    )
    if ($showWindow) {
        Get-Random -input (Get-Help about*) | Get-Help -ShowWindow
    }
    else {
        Get-Random -input (Get-Help about*) | Get-Help
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Show-RandomHelpAbout.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Show-RandomHelpAbout.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

