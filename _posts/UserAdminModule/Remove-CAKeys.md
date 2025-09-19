---
layout: post
title: Remove-CAKeys.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Remove-CAKeys/
categories:
  - UserAdminModule
  - PKICertificateTools
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

Removes a specified Certificate Authority (CA) key from the Microsoft Software Key Storage Provider.

#### Detailed Description

The `Remove-CAKeys` function automates the process of removing a specified CA key from the Microsoft Software Key Storage Provider. If a key name is provided, the function deletes the specified key. If no key name is provided, the function skips the deletion process. The function logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-CAKeys -KeyName "MyCAKey"
```

This example removes the CA key named `MyCAKey` from the Microsoft Software Key Storage Provider.

**Example 2**

```powershell
Remove-CAKeys
```

This example skips the key deletion process because no key name is provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: certutil.exe

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server.

- **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.

- **Valid Key Name**: If a key name is provided, it must match an existing key in the Microsoft Software Key Storage Provider.

BEST PRACTICES

- **Validate Key Name**: Ensure the key name provided is accurate to avoid accidentally deleting the wrong key.

- **Backup Keys**: Before removing a key, consider backing up the key to ensure recovery in case of accidental deletion.

- **Audit Logs**: Maintain logs of key removal operations for auditing purposes and to track any issues during the process.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Removes a specified Certificate Authority (CA) key from the Microsoft Software Key Storage Provider.

    .DESCRIPTION
    The `Remove-CAKeys` function automates the process of removing a specified CA key from the Microsoft Software Key Storage Provider.
    If a key name is provided, the function deletes the specified key. If no key name is provided, the function skips the deletion process.
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER KeyName
    Specifies the name of the CA key to be removed from the Microsoft Software Key Storage Provider. If not provided, no keys will be deleted.

    .EXAMPLE
    Remove-CAKeys -KeyName "MyCAKey"
    This example removes the CA key named `MyCAKey` from the Microsoft Software Key Storage Provider.

    .EXAMPLE
    Remove-CAKeys
    This example skips the key deletion process because no key name is provided.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Valid Key Name**: If a key name is provided, it must match an existing key in the Microsoft Software Key Storage Provider.

    BEST PRACTICES
    - **Validate Key Name**: Ensure the key name provided is accurate to avoid accidentally deleting the wrong key.
    - **Backup Keys**: Before removing a key, consider backing up the key to ensure recovery in case of accidental deletion.
    - **Audit Logs**: Maintain logs of key removal operations for auditing purposes and to track any issues during the process.

#>

function Remove-CAKeys {
    [CmdletBinding()]
    param ([string]$KeyName)

    try {
        # List all keys in the Microsoft Software Key Storage Provider
        certutil -key -csp "Microsoft Software Key Storage Provider"

        # If a specific key name is provided, delete it
        if ($KeyName) {
            certutil -csp "Microsoft Software Key Storage Provider" -delkey "$KeyName"
            Write-CAActivityLog -Message "Successfully removed CA key: $KeyName from the Microsoft Software Key Storage Provider." -LogPath "C:\CA-Logs\remove-keys.log"
        }
        else {
            Write-CAActivityLog -Message "No key name provided. Skipping CA key deletion." -LogPath "C:\CA-Logs\remove-keys.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA keys. Error: $_"
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Remove-CAKeys.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-CAKeys.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

