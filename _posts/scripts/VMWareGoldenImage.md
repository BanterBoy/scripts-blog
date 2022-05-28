---
layout: post
title: VMWareGoldenImage.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
######################################################
###              Template Definition               ###
######################################################

# VM Name
$VMName = "MyNewVM01"

# Automatic Start Action (Nothing = 0, Start =1, StartifRunning = 2)
$AutoStartAction = 1
# In second
$AutoStartDelay = 10
# Automatic Start Action (TurnOff = 0, Save =1, Shutdown = 2)
$AutoStopAction = 2

###### Hardware Configuration ######
# VM Path
$VMPath = "D:\"

# VM Generation (1 or 2)
$Gen = 2

# Processor Number
$ProcessorCount = 4

## Memory (Static = 0 or Dynamic = 1)
$Memory = 1
# StaticMemory
$StaticMemory = 8GB

# DynamicMemory
$StartupMemory = 2GB
$MinMemory = 1GB
$MaxMemory = 4GB

# Sysprep VHD path (The VHD will be copied to the VM folder)
$SysVHDPath = "D:\OperatingSystem-W2012R2DTC.vhdx"
# Rename the VHD copied in VM folder to:
$OsDiskName = $VMName

### Additional virtual drives
$ExtraDrive = @()
# Drive 1
$Drive = New-Object System.Object
$Drive       | Add-Member -MemberType NoteProperty -Name Name -Value Data
$Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
$Drive       | Add-Member -MemberType NoteProperty -Name Size -Value 10GB
$Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Dynamic
$ExtraDrive += $Drive

# Drive 2
$Drive = New-Object System.Object
$Drive       | Add-Member -MemberType NoteProperty -Name Name -Value Bin
$Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
$Drive       | Add-Member -MemberType NoteProperty -Name Size -Value 20GB
$Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Fixed
$ExtraDrive += $Drive
# You can copy/delete this below block as you wish to create (or not) and attach several VHDX

### Network Adapters
# Primary Network interface: VMSwitch
$VMSwitchName = "LS_VMWorkload"
$VlanId = 0
$VMQ = $False
$IPSecOffload = $False
$SRIOV = $False
$MacSpoofing = $False
$DHCPGuard = $False
$RouterGuard = $False
$NicTeaming = $False

## Additional NICs
$NICs = @()

# NIC 1
$NIC = New-Object System.Object
$NIC   | Add-Member -MemberType NoteProperty -Name VMSwitch -Value "LS_VMWorkload"
$NIC   | Add-Member -MemberType NoteProperty -Name VLAN -Value 10
$NIC   | Add-Member -MemberType NoteProperty -Name VMQ -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name IPsecOffload -Value $True
$NIC   | Add-Member -MemberType NoteProperty -Name SRIOV -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name MacSpoofing -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name DHCPGuard -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name RouterGuard -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name NICTeaming -Value $False
$NICs += $NIC

#NIC 2
$NIC = New-Object System.Object
$NIC   | Add-Member -MemberType NoteProperty -Name VMSwitch -Value "LS_VMWorkload"
$NIC   | Add-Member -MemberType NoteProperty -Name VLAN -Value 20
$NIC   | Add-Member -MemberType NoteProperty -Name VMQ -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name IPsecOffload -Value $True
$NIC   | Add-Member -MemberType NoteProperty -Name SRIOV -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name MacSpoofing -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name DHCPGuard -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name RouterGuard -Value $False
$NIC   | Add-Member -MemberType NoteProperty -Name NICTeaming -Value $False
$NICs += $NIC
# You can copy/delete the above block and set it for additional NIC

######################################################
###           VM Creation and Configuration        ###
######################################################

