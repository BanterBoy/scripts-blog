---
layout: post
title: DiskCleanup.ps1
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
<#

.SYNOPSIS
Cleans up filesystem of common large and temporary files.

.DESCRIPTION
Cleans up filesystem of common large and temporary files.

.NOTES


#>
param ([switch]$componentcleanup)

Function Get-FreeSpace {
    param (
        $Driveletter,
        [ValidateSet("KB", "MB", "GB")]$unit
    )
    $size = (Get-WmiObject win32_logicaldisk | Where-Object { $_.DeviceID -eq ("$Driveletter" + ":") }).Freespace / '{0}' -f ("1" + $unit)
    Return ('{0:N2}' -f $size)
}


Function Remove-WindowsTempFiles {
    #Cleanup Windows Temp
    try {
        Remove-Item -Recurse $env:systemdrive\Windows\Temp\* -Confirm:$false -ErrorAction SilentlyContinue
    }
    catch [System.IO.IOException] {}
    try {
        #Cleanup windows logs
        Get-Process -Name TrustedInstaller -ErrorAction SilentlyContinue | Stop-Process -Confirm:$false -Force -ErrorAction SilentlyContinue
        Remove-Item -recurse $env:systemdrive\Windows\logs\* -Confirm:$false -Force -ErrorAction SilentlyContinue
        while ((Get-Service TrustedInstaller).Status -ne "Running") {
            Start-Service TrustedInstaller
        }

    }
    catch [System.IO.IOException] {}
}

Function Get-UserProfiles {
    (Get-WMIObject Win32_UserProfile | Where-Object { $_.localpath -notlike "*systemprofile" -and $_.localpath -notlike "*Administrator" -and $_.localpath -notlike "*NetworkService" -and $_.localpath -notlike "*LocalService" -and $_.localpath -notlike "*$env:USERNAME" -and $_.loaded -eq $false })
}
if (!((get-host).Version).Major -gt 4) {
    "requires powershell v4 or higher"
    exit
}

#Cleanup User Profiles
Function Remove-UserProfiles {
    while ((Get-UserProfiles).count -gt 0) {
        try {
            (Get-WMIObject Win32_UserProfile | Where-Object { $_.localpath -notlike "*systemprofile" -and $_.localpath -notlike "*Administrator" -and $_.localpath -notlike "*NetworkService" -and $_.localpath -notlike "*LocalService" -and $_.localpath -notlike "*$env:USERNAME" -and $_.loaded -eq $false }).delete()
        }
        Catch [System.Management.Automation.MethodInvocationException] {
            break
        }
    }
}

#Clean Recycle Bin
Function Clear-RecycleBin {
    $Recycler = (New-Object -ComObject Shell.Application).NameSpace(0xa)
    $Recycler.items() | ForEach-Object { Remove-Item $_.path -force -Recurse }
}

#Clean IIS Logs
function Clear-IISLogs {
    try {
        Get-ChildItem -Recurse 'C:\inetpub\logs' -ErrorAction stop | Where-Object { $_.Name -like "u_ex*" } | Remove-Item -Force -ErrorAction SilentlyContinue
    }
    catch [System.IO.IOException] {
    }
    catch [System.Management.Automation.ItemNotFoundException] {
    }
}

function Clear-ErrorReports {
    try {
        Get-Item $env:windir\Memory.dmp -ErrorAction stop | Remove-Item -force
    }
    catch [System.Management.Automation.ItemNotFoundException] {

    }

    try {
        Get-childitem $env:ALLUSERSPROFILE\Microsoft\Windows\WER\ | Remove-Item -recurse -force
    }
    catch [System.IO.IOException] {
    }

}

function Component-Cleanup {
    $OS = (Get-WmiObject Win32_OperatingSystem).Caption
    switch -Wildcard ($OS) {
        "*2012*" {
            dism.exe /online /Cleanup-Image /StartComponentCleanup
        }
        "*2008 R2*" {
            if (!(Test-Path 'C:\windows\system32\cleanmgr.exe') -or (Test-Path C:\windows\system32\en-us\cleanmgr.exe.mui)) {
                Copy-Item 'C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe' 'C:\windows\system32\cleanmgr.exe' -Force -Confirm:$false
                Copy-Item 'C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui' 'C:\windows\system32\en-us\cleanmgr.exe.mui' -Force -Confirm:$false
            }
            Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/verylowdisk" -Wait
        }
    }

}

