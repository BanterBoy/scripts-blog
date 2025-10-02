---
layout: post
title: Get-RemoteServerPorts.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/network/get-remoteserverports/
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

Retrieves the services and processes running on a remote machine and matches them to their associated network ports.

#### Detailed Description

This function queries a remote machine using CIM for running processes, services, and network connections. It filters the results to show unique entries for IPv4 addresses, with local ports less than or equal to 10000. The function also includes the computer name and descriptions in the output.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RemoteServerPorts -ComputerName "EXCHANGE01"
```

**Example 2**

```powershell
"EXCHANGE01" | Get-RemoteServerPorts
```

**Example 3**

```powershell
Get-RemoteServerPorts -ComputerName "EXCHANGE01" -Credential (Get-Credential)
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Retrieves the services and processes running on a remote machine and matches them to their associated network ports.

.DESCRIPTION
    This function queries a remote machine using CIM for running processes, services, and network connections.
    It filters the results to show unique entries for IPv4 addresses, with local ports less than or equal to 10000.
    The function also includes the computer name and descriptions in the output.

.PARAMETER ComputerName
    The name of the remote computer to query.

.PARAMETER Credential
    Optional credentials to use for the connection.

.INPUTS
    System.String
        You can pipe a computer name to the ComputerName parameter.

.OUTPUTS
    PSCustomObject
        Custom objects representing the matched services, processes, and network ports.

.EXAMPLE
    Get-RemoteServerPorts -ComputerName "EXCHANGE01"

.EXAMPLE
    "EXCHANGE01" | Get-RemoteServerPorts

.EXAMPLE
    Get-RemoteServerPorts -ComputerName "EXCHANGE01" -Credential (Get-Credential)
#>

#requires -PSEdition Desktop
function Get-RemoteServerPorts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        $results = @()
    }

    process {
        try {
            if ($Credential) {
                $options = New-CimSessionOption -Protocol DCOM
                $cimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential -SessionOption $options
            } else {
                $cimSession = New-CimSession -ComputerName $ComputerName
            }

            Write-Verbose "Querying processes on $ComputerName"
            $processes = Get-CimInstance -CimSession $cimSession -ClassName Win32_Process

            Write-Verbose "Querying services on $ComputerName"
            $services = Get-CimInstance -CimSession $cimSession -ClassName Win32_Service

            Write-Verbose "Querying network connections on $ComputerName"
            $networkConnections = Get-CimInstance -CimSession $cimSession -Namespace "root/StandardCimv2" -ClassName MSFT_NetTCPConnection

            foreach ($connection in $networkConnections) {
                $process = $processes | Where-Object { $_.ProcessId -eq $connection.OwningProcess }
                $service = $services | Where-Object { $_.ProcessId -eq $connection.OwningProcess }

                if ($connection.LocalPort -le 10000 -and $connection.LocalAddress -notmatch ":") {
                    $results += [PSCustomObject]@{
                        ComputerName       = $ComputerName
                        ProcessName        = $process.Name
                        ProcessId          = $process.ProcessId
                        LocalAddress       = $connection.LocalAddress
                        LocalPort          = $connection.LocalPort
                        RemoteAddress      = $connection.RemoteAddress
                        RemotePort         = $connection.RemotePort
                        State              = switch ($connection.State) {
                                                1 { "Closed" }
                                                2 { "Listening" }
                                                3 { "SYN Sent" }
                                                4 { "SYN Received" }
                                                5 { "Established" }
                                                6 { "FIN Wait 1" }
                                                7 { "FIN Wait 2" }
                                                8 { "Close Wait" }
                                                9 { "Closing" }
                                                10 { "Last ACK" }
                                                11 { "Time Wait" }
                                                12 { "Delete TCB" }
                                                default { "Unknown" }
                                            }
                        ServiceName        = $service.Name
                        ServiceDisplayName = $service.DisplayName
                        Description        = $service.Description
                    }
                }
            }
        } catch {
            Write-Error "An error occurred: $_"
        } finally {
            Remove-CimSession -CimSession $cimSession
        }
    }

    end {
        $results | Sort-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, Protocol -Unique
        Update-FormatData -PrependPath "$PSScriptRoot\Get-RemoteServerPorts.Format.ps1xml"
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-RemoteServerPorts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RemoteServerPorts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

