---
layout: post
title: Switch-VpnFailoverMac.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/network/switch-vpnfailovermac/
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

Switches the VPN client to failover or failback.

#### Detailed Description

The Switch-VpnFailoverMac function manages the failover and failback of a VPN client by stopping and starting the Cisco VPN service, modifying the hosts file, and logging the active connection.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Switch-VpnFailoverMac -Action Failover
```

Switches the VPN client to the secondary site.

**Example 2**

```powershell
Switch-VpnFailoverMac -Action Failback
```

Switches the VPN client back to the primary site.

**Example 3**

```powershell
"Failover" | Switch-VpnFailoverMac
```

Pipes the action to the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Switch-VpnFailoverMac {
    <#
    .SYNOPSIS
    Switches the VPN client to failover or failback.

    .DESCRIPTION
    The Switch-VpnFailoverMac function manages the failover and failback of a VPN client by stopping and starting the Cisco VPN service, modifying the hosts file, and logging the active connection.

    .PARAMETER Action
    The action to perform. Valid values are "Failover" and "Failback".

    .INPUTS
    System.String. You can pipe a string that specifies the action ("Failover" or "Failback") to the function.

    .OUTPUTS
    None. This function does not produce any output.

    .EXAMPLE
    Switch-VpnFailoverMac -Action Failover
    Switches the VPN client to the secondary site.

    .EXAMPLE
    Switch-VpnFailoverMac -Action Failback
    Switches the VPN client back to the primary site.

    .EXAMPLE
    "Failover" | Switch-VpnFailoverMac
    Pipes the action to the function.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Specify the action to perform. Valid values are 'Failover' and 'Failback'.")]
        [ValidateSet("Failover", "Failback")]
        [string]$Action
    )

    begin {
        # Define variables
        $vpnService = "com.cisco.anyconnect.vpnagentd"
        $hostsFilePath = "/etc/hosts"
        $vpnHostEntry = "127.0.0.1 vpn.rdg.co.uk"

        # Function to stop the VPN service
        function Stop-VpnService {
            sudo launchctl unload /Library/LaunchDaemons/$vpnService.plist
        }

        # Function to start the VPN service
        function Start-VpnService {
            sudo launchctl load /Library/LaunchDaemons/$vpnService.plist
        }

        # Function to add an entry to the hosts file
        function Add-HostsEntry {
            if (-not (Get-Content $hostsFilePath | Select-String -Pattern $vpnHostEntry)) {
                Add-Content -Path $hostsFilePath -Value $vpnHostEntry
            }
        }

        # Function to remove an entry from the hosts file
        function Remove-HostsEntry {
            $hostsContent = Get-Content $hostsFilePath
            $updatedHostsContent = $hostsContent -replace [regex]::Escape($vpnHostEntry), ''
            Set-Content -Path $hostsFilePath -Value $updatedHostsContent
        }

        # Function to log an event
        function Write-EventLogEntry {
            param (
                [string]$Message,
                [string]$EventType = "Information"
            )
            $logFile = "/var/log/vpn_failover.log"
            $timeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            $logEntry = "$timeStamp [$EventType] $Message"
            Add-Content -Path $logFile -Value $logEntry
        }

        # Function to test the current connection
        function Test-CurrentConnection {
            if (Get-Content $hostsFilePath | Select-String -Pattern $vpnHostEntry) {
                return "Secondary"
            } else {
                return "Primary"
            }
        }
    }

    process {
        $action = $Action

        if ($PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Perform $action")) {
            try {
                switch ($action) {
                    "Failover" {
                        Write-Output "Failing over to secondary site..."
                        Stop-VpnService
                        Add-HostsEntry
                        Start-VpnService
                        Write-Output "Failover complete."
                        Write-EventLogEntry -Message "Failover to secondary site completed." -EventType "Information"
                    }
                    "Failback" {
                        Write-Output "Failing back to primary site..."
                        Stop-VpnService
                        Remove-HostsEntry
                        Start-VpnService
                        Write-Output "Failback complete."
                        Write-EventLogEntry -Message "Failback to primary site completed." -EventType "Information"
                    }
                }

                # Test and log the current connection
                $currentConnection = Test-CurrentConnection
                Write-EventLogEntry -Message "Current connection: $currentConnection" -EventType "Information"
                Write-Output "Current connection: $currentConnection"
            }
            catch {
                Write-EventLogEntry -Message "Failed to perform {$action}: $_" -EventType "Error"
                Write-Error "Failed to perform {$action}: $_"
            }
        }
    }
}

# Example usage:
# Switch-VpnFailoverMac -Action Failover
# Switch-VpnFailoverMac -Action Failback
# "Failover" | Switch-VpnFailoverMac
# "Failback" | Switch-VpnFailoverMac
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Switch-VpnFailoverMac.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Switch-VpnFailoverMac.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

