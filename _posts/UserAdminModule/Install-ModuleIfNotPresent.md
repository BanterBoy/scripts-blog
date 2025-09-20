---
layout: post
title: Install-ModuleIfNotPresent.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Install-ModuleIfNotPresent/
categories:
- UserAdminModule
- Shell
tags:
- PowerShell
- User Admin Module
- Module If Not Present
description: Installs a PowerShell module if it is not already present and imports
  it.
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

Installs a PowerShell module if it is not already present and imports it.

#### Detailed Description

The Install-ModuleIfNotPresent function checks if a specified PowerShell module is already installed. If the module is installed, it imports the module. If the module is not installed, it installs the module from a specified repository, and then imports the module.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Install-ModuleIfNotPresent -ModuleName "AzureRM" -Repository "PSGallery"
```

This example installs the "AzureRM" module from the "PSGallery" repository if it is not already installed, and then imports the module.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Installs a PowerShell module if it is not already present and imports it.

.DESCRIPTION
The Install-ModuleIfNotPresent function checks if a specified PowerShell module is already installed. If the module is installed, it imports the module. If the module is not installed, it installs the module from a specified repository, and then imports the module.

.PARAMETER ModuleName
The name of the PowerShell module to install and import.

.PARAMETER Repository
The repository from which to install the PowerShell module.

.EXAMPLE
Install-ModuleIfNotPresent -ModuleName "AzureRM" -Repository "PSGallery"
This example installs the "AzureRM" module from the "PSGallery" repository if it is not already installed, and then imports the module.

.INPUTS
None.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Today's Date
#>

function Install-ModuleIfNotPresent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$Repository
    )

    try {
        if ((Get-Module -Name $ModuleName -ListAvailable)) {
            Write-Verbose "Importing module - $($ModuleName)"
            Import-Module -Name $ModuleName
        }
        Else {
            Write-Verbose "Installing module - $($ModuleName)"
            Install-Module -Name $ModuleName -Repository $Repository -Force -ErrorAction Stop
            Import-Module -Name $ModuleName
        }
    }
    catch {
        Write-Error -Message $_.Exception.Message
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Install-ModuleIfNotPresent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-ModuleIfNotPresent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

