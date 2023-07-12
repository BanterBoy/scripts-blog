---
layout: post
title: FSMOFunctions.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

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
    Set-FSMORolePDCEmulator
    Set-FSMORoleRIDMaster
    Set-FSMORoleInfrastructureMaster
    Set-FSMORoleSchemaMaster
    Set-FSMORoleDomainNamingMaster
    Move-FSMORolestoPDCEmulator

    Wrapper for the Move-ADDirectoryServerOperationMasterRole command.
    Operation Master Roles
    PDCEmulator or 0
    RIDMaster or 1
    InfrastructureMaster or 2
    SchemaMaster or 3
    DomainNamingMaster or 4


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

    .EXAMPLE
    PS C:\> Set-FSMORolePDCEmulator -PDCEmulator DOMAINCONTROLLERNAME

    Move Operation Master Role
    Do you want to move role 'PDCEmulator' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .EXAMPLE
    PS C:\> Set-FSMORoleRIDMaster -RIDMaster DOMAINCONTROLLERNAME

    Move Operation Master Role
    Do you want to move role 'RIDMaster' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .EXAMPLE
    PS C:\> Set-FSMORoleInfrastructureMaster -InfrastructureMaster DOMAINCONTROLLERNAME

    Move Operation Master Role
    Do you want to move role 'InfrastructureMaster' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .EXAMPLE
    PS C:\> Set-FSMORoleSchemaMaster -SchemaMaster DOMAINCONTROLLERNAME

    Move Operation Master Role
    Do you want to move role 'SchemaMaster' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .EXAMPLE
    PS C:\> Set-FSMORoleDomainNamingMaster -DomainNamingMaster DOMAINCONTROLLERNAME

    Move Operation Master Role
    Do you want to move role 'DomainNamingMaster' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .EXAMPLE
    PS C:\> Move-FSMORolestoPDCEmulator

    Move Operation Master Role
    Do you want to move role 'InfrastructureMaster' to server 'DOMAINCONTROLLERNAME.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .INPUTS
    Each SET function accepts piped input. All SET functions are strings.
    $PDCEmulator
    $RIDMaster
    $InfrastructureMaster
    $SchemaMaster
    $DomainNamingMaster

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

function Get-FSMORoleOwner {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog',
        SupportsShouldProcess = $true)]

    $ForestInfo = Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
    $DomainInfo = Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster

    try {
        $Properties = @{
            PDCEmulator          = $DomainInfo.PDCEmulator
            RIDMaster            = $DomainInfo.RIDMaster
            InfrastructureMaster = $DomainInfo.InfrastructureMaster
            SchemaMaster         = $ForestInfo.SchemaMaster
            DomainNamingMaster   = $ForestInfo.DomainNamingMaster
        }
    }
    catch {
        $Properties = @{
            PDCEmulator          = $DomainInfo.PDCEmulator
            RIDMaster            = $DomainInfo.RIDMaster
            InfrastructureMaster = $DomainInfo.InfrastructureMaster
            SchemaMaster         = $ForestInfo.SchemaMaster
            DomainNamingMaster   = $ForestInfo.DomainNamingMaster
        }
    }
    finally {
        $obj = New-Object -TypeName PSObject -Property $Properties
        Write-Output $obj
    }
}

function Set-FSMORolePDCEmulator {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the PDCEmulator FSMO Role")]
        [Alias('PDC')]
        [String]$PDCEmulator
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $PDCEmulator -OperationMasterRole 0
}

function Set-FSMORoleRIDMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the RIDMaster FSMO Role")]
        [Alias('RID')]
        [String]$RIDMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $RIDMaster -OperationMasterRole 1
}

function Set-FSMORoleInfrastructureMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the InfrastructureMaster FSMO Role")]
        [Alias('Infra')]
        [String]$InfrastructureMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $InfrastructureMaster -OperationMasterRole 2
}

function Set-FSMORoleSchemaMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the SchemaMaster FSMO Role")]
        [Alias('Schema')]
        [String]$SchemaMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $SchemaMaster -OperationMasterRole 3
}

function Set-FSMORoleDomainNamingMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the DomainNamingMaster FSMO Role")]
        [Alias('Domain')]
        [String]$DomainNamingMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $DomainNamingMaster -OperationMasterRole 4
}

function Move-FSMORolestoPDCEmulator {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/scripts-blog')]
    $ForestInfo = Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
    $DomainInfo = Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
    $PrimaryDC = Get-ADDomainController -Discover -Domain $Env:USERDNSDOMAIN -Service 'PrimaryDC'
    if ( $DomainInfo.RIDMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 1
    }
    if ( $DomainInfo.InfrastructureMaster -notmatch $PrimaryDC  ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 2
    }
    if ( $ForestInfo.SchemaMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 3
    }
    if ( $ForestInfo.DomainNamingMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 4
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/FSMOFunctions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=FSMOFunctions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
