---
layout: post
title: Get-DiskReport.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-DiskReport/
categories:
  - UserAdminModule
  - Virtualization
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-DiskReport {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Specify one or more computer names. Defaults to the local computer."
        )]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify credentials for remote connections if needed."
        )]
        [System.Management.Automation.Credential()]
        [PSCredential]
        $Credential
    )

    process {
        foreach ($computer in $ComputerName) {
            # Script block to execute on each remote computer
            $scriptBlock = {
                Get-PSDrive -PSProvider FileSystem |
                    ForEach-Object {
                        [PSCustomObject]@{
                            ComputerName = $env:COMPUTERNAME
                            Name         = $_.Name
                            UsedGB       = [math]::Round($_.Used / 1GB, 2)
                            FreeGB       = [math]::Round($_.Free / 1GB, 2)
                            TotalGB      = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
                        }
                    }
            }

            try {
                # Invoke the script block on the remote computer (or locally if ComputerName=localhost)
                if ($Credential) {
                    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -Credential $Credential
                }
                else {
                    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock
                }
            }
            catch {
                Write-Warning "Failed to retrieve disk info from '$computer': $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-DiskReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DiskReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

