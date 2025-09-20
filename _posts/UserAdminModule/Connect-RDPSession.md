---
layout: post
title: Connect-RDPSession.ps1
date: 2025-09-19
permalink: /useradminmodule/remoteconnections/connect-rdpsession/
categories:
  - UserAdminModule
  - RemoteConnections
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Connect-RDPSession` starts the native Remote Desktop client (`mstsc.exe`) for every computer name you supply. The advanced function exposes a `-ComputerName` parameter (alias `-cn`) that accepts single or multiple targets as values or from the pipeline, and honours `WhatIf` / `Confirm` semantics thanks to `SupportsShouldProcess`.

**Usage examples**

```powershell
Connect-RDPSession -ComputerName 'server01'
'rdp01','rdp02' | Connect-RDPSession -WhatIf
```

When a launch fails the function reports the computer as unreachable, otherwise the RDP session window opens immediately.

---

#### Script

```powershell
Function Connect-RDPSession {
        <#
        .SYNOPSIS
                Connect-RDPSession

        .DESCRIPTION
                Connect-RDPSession - Spawn MSTSC and launches an RDP session to a remote computer.

        .PARAMETER ComputerName
                This parameter accepts the Name of the computer you would like to connect to.
                Supports IP/Name/FQDN

        .EXAMPLE
                Connect-RDPSession -ComputerName COMPUTERNAME
                Starts an RDP session to COMPUTERNAME

        .OUTPUTS
                System.String. Connect-RDPSession

        .NOTES
                Author:     Luke Leigh
                Website:    https://scripts.lukeleigh.com/
                LinkedIn:   https://www.linkedin.com/in/lukeleigh/
                GitHub:     https://github.com/BanterBoy/
                GitHubGist: https://gist.github.com/BanterBoy

        .INPUTS
                ComputerName - You can pipe objects to this perameters.

        .LINK
                https://scripts.lukeleigh.com
                Get-Date
                Start-Process
                Write-Output
#>

        [CmdletBinding(DefaultParameterSetName = 'Default',
                PositionalBinding = $true,
                SupportsShouldProcess = $true)]
        [OutputType([string], ParameterSetName = 'Default')]
        [Alias('crdp')]
        Param
        (
                [Parameter(ParameterSetName = 'Default',
                        Mandatory = $false,
                        ValueFromPipeline = $true,
                        ValueFromPipelineByPropertyName = $true,
                        HelpMessage = 'Enter a computer name or pipe input'
                )]
                [Alias('cn')]
                [string[]]$ComputerName
        )

        Begin {

        }

        Process {
                ForEach ($Computer In $ComputerName) {
                        If ($PSCmdlet.ShouldProcess("$($Computer)", "Establish an RDP connection")) {
                                try {
                                        Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$Computer"
                                }
                                catch {
                                        Write-Output "$($Computer): is not reachable."
                                }
                        }
                }
        }

        End {

        }
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Connect-RDPSession.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-RDPSession.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
