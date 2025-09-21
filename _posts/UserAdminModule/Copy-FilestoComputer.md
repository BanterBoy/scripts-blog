---
layout: post
title: Copy-FilestoComputer.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/copy-filestocomputer/
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

Copies files or directories to or from remote computers.

#### Detailed Description

The Copy-FilestoComputer function allows you to copy files or directories to or from remote computers. It creates a remote session to the destination computer and uses the Copy-Item cmdlet to perform the file copy operation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Copy-FilestoComputer -ComputerName "Server01" -LocalPath "C:\Files" -RemotePath "D:\Backup"
```

This example copies the files from the local path "C:\Files" to the remote path "D:\Backup" on the computer "Server01".

**Example 2**

```powershell
Copy-FilestoComputer -ComputerName "Server01", "Server02" -LocalPath "C:\Files" -RemotePath "D:\Backup" -Credentials $cred -Direction "FromRemote"
```

This example copies the files from the remote path "D:\Backup" on the computers "Server01" and "Server02" to the local path "C:\Files". It uses the specified credentials for the remote session and sets the direction of the file copy operation to "FromRemote".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Copies files or directories to or from remote computers.

.DESCRIPTION
    The Copy-FilestoComputer function allows you to copy files or directories to or from remote computers. It creates a remote session to the destination computer and uses the Copy-Item cmdlet to perform the file copy operation.

.PARAMETER ComputerName
    Specifies the name of the remote computer(s) to copy files to or from. This parameter is mandatory.

.PARAMETER LocalPath
    Specifies the local path of the files or directories to be copied. This parameter is mandatory.

.PARAMETER RemotePath
    Specifies the remote path where the files or directories should be copied to or from. This parameter is mandatory.

.PARAMETER Credentials
    Specifies the credentials to be used for the remote session. If not provided, the current user's credentials will be used.

.PARAMETER Direction
    Specifies the direction of the file copy operation. Valid values are 'ToRemote' and 'FromRemote'. The default value is 'ToRemote'.

.EXAMPLE
    Copy-FilestoComputer -ComputerName "Server01" -LocalPath "C:\Files" -RemotePath "D:\Backup"

    This example copies the files from the local path "C:\Files" to the remote path "D:\Backup" on the computer "Server01".

.EXAMPLE
    Copy-FilestoComputer -ComputerName "Server01", "Server02" -LocalPath "C:\Files" -RemotePath "D:\Backup" -Credentials $cred -Direction "FromRemote"

    This example copies the files from the remote path "D:\Backup" on the computers "Server01" and "Server02" to the local path "C:\Files". It uses the specified credentials for the remote session and sets the direction of the file copy operation to "FromRemote".

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Copy-FilestoComputer {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credentials,

        [Parameter()]
        [ValidateSet('ToRemote', 'FromRemote')]
        [string]$Direction = 'ToRemote'
    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {
            try {
                if ($PSCmdlet.ShouldProcess($Computer, "Copy $LocalPath to remote computer")) {
                    # Create a remote session to the destination computer.
                    if ($Credentials) {
                        $NewPSSession = New-PSSession -ComputerName $Computer -Credential $Credentials -ErrorAction Stop
                    }
                    else {
                        $NewPSSession = New-PSSession -ComputerName $Computer -ErrorAction Stop
                    }

                    if ($Direction -eq 'ToRemote') {
                        # Copy the directory to the remote session.
                        $Files = Get-ChildItem -Path $LocalPath -Recurse
                        foreach ($File in $Files) {
                            $Destination = $File.FullName.Replace($LocalPath, $RemotePath)
                            Copy-Item -Path $File.FullName -Destination $Destination -ToSession $NewPSSession -Recurse -ErrorAction Stop
                        }
                    }
                    else {
                        # Copy the directory from the remote session.
                        $Files = Get-ChildItem -Path $RemotePath -Recurse -Session $NewPSSession
                        foreach ($File in $Files) {
                            $Destination = $File.FullName.Replace($RemotePath, $LocalPath)
                            Copy-Item -Path $File.FullName -Destination $Destination -FromSession $NewPSSession -Recurse -ErrorAction Stop
                        }
                    }

                    # Terminate the remote session.
                    Remove-PSSession -Session $NewPSSession
                }
            }
            catch {
                Write-Error $_.Exception.Message
                if ($NewPSSession) {
                    Remove-PSSession -Session $NewPSSession
                }
            }
        }
    }

    end {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Copy-FilestoComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-FilestoComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

