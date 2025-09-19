---
layout: post
title: Get-RemoteCipherDetails.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RemoteCipherDetails/
categories:
  - UserAdminModule
  - CertificateUtilities
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

Retrieves the cipher details from the remote computers.

#### Detailed Description

The Get-RemoteCipherDetails function retrieves the details of the ciphers configured on the specified remote computers. It connects to the remote registry and queries the cipher settings stored in the SCHANNEL\Ciphers registry path. The function returns an array of custom objects containing the computer name, cipher name, and whether the cipher is enabled or not.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$computers = @("Server1", "Server2", "Server3")
```

$cipherDetails = Get-RemoteCipherDetails -ComputerName $computers $cipherDetails | Format-Table -AutoSize This example retrieves the cipher details from the remote computers "Server1", "Server2", and "Server3" and displays the results in a formatted table.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date Version: 1.0

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the cipher details from the remote computers.

.DESCRIPTION
The Get-RemoteCipherDetails function retrieves the details of the ciphers configured on the specified remote computers. It connects to the remote registry and queries the cipher settings stored in the SCHANNEL\Ciphers registry path. The function returns an array of custom objects containing the computer name, cipher name, and whether the cipher is enabled or not.

.PARAMETER ComputerName
Specifies the names of the remote computers to retrieve the cipher details from.

.EXAMPLE
$computers = @("Server1", "Server2", "Server3")
$cipherDetails = Get-RemoteCipherDetails -ComputerName $computers
$cipherDetails | Format-Table -AutoSize

This example retrieves the cipher details from the remote computers "Server1", "Server2", and "Server3" and displays the results in a formatted table.

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>

function Get-RemoteCipherDetails {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )

    # Define the registry path where cipher settings are stored
    $cipherRegPath = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"

    # Create an empty array to store the results
    $results = @()

    foreach ($computer in $ComputerName) {
        try {
            # Connect to the remote registry
            $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer)
            $cipherKey = $reg.OpenSubKey($cipherRegPath)

            if ($cipherKey) {
                # Get the list of ciphers
                $ciphers = $cipherKey.GetSubKeyNames()

                foreach ($cipher in $ciphers) {
                    $cipherDetailsKey = $cipherKey.OpenSubKey($cipher)
                    $enabledValue = $cipherDetailsKey.GetValue("Enabled")
                    $enabled = if ($enabledValue -eq 0) { $false } else { $true }

                    # Create a custom object to store the details
                    $cipherDetails = [PSCustomObject]@{
                        ComputerName = $computer
                        Cipher       = $cipher
                        Enabled      = $enabled
                    }

                    # Add the object to the results array
                    $results += $cipherDetails
                }
            } else {
                Write-Warning "Ciphers registry path not found on $computer."
            }

            $reg.Close()
        } catch {
            Write-Error "Failed to query $($computer): $_"
        }
    }

    return $results
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/CertificateUtilities/Public/Get-RemoteCipherDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RemoteCipherDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

