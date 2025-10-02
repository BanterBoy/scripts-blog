---
layout: post
title: Get-AllDomainControllers.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-alldomaincontrollers/
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

Retrieves information about all domain controllers in the current domain.

#### Detailed Description

The Get-AllDomainControllers function retrieves information about all domain controllers in the current domain. It uses the Get-ADDomainController cmdlet to query the domain controllers and returns a custom object with the hostname, site, and operating system of each domain controller.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-AllDomainControllers
```

This example retrieves information about all domain controllers in the current domain and displays the hostname, site, and operating system of each domain controller.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Current Date Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Retrieves information about all domain controllers in the current domain.

.DESCRIPTION
The Get-AllDomainControllers function retrieves information about all domain controllers in the current domain. It uses the Get-ADDomainController cmdlet to query the domain controllers and returns a custom object with the hostname, site, and operating system of each domain controller.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-AllDomainControllers

This example retrieves information about all domain controllers in the current domain and displays the hostname, site, and operating system of each domain controller.

.OUTPUTS
System.Management.Automation.PSCustomObject
The function returns a custom object with the following properties:
- Hostname: The hostname of the domain controller.
- Site: The site where the domain controller is located.
- OperatingSystem: The operating system running on the domain controller.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0
#>
#requires -PSEdition Desktop

Function Get-AllDomainControllers {
    Get-ADDomainController -Filter * -Server (Get-ADDomain).DNSRoot | Select-Object Hostname,Site,OperatingSystem
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-AllDomainControllers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AllDomainControllers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

