---
layout: post
title: New-StreamDeckShell.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/new-streamdeckshell/
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

Launches a new PowerShell console window suitable for Stream Deck buttons while running under alternate credentials.

#### Detailed Description

Wraps the New-Shell command to guarantee a dedicated console window is created even when invoked from hosts that hide child windows (for example, Stream Deck scripts). This function forces the RunAsUser scenario to use a separate cmd.exe process so the interactive shell remains visible.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$credential = Get-Secret -Name 'lukeleigh.admin'
```

New-StreamDeckShell -Credential $credential

**Example 2**

```powershell
$credential = Get-Secret -Name 'lukeleigh.admin'
```

New-StreamDeckShell -Credential $credential -Shell 'PowerShell' -WindowTitle 'Admin PowerShell'

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-StreamDeckShell {
    <#
    .SYNOPSIS
    Launches a new PowerShell console window suitable for Stream Deck buttons while running under alternate credentials.

    .DESCRIPTION
    Wraps the New-Shell command to guarantee a dedicated console window is created even when invoked from hosts that hide child
    windows (for example, Stream Deck scripts). This function forces the RunAsUser scenario to use a separate cmd.exe process so
    the interactive shell remains visible.

    .PARAMETER Credential
    Credentials used to start the shell session.

    .PARAMETER Shell
    Specifies which shell executable to launch. Valid values are 'pwsh' (PowerShell 7+) and 'PowerShell' (Windows PowerShell).

    .PARAMETER WindowTitle
    Optional console window title applied when the shell is launched.

    .PARAMETER ArgumentList
    Additional arguments that should be passed to the target shell executable.

    .EXAMPLE
    $credential = Get-Secret -Name 'lukeleigh.admin'
    New-StreamDeckShell -Credential $credential

    .EXAMPLE
    $credential = Get-Secret -Name 'lukeleigh.admin'
    New-StreamDeckShell -Credential $credential -Shell 'PowerShell' -WindowTitle 'Admin PowerShell'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $false)]
        [ValidateSet('pwsh', 'PowerShell')]
        [string]
        $Shell = 'pwsh',

        [Parameter(Mandatory = $false)]
        [string]
        $WindowTitle,

        [Parameter(Mandatory = $false)]
        [string[]]
        $ArgumentList = @()
    )

    $runAsUserMap = @{
        pwsh       = 'pwshRunAsUser'
        PowerShell = 'PowerShellRunAsUser'
    }

    $runAsUser = $runAsUserMap[$Shell]

    $parameters = @{
        RunAsUser      = $runAsUser
        Credentials    = $Credential
        ForceNewWindow = $true
    }

    if ($ArgumentList -and $ArgumentList.Count -gt 0) {
        $parameters['ShellArgumentList'] = $ArgumentList
    }

    if ($PSBoundParameters.ContainsKey('WindowTitle') -and -not [string]::IsNullOrWhiteSpace($WindowTitle)) {
        $parameters['WindowTitle'] = $WindowTitle
    }

    New-Shell @parameters
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-StreamDeckShell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-StreamDeckShell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