## Creation of the VM
# Creation without VHD and with a default memory value (will be changed after)
New-VM -Name $VMName `
    -Path $VMPath `
    -NoVHD `
    -Generation $Gen `
    -MemoryStartupBytes 1GB `
    -SwitchName $VMSwitchName

if ($AutoStartAction -eq 0) { $StartAction = "Nothing" }
Elseif ($AutoStartAction -eq 1) { $StartAction = "Start" }
Else { $StartAction = "StartIfRunning" }

if ($AutoStopAction -eq 0) { $StopAction = "TurnOff" }
Elseif ($AutoStopAction -eq 1) { $StopAction = "Save" }
Else { $StopAction = "Shutdown" }

## Changing the number of processor and the memory
# If Static Memory
if (!$Memory) {

    Set-VM -Name $VMName `
        -ProcessorCount $ProcessorCount `
        -StaticMemory `
        -MemoryStartupBytes $StaticMemory `
        -AutomaticStartAction $StartAction `
        -AutomaticStartDelay $AutoStartDelay `
        -AutomaticStopAction $StopAction
}

# If Dynamic Memory
Else {
    Set-VM -Name $VMName `
        -ProcessorCount $ProcessorCount `
        -DynamicMemory `
        -MemoryMinimumBytes $MinMemory `
        -MemoryStartupBytes $StartupMemory `
        -MemoryMaximumBytes $MaxMemory `
        -AutomaticStartAction $StartAction `
        -AutomaticStartDelay $AutoStartDelay `
        -AutomaticStopAction $StopAction
}

## Set the primary network adapters
$PrimaryNetAdapter = Get-VM $VMName | Get-VMNetworkAdapter
if ($VlanId -gt 0) { $PrimaryNetAdapter | Set-VMNetworkAdapterVLAN -Access -VlanId $VlanId }
else { $PrimaryNetAdapter | Set-VMNetworkAdapterVLAN -untagged }

if ($VMQ) { $PrimaryNetAdapter | Set-VMNetworkAdapter -VmqWeight 100 }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -VmqWeight 0 }

if ($IPSecOffload) { $PrimaryNetAdapter | Set-VMNetworkAdapter -IPsecOffloadMaximumSecurityAssociation 512 }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -IPsecOffloadMaximumSecurityAssociation 0 }

if ($SRIOV) { $PrimaryNetAdapter | Set-VMNetworkAdapter -IovQueuePairsRequested 1 -IovInterruptModeration Default -IovWeight 100 }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -IovWeight 0 }

if ($MacSpoofing) { $PrimaryNetAdapter | Set-VMNetworkAdapter -MacAddressSpoofing on }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -MacAddressSpoofing off }

if ($DHCPGuard) { $PrimaryNetAdapter | Set-VMNetworkAdapter -DHCPGuard on }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -DHCPGuard off }

if ($RouterGuard) { $PrimaryNetAdapter | Set-VMNetworkAdapter -RouterGuard on }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -RouterGuard off }

if ($NicTeaming) { $PrimaryNetAdapter | Set-VMNetworkAdapter -AllowTeaming on }
Else { $PrimaryNetAdapter | Set-VMNetworkAdapter -AllowTeaming off }



## VHD(X) OS disk copy
$OsDiskInfo = Get-Item $SysVHDPath
Copy-Item -Path $SysVHDPath -Destination $($VMPath + "\" + $VMName)
Rename-Item -Path $($VMPath + "\" + $VMName + "\" + $OsDiskInfo.Name) -NewName $($OsDiskName + $OsDiskInfo.Extension)

# Attach the VHD(x) to the VM
Add-VMHardDiskDrive -VMName $VMName -Path $($VMPath + "\" + $VMName + "\" + $OsDiskName + $OsDiskInfo.Extension)

$OsVirtualDrive = Get-VMHardDiskDrive -VMName $VMName -ControllerNumber 0

# Change the boot order to the VHDX first
Set-VMFirmware -VMName $VMName -FirstBootDevice $OsVirtualDrive

# For additional each Disk in the collection
Foreach ($Disk in $ExtraDrive) {
    # if it is dynamic
    if ($Disk.Type -like "Dynamic") {
        New-VHD -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx") `
            -SizeBytes $Disk.Size `
            -Dynamic
    }
    # if it is fixed
    Elseif ($Disk.Type -like "Fixed") {
        New-VHD -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx") `
            -SizeBytes $Disk.Size `
            -Fixed
    }

    # Attach the VHD(x) to the Vm
    Add-VMHardDiskDrive -VMName $VMName `
        -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx")
}

$i = 2
# foreach additional network adapters
Foreach ($NetAdapter in $NICs) {
    # add the NIC
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $NetAdapter.VMSwitch -Name "Network Adapter $i"

    $ExtraNic = Get-VM -Name $VMName | Get-VMNetworkAdapter -Name "Network Adapter $i"
    # Configure the NIC regarding the option
    if ($NetAdapter.VLAN -gt 0) { $ExtraNic | Set-VMNetworkAdapterVLAN -Access -VlanId $NetAdapter.VLAN }
    else { $ExtraNic | Set-VMNetworkAdapterVLAN -untagged }

    if ($NetAdapter.VMQ) { $ExtraNic | Set-VMNetworkAdapter -VmqWeight 100 }
    Else { $ExtraNic | Set-VMNetworkAdapter -VmqWeight 0 }

    if ($NetAdapter.IPSecOffload) { $ExtraNic | Set-VMNetworkAdapter -IPsecOffloadMaximumSecurityAssociation 512 }
    Else { $ExtraNic | Set-VMNetworkAdapter -IPsecOffloadMaximumSecurityAssociation 0 }

    if ($NetAdapter.SRIOV) { $ExtraNic | Set-VMNetworkAdapter -IovQueuePairsRequested 1 -IovInterruptModeration Default -IovWeight 100 }
    Else { $ExtraNic | Set-VMNetworkAdapter -IovWeight 0 }

    if ($NetAdapter.MacSpoofing) { $ExtraNic | Set-VMNetworkAdapter -MacAddressSpoofing on }
    Else { $ExtraNic | Set-VMNetworkAdapter -MacAddressSpoofing off }

    if ($NetAdapter.DHCPGuard) { $ExtraNic | Set-VMNetworkAdapter -DHCPGuard on }
    Else { $ExtraNic | Set-VMNetworkAdapter -DHCPGuard off }

    if ($NetAdapter.RouterGuard) { $ExtraNic | Set-VMNetworkAdapter -RouterGuard on }
    Else { $ExtraNic | Set-VMNetworkAdapter -RouterGuard off }

    if ($NetAdapter.NicTeaming) { $ExtraNic | Set-VMNetworkAdapter -AllowTeaming on }
    Else { $ExtraNic | Set-VMNetworkAdapter -AllowTeaming off }

    $i++
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/VMWareGoldenImage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=VMWareGoldenImage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
