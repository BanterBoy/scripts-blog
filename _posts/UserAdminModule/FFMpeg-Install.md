---
layout: post
title: FFMpeg-Install.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/FFMpeg-Install/
categories:
- UserAdminModule
- MediaManagement
tags:
- PowerShell
- User Admin Module
- FF Mpeg Install
- FF
description: Install FFmpeg quickly on Windows devices that use the UserAdminModule
  toolkit.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Install FFmpeg quickly on Windows devices that use the UserAdminModule toolkit.

#### Detailed Description

`FFMpeg-Install` validates that the current PowerShell session is running with administrative privileges before handing off to Chocolatey to install FFmpeg. The function ensures that installation is attempted only when elevated and relies on Chocolatey to deliver the latest FFmpeg package along with its required binaries.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
FFMpeg-Install
```

Run the function from an elevated PowerShell session to install FFmpeg via Chocolatey. The function exits with an error if elevation is missing so the installation never proceeds without administrator rights.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- Requires Chocolatey to be available on the target machine.
- Must be run from an elevated PowerShell session. Non-administrative sessions receive a clear error message and the install command does not run.
- Installs the FFmpeg toolset so that additional media functions in the module can call `ffmpeg` and `ffprobe`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
#Requires -PSEdition Core

<#
    .DESCRIPTION
        Installs FFMpeg using Chocolatey. Requires admin privileges.
#>
function FFMpeg-Install {
    # test if admin
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "You must run this script as an administrator."

        return
    }

    choco install ffmpeg -y
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/FFMpeg-Install.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=FFMpeg-Install.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>
