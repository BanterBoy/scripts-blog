---
layout: post
title: Get-CurrentUserLogon.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/get-currentuserlogon/
categories:
  - UserAdminModule
  - ADFunctions
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

Retrieves information about currently logged-on users from remote computers.

#### Detailed Description

The Get-CurrentUserLogon function collects information about users currently logged on to remote computers using the quser command. It can target a specific computer, an Organizational Unit (OU), or all computers in the domain.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-CurrentUserLogon -Computer "ComputerName"
```

**Example 2**

```powershell
PS C:\> Get-CurrentUserLogon -OU "OU=Computers,DC=domain,DC=com"
```

**Example 3**

```powershell
PS C:\> Get-CurrentUserLogon -All
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-CurrentUserLogon {
    <#
    .SYNOPSIS
        Retrieves information about currently logged-on users from remote computers.

    .DESCRIPTION
        The Get-CurrentUserLogon function collects information about users currently logged on to remote computers using the quser command.
        It can target a specific computer, an Organizational Unit (OU), or all computers in the domain.

    .PARAMETER Computer
        Enter the Name of the Computer that you would like to gather results for. This parameter wraps the Invoke-Command CmdLet and QUser command line to scan the computer specified and collects the results.

    .PARAMETER OU
        The OU parameter requires you to enter the DistinguishedName of the OU that you would like to scan for computer logon accounts. This parameter wraps the Get-AdComputer and Invoke-Command CmdLets and parses the results in a foreach loop to scan each computer found within the OU specified using the QUser command line and collecting the results.

    .PARAMETER All
        The All parameter will scan All of the computers within the domain for currently logged on accounts. This parameter wraps the Get-AdComputer and Invoke-Command CmdLets and parses the results in a foreach loop to scan each computer found within the domain using the QUser command line and collecting the results.

    .EXAMPLE
        PS C:\> Get-CurrentUserLogon -Computer "ComputerName"

    .EXAMPLE
        PS C:\> Get-CurrentUserLogon -OU "OU=Computers,DC=domain,DC=com"

    .EXAMPLE
        PS C:\> Get-CurrentUserLogon -All

    .OUTPUTS
        PSCustomObject

    .NOTES
        Additional information about the function.
    #>

    [CmdletBinding(DefaultParameterSetName = 'ByComputer')]
    param
    (
        [Parameter(ParameterSetName = 'ByComputer', Position = 0, Mandatory = $true, HelpMessage = 'Enter the Name of the Computer that you would like to gather results for.')]
        [Alias('cn')]
        [string]$Computer,

        [Parameter(ParameterSetName = 'ByOU', Position = 0, Mandatory = $true, HelpMessage = 'Enter the DistinguishedName of the OU that you would like to scan for computer logon accounts.')]
        [string]$OU,

        [Parameter(ParameterSetName = 'ByAll', Position = 0, Mandatory = $true, HelpMessage = 'Scan all computers in the domain.')]
        [switch]$All
    )

    $result = @()

    function Get-QUserResult {
        param (
            [string]$ComputerName
        )
        Invoke-Command -ComputerName $ComputerName -ScriptBlock { quser } -ErrorAction SilentlyContinue | Select-Object -Skip 1 | ForEach-Object {
            $line = $_.Trim() -replace '\s+', ' ' -replace '>', ''
            $fields = $line -split ' '
            [PSCustomObject]@{
                User     = $fields[0]
                Computer = $ComputerName
                Date     = $fields[-2]
                Time     = $fields[-1]
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByComputer') {
        $result = Get-QUserResult -ComputerName $Computer
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByOU') {
        $computers = Get-ADComputer -Filter * -SearchBase $OU -Properties Name
        $computers | ForEach-Object { $result += Get-QUserResult -ComputerName $_.Name }
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByAll') {
        $computers = Get-ADComputer -Filter * -Properties Name
        $computers | ForEach-Object { $result += Get-QUserResult -ComputerName $_.Name }
    }

    $result | Sort-Object Computer, User | Format-Table -AutoSize
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-CurrentUserLogon.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-CurrentUserLogon.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

