---
layout: post
title: Get-RDPUserReport.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/remoteconnections/get-rdpuserreport/
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

Retrieves RDP session details from specified computers.

#### Detailed Description

Queries the specified servers for RDP session details and outputs them as objects for further manipulation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RDPUserReport -ComputerName "DANTOOINE"
```

**Example 2**

```powershell
Get-RDPUserReport -ComputerName "DANTOOINE" | Sort-Object IdleTime | Format-Table -AutoSize
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Function: Get-RDPUserReport
Function Get-RDPUserReport {
    <#
    .SYNOPSIS
    Retrieves RDP session details from specified computers.

    .DESCRIPTION
    Queries the specified servers for RDP session details and outputs them as objects for further manipulation.

    .PARAMETER ComputerName
    Name or IP address of the computer(s) to query.

    .EXAMPLE
    Get-RDPUserReport -ComputerName "DANTOOINE"

    .EXAMPLE
    Get-RDPUserReport -ComputerName "DANTOOINE" | Sort-Object IdleTime | Format-Table -AutoSize
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName
    )

    # Initialize array to store session details
    $Sessions = @()

    # Query each specified computer
    foreach ($Computer in $ComputerName) {
        try {
            $ConnectionResult = Test-NetConnection -ComputerName $Computer -CommonTCPPort RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($ConnectionResult.TcpTestSucceeded) {
                Write-Verbose "Connected to $Computer"
                $DirtyOutput = (quser /server:$Computer) -replace '\s{2,}', ',' | ConvertFrom-Csv
                foreach ($session in $DirtyOutput) {
                    if (($session.sessionname -notlike "console") -and ($session.sessionname -notlike "rdp-tcp*")) {
                        $sessionData = [pscustomobject]@{
                            Username    = $session.USERNAME
                            SessionName = ""
                            ID          = $session.SESSIONNAME
                            State       = $session.ID
                            IdleTime    = $session.STATE
                            LogonTime   = $session."IDLE TIME"
                            ServerName  = $Computer
                        }
                    } else {
                        $sessionData = [pscustomobject]@{
                            Username    = $session.USERNAME
                            SessionName = $session.SESSIONNAME
                            ID          = $session.ID
                            State       = $session.STATE
                            IdleTime    = $session."IDLE TIME"
                            LogonTime   = $session."LOGON TIME"
                            ServerName  = $Computer
                        }
                    }
                    $Sessions += $sessionData
                }
            } else {
                Write-Verbose "Failed to connect to $Computer"
                $Sessions += [pscustomobject]@{
                    Username    = 'N/A'
                    SessionName = 'N/A'
                    ID          = 'N/A'
                    State       = 'Unavailable'
                    IdleTime    = 'N/A'
                    LogonTime   = 'N/A'
                    ServerName  = $Computer
                }
            }
        } catch {
            Write-Warning "Failed to query $($Computer): $_"
        }
    }

    # Return session details
    return $Sessions
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Get-RDPUserReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDPUserReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

