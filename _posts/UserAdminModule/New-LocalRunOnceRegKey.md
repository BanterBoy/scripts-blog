---
layout: post
title: New-LocalRunOnceRegKey.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/new-localrunonceregkey/
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

Creates a new RunOnce registry key in the LocalMachine hive.

#### Detailed Description

This function creates a new RunOnce registry key in the LocalMachine hive with the specified key name and value.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-LocalRunOnceRegKey -KeyName "MyKey" -KeyValue "C:\MyApp.exe"
```

This example creates a new RunOnce registry key named "MyKey" with the value "C:\MyApp.exe".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: GitHub Copilot

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-LocalRunOnceRegKey {
    <#
    .SYNOPSIS
    Creates a new RunOnce registry key in the LocalMachine hive.
    
    .DESCRIPTION
    This function creates a new RunOnce registry key in the LocalMachine hive with the specified key name and value.
    
    .PARAMETER KeyName
    The name of the registry key to create.
    
    .PARAMETER KeyValue
    The value to set for the registry key.
    
    .EXAMPLE
    New-LocalRunOnceRegKey -KeyName "MyKey" -KeyValue "C:\MyApp.exe"
    
    This example creates a new RunOnce registry key named "MyKey" with the value "C:\MyApp.exe".
    
    .NOTES
    Author: GitHub Copilot
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$KeyName,
        [Parameter(Mandatory = $true)]
        [string]$KeyValue
    )
    if ([string]::IsNullOrEmpty($KeyName) -or [string]::IsNullOrEmpty($KeyValue)) {
        Write-Error "KeyName and KeyValue cannot be null or empty."
        return $false
    }
    try {
        $reg = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', [Microsoft.Win32.RegistryView]::Default)
        $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
        if ($null -ne $regKey.GetValue($KeyName, $null)) {
            Write-Error "A key with the name $KeyName already exists."
            return $false
        }
        $regKey.SetValue($KeyName, $KeyValue)
        $regKey.Close()
        $reg.Close()
        return $true
    }
    catch {
        Write-Error $_.Exception.Message
        return $false
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/New-LocalRunOnceRegKey.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-LocalRunOnceRegKey.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

