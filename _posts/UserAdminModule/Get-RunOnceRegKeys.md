---
layout: post
title: Get-RunOnceRegKeys.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/get-runonceregkeys/
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

Retrieves the names and values of all RunOnce registry keys.

#### Detailed Description

Retrieves the names and values of all RunOnce registry keys on the specified computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RunOnceRegKeys -ComputerName "RemoteComputer01" -Credential (Get-Credential)
```

Retrieves the names and values of all RunOnce registry keys on the computer "RemoteComputer01" using the provided credentials.

**Example 2**

```powershell
Get-RunOnceRegKeys
```

Retrieves the names and values of all RunOnce registry keys on the local computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-RunOnceRegKeys {
    <#
    .SYNOPSIS
        Retrieves the names and values of all RunOnce registry keys.
    .DESCRIPTION
        Retrieves the names and values of all RunOnce registry keys on the specified computer.
    .EXAMPLE
        Get-RunOnceRegKeys -ComputerName "RemoteComputer01" -Credential (Get-Credential)
        Retrieves the names and values of all RunOnce registry keys on the computer "RemoteComputer01" using the provided credentials.
    .EXAMPLE
        Get-RunOnceRegKeys
        Retrieves the names and values of all RunOnce registry keys on the local computer.
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    # Check if the computer is reachable
    if (-not (Test-NetConnection -ComputerName $ComputerName -InformationLevel Quiet)) {
        Write-Error "Cannot reach $ComputerName. Please check the computer name or network connection."
        return $false
    }

    try {
        if ($Credential -ne [System.Management.Automation.PSCredential]::Empty) {
            # Use the provided credentials for the remote connection
            $remoteSession = New-PSSession -ComputerName $ComputerName -Credential $Credential
            $result = Invoke-Command -Session $remoteSession -ScriptBlock {
                param ($remoteComputer)
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $remoteComputer)
                $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
                if ($null -eq $regKey) {
                    throw "Cannot open registry key SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce on $remoteComputer."
                }
                $valueNames = $regKey.GetValueNames()
                $values = $valueNames | ForEach-Object { 
                    [PSCustomObject]@{
                        Name  = $_
                        Value = $regKey.GetValue($_)
                    }
                }
                return $values
            } -ArgumentList $ComputerName
            Remove-PSSession -Session $remoteSession
            return $result
        }
        else {
            # No credentials provided, direct registry access
            $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $ComputerName)
            $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
            if ($null -eq $regKey) {
                Write-Error "Cannot open registry key SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce on $ComputerName."
                return $false
            }
            $valueNames = $regKey.GetValueNames()
            $values = $valueNames | ForEach-Object { 
                [PSCustomObject]@{
                    Name  = $_
                    Value = $regKey.GetValue($_)
                }
            }
            return $values
        }
    }
    catch {
        Write-Error "Failed to get RunOnce registry keys from $ComputerName. $_"
        return $false
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-RunOnceRegKeys.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RunOnceRegKeys.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

