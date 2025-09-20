---
layout: post
title: Remove-CertLogDatabase.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Remove-CertLogDatabase/
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

Removes the Certificate Authority (CA) database folder from the specified path.

#### Detailed Description

The `Remove-CertLogDatabase` function automates the process of removing the Certificate Authority (CA) database folder from the specified path. It checks if the folder exists, deletes it if found, and logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-CertLogDatabase
```

This example removes the CA database folder located at the default path `C:\Windows\System32\CertLog`.

**Example 2**

```powershell
Remove-CertLogDatabase -DatabasePath "D:\CertLog"
```

This example removes the CA database folder located at the specified path `D:\CertLog`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: None

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server.

- **Valid Path**: The specified database path must exist and be accessible to the user.

BEST PRACTICES

- **Backup Before Removal**: Ensure that a full backup of the CA database has been performed before removing the database folder.

- **Audit Logs**: Maintain logs of the database removal process for auditing purposes and to track any issues during the operation.

- **Verify Path**: Double-check the database path to avoid accidentally deleting unrelated or critical files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Removes the Certificate Authority (CA) database folder from the specified path.

    .DESCRIPTION
    The `Remove-CertLogDatabase` function automates the process of removing the Certificate Authority (CA) database folder from the specified path.
    It checks if the folder exists, deletes it if found, and logs the operation's success or failure to a specified log file.

    .PARAMETER DatabasePath
    Specifies the path to the CA database folder to be removed. The default path is `C:\Windows\System32\CertLog`.

    .EXAMPLE
    Remove-CertLogDatabase
    This example removes the CA database folder located at the default path `C:\Windows\System32\CertLog`.

    .EXAMPLE
    Remove-CertLogDatabase -DatabasePath "D:\CertLog"
    This example removes the CA database folder located at the specified path `D:\CertLog`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: None

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server.
    - **Valid Path**: The specified database path must exist and be accessible to the user.

    BEST PRACTICES
    - **Backup Before Removal**: Ensure that a full backup of the CA database has been performed before removing the database folder.
    - **Audit Logs**: Maintain logs of the database removal process for auditing purposes and to track any issues during the operation.
    - **Verify Path**: Double-check the database path to avoid accidentally deleting unrelated or critical files.

#>

function Remove-CertLogDatabase {
    [CmdletBinding()]
    param ([string]$DatabasePath = "C:\Windows\System32\CertLog")
    try {
        # Check if the database path exists
        if (Test-Path $DatabasePath) {
            Remove-Item -Path $DatabasePath -Recurse -Force
            Write-CAActivityLog -Message "Successfully removed CA database folder located at: $DatabasePath." -LogPath "C:\CA-Logs\remove-database.log"
        }
        else {
            Write-CAActivityLog -Message "CA database folder not found at path: $DatabasePath. No action was taken." -LogPath "C:\CA-Logs\remove-database.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA database folder. Error: $_" -LogPath $LogPath
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Remove-CertLogDatabase.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-CertLogDatabase.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

