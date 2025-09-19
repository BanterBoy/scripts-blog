---
layout: post
title: Get-VMInformationPlus.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-VMInformationPlus/
categories:
  - UserAdminModule
  - Virtualization
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

Retrieves information about virtual machines from a vCenter server.

#### Detailed Description

The Get-VMInformation function retrieves information about virtual machines from a vCenter server. It accepts the vCenter server name and an optional virtual machine name as parameters. If a virtual machine name is provided, it retrieves information for that specific virtual machine. If no virtual machine name is provided, it retrieves information for all virtual machines on the vCenter server.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-VMInformation -vCenter "vCenterServer" -Name "VM1"
```

Retrieves information for the virtual machine named "VM1" from the "vCenterServer".

**Example 2**

```powershell
Get-VMInformation -vCenter "vCenterServer"
```

Retrieves information for all virtual machines from the "vCenterServer".

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the VMware PowerCLI module to be installed.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# CoPilot Attempt to get VM information from vCenter

<#
.SYNOPSIS
Retrieves information about virtual machines from a vCenter server.

.DESCRIPTION
The Get-VMInformation function retrieves information about virtual machines from a vCenter server. It accepts the vCenter server name and an optional virtual machine name as parameters. If a virtual machine name is provided, it retrieves information for that specific virtual machine. If no virtual machine name is provided, it retrieves information for all virtual machines on the vCenter server.

.PARAMETER vCenter
The name of the vCenter server.

.PARAMETER Name
The name of the virtual machine. This parameter is optional. If not provided, information for all virtual machines on the vCenter server will be retrieved.

.EXAMPLE
Get-VMInformation -vCenter "vCenterServer" -Name "VM1"
Retrieves information for the virtual machine named "VM1" from the "vCenterServer".

.EXAMPLE
Get-VMInformation -vCenter "vCenterServer"
Retrieves information for all virtual machines from the "vCenterServer".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function outputs a custom object containing information about the virtual machines.

.NOTES
This function requires the VMware PowerCLI module to be installed.

.LINK
https://github.com/username/repo

#>

function Get-VMInformation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$vCenter,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Name
    )

    BEGIN {}

    PROCESS {
        $VMs = Get-VM -Server $vCenter -Name $Name

        $Count = $VMs.Count
        $i = 1

        foreach ($Object in $VMs) {
            try {
                $CPUUsage = ($Object | Get-Stat -Stat cpu.usage.average -Start (Get-Date).AddMinutes(-5) -IntervalMins 5 | Measure-Object -Property Value -Average).Average
                $MemoryUsage = ($Object | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddMinutes(-5) -IntervalMins 5 | Measure-Object -Property Value -Average).Average
                $DiskUsage = ($Object | Get-HardDisk | Measure-Object -Property CapacityGB -Sum).Sum
                $DiskCapacity = ($Object | Get-HardDisk | Measure-Object -Property CapacityGB -Sum).Sum
                $SnapshotCount = ($Object | Get-Snapshot | Measure-Object).Count
                $ResourcePool = ($Object | Get-ResourcePool | Select-Object -ExpandProperty Name) -join ', '
                $CustomAttributes = ($Object | Get-CustomAttribute | Select-Object -Property Name, Value) -join ', '
                $AlarmStatus = ($Object | Get-AlarmActionTriggeredEvent | Select-Object -Property CreatedTime, Alarm, FullFormattedMessage) -join ', '
                $PerformanceMetrics = @{
                    CPUUsage     = $CPUUsage
                    MemoryUsage  = $MemoryUsage
                    DiskUsage    = $DiskUsage
                    DiskCapacity = $DiskCapacity
                }

                $VMInfo = @{
                    Name               = $Object.Name
                    PowerState         = $Object.PowerState
                    vCenter            = $vCenter
                    Datacenter         = $Object.VMHost | Get-Datacenter | Select-Object -ExpandProperty Name
                    Cluster            = $Object.VMhost | Get-Cluster | Select-Object -ExpandProperty Name
                    VMHost             = $Object.VMhost
                    Datastore          = ($Object | Get-Datastore | Select-Object -ExpandProperty Name) -join ', '
                    FolderName         = $Object.Folder
                    GuestOS            = $Object.ExtensionData.Config.GuestFullName
                    NetworkName        = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty NetworkName) -join ', '
                    IPAddress          = ($Object.ExtensionData.Summary.Guest.IPAddress) -join ', '
                    MacAddress         = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty MacAddress) -join ', '
                    VMTools            = $Object.ExtensionData.Guest.ToolsVersionStatus2
                    SnapshotCount      = $SnapshotCount
                    ResourcePool       = $ResourcePool
                    CustomAttributes   = $CustomAttributes
                    AlarmStatus        = $AlarmStatus
                    PerformanceMetrics = $PerformanceMetrics
                }

                Write-Output $VMInfo
            }
            catch {
                Write-Error $_.Exception.Message
            }
            finally {
                if ($PSBoundParameters.ContainsKey("Name")) {
                    $PercentComplete = ($i / $Count).ToString("P")
                    Write-Progress -Activity "Processing VM: $($Object.Name)" -Status "$i/$count : $PercentComplete Complete" -PercentComplete $PercentComplete.Replace("%", "")
                    $i++
                }
                else {
                    Write-Progress -Activity "Processing VM: $($Object.Name)" -Status "Completed: $i"
                    $i++
                }
            }
        }
    }

    END {}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-VMInformationPlus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-VMInformationPlus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

