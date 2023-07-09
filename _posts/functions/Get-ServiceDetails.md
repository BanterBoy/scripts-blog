---
layout: post
title: Get-ServiceDetails.ps1
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
function Get-ServiceDetails {
    [cmdletbinding(DefaultParameterSetName = 'default')]

    param(
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the ComputerName or Pipe in from another command.")]
        [Alias('computer')]
        [string[]]$ComputerName = ".",

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the DisplayName or Pipe in from another command.")]
        [Alias('display')]
        [string[]]$DisplayName = "*"
    )

    BEGIN {

    }

    PROCESS {
        $instances = Get-CimInstance -Query "SELECT * FROM Win32_Service" -Namespace "root/CIMV2" -Computername $ComputerName | Where-Object { $_.DisplayName -like "$DisplayName" }

        foreach ( $item in $instances ) {
            try {
                $properties = @{
                    AcceptPause             = $item.AcceptPause
                    AcceptStop              = $item.AcceptStop
                    Caption                 = $item.Caption
                    CheckPoint              = $item.CheckPoint
                    CreationClassName       = $item.CreationClassName
                    DelayedAutoStart        = $item.DelayedAutoStart
                    Description             = $item.Description
                    DesktopInteract         = $item.DesktopInteract
                    DisplayName             = $item.DisplayName
                    ErrorControl            = $item.ErrorControl
                    ExitCode                = $item.ExitCode
                    InstallDate             = $item.InstallDate
                    Name                    = $item.Name
                    PathName                = $item.PathName
                    ProcessId               = $item.ProcessId
                    ServiceSpecificExitCode = $item.ServiceSpecificExitCode
                    ServiceType             = $item.ServiceType
                    Started                 = $item.Started
                    StartMode               = $item.StartMode
                    StartName               = $item.StartName
                    State                   = $item.State
                    Status                  = $item.Status
                    SystemCreationClassName = $item.SystemCreationClassName
                    SystemName              = $item.SystemName
                    TagId                   = $item.TagId
                    WaitHint                = $item.WaitHint
                }
            }
            catch {
                $properties = @{
                    AcceptPause             = $item.AcceptPause
                    AcceptStop              = $item.AcceptStop
                    Caption                 = $item.Caption
                    CheckPoint              = $item.CheckPoint
                    CreationClassName       = $item.CreationClassName
                    DelayedAutoStart        = $item.DelayedAutoStart
                    Description             = $item.Description
                    DesktopInteract         = $item.DesktopInteract
                    DisplayName             = $item.DisplayName
                    ErrorControl            = $item.ErrorControl
                    ExitCode                = $item.ExitCode
                    InstallDate             = $item.InstallDate
                    Name                    = $item.Name
                    PathName                = $item.PathName
                    ProcessId               = $item.ProcessId
                    ServiceSpecificExitCode = $item.ServiceSpecificExitCode
                    ServiceType             = $item.ServiceType
                    Started                 = $item.Started
                    StartMode               = $item.StartMode
                    StartName               = $item.StartName
                    State                   = $item.State
                    Status                  = $item.Status
                    SystemCreationClassName = $item.SystemCreationClassName
                    SystemName              = $item.SystemName
                    TagId                   = $item.TagId
                    WaitHint                = $item.WaitHint
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }

    END {

    }

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-ServiceDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServiceDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
