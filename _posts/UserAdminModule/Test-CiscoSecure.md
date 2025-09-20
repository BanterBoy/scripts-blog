---
layout: post
title: Test-CiscoSecure.ps1
date: 2025-09-19
permalink: /useradminmodule/testing/test-ciscosecure/
categories:
  - UserAdminModule
  - Testing
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

This function checks the status of Cisco Secure Endpoint on the specified computers.

#### Detailed Description

The Test-CiscoSecure function uses the Invoke-Command cmdlet to run a script block on each computer specified in the ComputerName parameter. The script block checks for the presence of the sfc.exe file and the status of the Cisco Secure Endpoint service. It outputs the status, name, and version of the sfc.exe as a PSCustomObject.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Test-CiscoSecure -ComputerName "Computer1", "Computer2", "Computer3"
```

This command checks the status of Cisco Secure Endpoint on the computers named Computer1, Computer2, and Computer3.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
   This function checks the status of Cisco Secure Endpoint on the specified computers.

.DESCRIPTION
   The Test-CiscoSecure function uses the Invoke-Command cmdlet to run a script block on each computer specified in the ComputerName parameter.
   The script block checks for the presence of the sfc.exe file and the status of the Cisco Secure Endpoint service. It outputs the status, name, and version of the sfc.exe as a PSCustomObject.

.PARAMETER ComputerName
   Specifies the names of the computers on which to check the status of Cisco Secure Endpoint. This parameter accepts an array of computer names.

.EXAMPLE
   Test-CiscoSecure -ComputerName "Computer1", "Computer2", "Computer3"
   This command checks the status of Cisco Secure Endpoint on the computers named Computer1, Computer2, and Computer3.
#>
function Test-CiscoSecure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName  # Array of computer names
    )
    $ScriptBlock = {
        # Get the full path of the sfc.exe file
        $Path = Get-ChildItem -Path "C:\Program Files\Cisco\AMP\" -Filter "sfc.exe" -Recurse -ErrorAction SilentlyContinue
        if ($Path) {
            $Path = $Path.FullName
            # Get the version of the sfc.exe
            $Version = (Get-Command $Path).FileVersionInfo.ProductVersion
            # Check if the Cisco Secure Endpoint service is running
            $Service = Get-Service -Name "CiscoAMP" -ErrorAction SilentlyContinue
            $ServiceStatus = if ($Service.Status -eq 'Running') { "Running" } else { "Not Running" }
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName             = $env:COMPUTERNAME
                SfcExePath               = $Path
                SfcExeVersion            = $Version
                CiscoSecureServiceStatus = $ServiceStatus
            }
        }
        else {
            Write-Output "Could not find sfc.exe on $env:COMPUTERNAME"
        }
    }
    # Initialize progress variables
    $TotalComputers = $ComputerName.Length
    $Counter = 0
    # Run the script block on each computer with progress reporting
    foreach ($Computer in $ComputerName) {
        $Counter++
        Write-Progress -Activity "Checking Cisco Secure Endpoint" -Status "Processing $Computer ($Counter of $TotalComputers)" -PercentComplete (($Counter / $TotalComputers) * 100)
        Invoke-Command -ComputerName $Computer -ScriptBlock $ScriptBlock
    }
    # Clear the progress bar
    Write-Progress -Activity "Checking Cisco Secure Endpoint" -Completed
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-CiscoSecure.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-CiscoSecure.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

