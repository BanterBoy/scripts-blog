---
layout: post
title: Cleanup-TestFiles.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/cleanup-testfiles/
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
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Cleanup-TestFiles {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$LogFiles
    )

    foreach ($logFile in $LogFiles) {
        Write-Verbose "Processing log file: $logFile"

        if (-not (Test-Path -Path $logFile)) {
            Write-Warning "Log file not found: $logFile"
            continue
        }

        $logData = Get-Content -Path $logFile | ConvertFrom-Json

        foreach ($entry in $logData) {
            $server = $entry.ServerName
            $filePath = $entry.FullName

            if (-not $filePath) {
                Write-Warning "No file path specified in log entry for server: $server"
                continue
            }

            $destinationPath = "\\$server\C$\Temp\$($entry.FileName)"
            Write-Verbose "Attempting to remove file: $destinationPath on server: $server"

            if ($PSCmdlet.ShouldProcess($destinationPath, "Remove file")) {
                try {
                    Remove-Item -Path $destinationPath -Force -ErrorAction Stop
                    Write-Verbose "File removed successfully: $destinationPath"
                } catch [System.Management.Automation.ItemNotFoundException] {
                    Write-Warning "File not found: $destinationPath. It may have already been deleted."
                } catch {
                    Write-Error "Failed to remove file: $destinationPath. $_"
                }
            }
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Cleanup-TestFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Cleanup-TestFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

