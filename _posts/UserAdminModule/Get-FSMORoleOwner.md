---
layout: post
title: Get-FSMORoleOwner.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-FSMORoleOwner/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- FSMO Role Owner
- FSMO
description: A set of functions to provide the ability to manage Active Directory
  FSMO Roles.
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

A set of functions to provide the ability to manage Active Directory FSMO Roles.

#### Detailed Description

A set of functions to provide the ability to manage Active Directory FSMO Roles.

Functions included; Get-FSMORoleOwner

This CmdLet will export the FSMO roles from your domain. This information is then output in a Table, showing which Domain Controller on the network holds the different FSMO Roles.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-FSMORoleOwner
```

PDCEmulator          : LSERV-DC01.example.com DomainNamingMaster   : LSERV-DC01.example.com InfrastructureMaster : LSERV-DC01.example.com RIDMaster            : LSERV-DC01.example.com SchemaMaster         : LSERV-DC01.example.com

**Example 2**

```powershell
PS C:\> Get-FSMORoleOwner | Select-Object RIDMaster
```

RIDMaster --------- LSERV-DC01.example.com

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://blog.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-FSMORoleOwner {

    <#
    .SYNOPSIS
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    .DESCRIPTION
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    Functions included;
    Get-FSMORoleOwner

    This CmdLet will export the FSMO roles from your domain. This information is then output in a Table,
    showing which Domain Controller on the network holds the different FSMO Roles.

    .EXAMPLE
    PS C:\> Get-FSMORoleOwner

    PDCEmulator          : LSERV-DC01.example.com
    DomainNamingMaster   : LSERV-DC01.example.com
    InfrastructureMaster : LSERV-DC01.example.com
    RIDMaster            : LSERV-DC01.example.com
    SchemaMaster         : LSERV-DC01.example.com

    .EXAMPLE
    PS C:\> Get-FSMORoleOwner | Select-Object RIDMaster

    RIDMaster
    ---------
    LSERV-DC01.example.com

    .INPUTS


    .OUTPUTS
    Get-FSMORoleOwner

    PDCEmulator          : LSERV-DC01.example.com
    DomainNamingMaster   : LSERV-DC01.example.com
    InfrastructureMaster : LSERV-DC01.example.com
    RIDMaster            : LSERV-DC01.example.com
    SchemaMaster         : LSERV-DC01.example.com


    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/MSPTech


#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param (
	
    )
    BEGIN {
        $ForestInfo = (Get-ADForest)
        $DomainInfo = (Get-ADDomain)
    }
    PROCESS {
        $Forest = $ForestInfo | Select-Object DomainNamingMaster, SchemaMaster
        $Domain = $DomainInfo | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
        try {
            $Properties = @{
                PDCEmulator          = $Domain.PDCEmulator
                RIDMaster            = $Domain.RIDMaster
                InfrastructureMaster = $Domain.InfrastructureMaster
                SchemaMaster         = $Forest.SchemaMaster
                DomainNamingMaster   = $Forest.DomainNamingMaster
            }
        }
        catch {
            $Properties = @{
                PDCEmulator          = $Domain.PDCEmulator
                RIDMaster            = $Domain.RIDMaster
                InfrastructureMaster = $Domain.InfrastructureMaster
                SchemaMaster         = $Forest.SchemaMaster
                DomainNamingMaster   = $Forest.DomainNamingMaster
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
    }
    END {
	
    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-FSMORoleOwner.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FSMORoleOwner.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

