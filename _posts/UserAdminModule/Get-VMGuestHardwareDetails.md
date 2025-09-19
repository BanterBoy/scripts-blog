---
layout: post
title: Get-VMGuestHardwareDetails.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-VMGuestHardwareDetails/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-VMGuestHardwareDetails {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline            = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]$VMName
    )

    Process {
        foreach ($name in $VMName) {
            try {
                # This can return multiple VMs if $name is a wildcard
                $vmList = Get-VM -Name $name -ErrorAction Stop

                foreach ($vm in $vmList) {
                    # Build an array of disk info
                    $hardDisks = $vm.ExtensionData.Config.Hardware.Device |
                        Where-Object { $_.DeviceInfo.Label -like 'Hard disk*' } |
                        ForEach-Object {
                            [PSCustomObject]@{
                                Name       = $_.DeviceInfo.Label
                                CapacityGB = [Math]::Round($_.CapacityInKB / 1MB, 2)
                            }
                        }

                    # Build an array of NIC info (excluding NetworkName if you prefer)
                    $nicDevices = $vm.ExtensionData.Config.Hardware.Device |
                        Where-Object { $_ -is [VMware.Vim.VirtualEthernetCard] } |
                        ForEach-Object {
                            [PSCustomObject]@{
                                Name       = $_.DeviceInfo.Label
                                MacAddress = $_.MacAddress
                            }
                        }

                    # Retrieve IP addresses from the Guest property (can be null)
                    $ipList = if ($vm.Guest -and $vm.Guest.IPAddress) {
                        $vm.Guest.IPAddress
                    } else {
                        @('N/A')
                    }

                    # Construct the final custom object
                    $vmInfo = [PSCustomObject]@{
                        VMName      = $vm.Name
                        PowerState  = $vm.PowerState
                        NumCPU      = $vm.NumCPU
                        MemoryGB    = $vm.MemoryGB
                        GuestOS     = $vm.Guest.OSFullName
                        ToolsStatus = $vm.ExtensionData.Guest.ToolsStatus
                        IPAddresses = $ipList
                        HardDisks   = $hardDisks
                        Networks    = $nicDevices
                    }

                    # Emit the object
                    Write-Output $vmInfo
                }
            }
            catch {
                Write-Warning "Failed to retrieve details for VM '$name': $($_.Exception.Message)"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-VMGuestHardwareDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-VMGuestHardwareDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

