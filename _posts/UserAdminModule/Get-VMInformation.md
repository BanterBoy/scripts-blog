---
layout: post
title: Get-VMInformation.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-VMInformation/
categories:
- UserAdminModule
- Virtualization
tags:
- PowerShell
- User Admin Module
- VM Information
- VM
description: Get information from a VM object. Properties include Name, PowerState,
  vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName,...
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

Get information from a VM object. Properties include Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, VMTools

#### Detailed Description

This function retrieves information from a VM object. It returns a custom object with properties such as Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, and VMTools.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-VMInformation -Name "VM1"
```

Retrieves information for the VM with the name "VM1".

**Example 2**

```powershell
Get-VM | Get-VMInformation
```

Retrieves information for all VMs in the pipeline.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Name: Get-VMInformation Author: theSysadminChannel Version: 1.0 DateCreated: 2019-Apr-29

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Get-VMInformation {
    <#
    .SYNOPSIS
    Get information from a VM object. Properties include Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, VMTools

    .DESCRIPTION
    This function retrieves information from a VM object. It returns a custom object with properties such as Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, and VMTools.

    .PARAMETER Name
    Specifies the name of the VM. This parameter is used when the function is called with the -Name parameter.

    .PARAMETER InputObject
    Specifies the VM object. This parameter is used when the function is called with pipeline input.

    .EXAMPLE
    Get-VMInformation -Name "VM1"
    Retrieves information for the VM with the name "VM1".

    .EXAMPLE
    Get-VM | Get-VMInformation
    Retrieves information for all VMs in the pipeline.

    .NOTES   
    Name: Get-VMInformation
    Author: theSysadminChannel
    Version: 1.0
    DateCreated: 2019-Apr-29

    .LINK
    https://thesysadminchannel.com/get-vminformation-using-powershell-and-powercli
    Link to the blog post explaining the usage of the function.

    #>
    [CmdletBinding()]
     
    param(
        [Parameter(
            Position = 0,
            ParameterSetName = "NonPipeline"
        )]
        [string[]]  $Name,

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = "Pipeline"
        )]
        [PSObject[]]  $InputObject
     
    )

    BEGIN {
        if (-not $Global:DefaultVIServer) {
            Write-Error "Unable to continue.  Please connect to a vCenter Server." -ErrorAction Stop
        }
     
        #Verifying the object is a VM
        if ($PSBoundParameters.ContainsKey("Name")) {
            $InputObject = Get-VM $Name
        }
     
        $i = 1
        $Count = $InputObject.Count
    }
     
    PROCESS {
        if (($null -eq $InputObject.VMHost) -and ($null -eq $InputObject.MemoryGB)) {
            Write-Error "Invalid data type. A virtual machine object was not found" -ErrorAction Stop
        }
     
        foreach ($Object in $InputObject) {
            try {
                $vCenter = $Object.Uid -replace ".+@"; $vCenter = $vCenter -replace ":.+"
                [PSCustomObject]@{
                    Name        = $Object.Name
                    PowerState  = $Object.PowerState
                    vCenter     = $vCenter
                    Datacenter  = $Object.VMHost | Get-Datacenter | Select-Object -ExpandProperty Name
                    Cluster     = $Object.VMhost | Get-Cluster | Select-Object -ExpandProperty Name
                    VMHost      = $Object.VMhost
                    Datastore   = ($Object | Get-Datastore | Select-Object -ExpandProperty Name) -join ', '
                    FolderName  = $Object.Folder
                    GuestOS     = $Object.ExtensionData.Config.GuestFullName
                    NetworkName = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty NetworkName) -join ', '
                    IPAddress   = ($Object.ExtensionData.Summary.Guest.IPAddress) -join ', '
                    MacAddress  = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty MacAddress) -join ', '
                    VMTools     = $Object.ExtensionData.Guest.ToolsVersionStatus2
                }
     
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

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-VMInformation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-VMInformation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