function Clear-FontCache {
    $fontfiles = Get-ChildItem "$($env:systemdrive)\Windows\ServiceProfiles\LocalService\AppData\Local" -Recurse -Filter "*FontCache*"
    $fontfiles | ForEach-Object {
        $acl = Get-Acl $_.FullName
        $permission = "$($env:username)", "FullControl", "Allow"
        $accessrule = New-Object system.security.accesscontrol.filesystemaccessrule $permission
        $acl.AddAccessRule($accessrule)
        $acl | Set-Acl $_.FullName -ErrorAction SilentlyContinue
    }
    Stop-Service "BITS"
    Stop-Service "FontCache"
    Stop-Service "SENS" -Force
    Stop-Service "COMSysApp"
    Stop-Service "EventSystem" -Force
    Remove-Item "$($env:systemdrive)\Windows\ServiceProfiles\LocalService\AppData\Local\*.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
    Start-Service "EventSystem"
    Start-Service "BITS"
    Start-Service "FontCache"
    Start-Service "SENS"
    Start-Service "COMSysApp"
}

function Clear-CCMCache {
    $ccmfolders = Get-Childitem "$($env:systemroot)\ccmcache" -ErrorAction SilentlyContinue
    $ccmfolders | ForEach-Object {
        $acl = Get-Acl $_.FullName
        $permission = "$($env:username)", "FullControl", "Allow"
        $accessrule = New-Object system.security.accesscontrol.filesystemaccessrule $permission
        $acl.AddAccessRule($accessrule)
        $acl | Set-Acl $_.FullName -ErrorAction SilentlyContinue
        Remove-Item $_.FullName -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    }
}

function Clear-Sophos {
    $sophoscache = Get-ChildItem "$($env:programdata)\Sophos\AutoUpdate\Cache"
    $sophoscache | ForEach-Object {
        $acl = get-acl $_.FullName
        $permission = "$($env:username)", "FullControl", "Allow"
        $accessrule = New-Object system.security.accesscontrol.filesystemaccessrule $permission
        $acl.AddAccessRule($accessrule)
        $acl | Set-Acl $_.FullName -ErrorAction SilentlyContinue
        Remove-Item $_.FullName -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    }
}

function Component-Cleanup2012 {
    $OS = (Get-WmiObject Win32_OperatingSystem).Caption
    switch -Wildcard ($OS) {
        "*2012*" {
            dism.exe /online /Cleanup-Image /StartComponentCleanup
        }
    }
}

function Find-SQLDatabases {
    $databases = Get-ChildItem -recurse "$($env:programfiles)\Microsoft SQL Server" -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*.*df" -and $_.Name -inotlike "master.*df" -and $_.Name -inotlike "model.*df" -and $_.Name -inotlike "msdbdata.*df" }
    if ($databases) {
        Write-Host  -BackgroundColor RED "WARNING: The Following databases exist on $($env:systemdrive) and should be moved."
        $databases | Sort-Object length -Descending  | Select-Object Name, @{Name = "DB Size MB"; Expression = { [math]::round($($_.length / 1MB), 2) } } -first 5
    }
}

#Get Free Space before clearing anything.
$initialsize = Get-FreeSpace -Driveletter C -unit GB

#Check if running as Administrator
#if ($host.UI.RawUI.WindowTitle -notlike "Administrator:*") {
#    throw "Powershell not running as Administrator. `n Run as Administrator and try again"
#}

#Begin Cleanup
Remove-WindowsTempFiles
Remove-UserProfiles
Clear-RecycleBin
Clear-IISLogs
Clear-ErrorReports
Clear-FontCache
Clear-CCMCache
Clear-Sophos
Component-Cleanup2012
Find-SQLDatabases

if ($componentcleanup) {
    Component-Cleanup
}

#End Cleanup

$Newsize = Get-FreeSpace -Driveletter C -unit GB

#Calculate Space Saved.
$Clearedspace = '{0:N2} GB' -f ($Newsize - $initialsize )
Write-Host "Successfully Cleared $Clearedspace"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/DiskCleanup.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=DiskCleanup.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
