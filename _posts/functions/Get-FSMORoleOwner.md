---
layout: post
title: Get-FSMORoleOwner.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
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

    PDCEmulator          : DOMAINCONTROLLERNAME.example.com
    DomainNamingMaster   : DOMAINCONTROLLERNAME.example.com
    InfrastructureMaster : DOMAINCONTROLLERNAME.example.com
    RIDMaster            : DOMAINCONTROLLERNAME.example.com
    SchemaMaster         : DOMAINCONTROLLERNAME.example.com

    .EXAMPLE
    PS C:\> Get-FSMORoleOwner | Select-Object RIDMaster

    RIDMaster
    ---------
    DOMAINCONTROLLERNAME.example.com

    .INPUTS


    .OUTPUTS
    Get-FSMORoleOwner

    PDCEmulator          : DOMAINCONTROLLERNAME.example.com
    DomainNamingMaster   : DOMAINCONTROLLERNAME.example.com
    InfrastructureMaster : DOMAINCONTROLLERNAME.example.com
    RIDMaster            : DOMAINCONTROLLERNAME.example.com
    SchemaMaster         : DOMAINCONTROLLERNAME.example.com


    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/scripts-blog


#>

#Requires -Module ActiveDirectory
#Requires -RunAsAdministrator

[CmdletBinding(DefaultParameterSetName = 'Default',
    HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-FSMORoleOwner.ps1')">
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
