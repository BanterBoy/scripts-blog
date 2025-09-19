---
layout: post
title: Get-ServerInfo.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ServerInfo/
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-ServerInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$ComputerName
    )

    process {
        $results = @()

        foreach ($computer in $ComputerName) {
            Write-Verbose "Processing computer: $computer"

            $serverInfo = [PSCustomObject]@{
                IPAddress    = @()
                ComputerName = $computer
                Type         = if ($computer -eq $env:COMPUTERNAME) { "Local" } else { "Remote" }
                OS           = ""
                Services     = @()
                Tasks        = @()
                Scripts      = @()
                Processes    = @()
                Ports        = @()
            }

            try {
                $session = New-CimSession -ComputerName $computer

                # IP Addresses
                $ipAddresses = Get-CimInstance -CimSession $session -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress }
                $serverInfo.IPAddress = $ipAddresses.IPAddress

                # OS
                $os = Get-CimInstance -CimSession $session -ClassName Win32_OperatingSystem
                $serverInfo.OS = $os.Caption

                # Processes
                $processes = Get-ProcessStatus -ComputerName $computer -ProcessName '*'
                if ($processes) {
                    $serverInfo.Processes = $processes | Select-Object -ExpandProperty ProcessName
                }
                else {
                    Write-Verbose "No processes found or 'ProcessName' property is missing."
                }

                # Services
                $services = Get-ServiceStatus -ComputerName $computer -ServiceName '*'
                if ($services) {
                    $serverInfo.Services = $services | Select-Object -ExpandProperty DisplayName
                }
                else {
                    Write-Verbose "No services found or 'DisplayName' property is missing."
                }

                # Tasks
                $tasks = Get-ScheduledTasks -ComputerName $computer
                if ($tasks) {
                    $serverInfo.Tasks = $tasks | Select-Object -ExpandProperty TaskName
                }
                else {
                    Write-Verbose "No tasks found or 'TaskName' property is missing."
                }

                # Scripts
                $scripts = Get-ScheduledScripts -ComputerName $computer -TaskName '*'
                if ($scripts) {
                    $serverInfo.Scripts = $scripts | Select-Object -ExpandProperty TaskName
                }
                else {
                    Write-Verbose "No scripts found or 'TaskName' property is missing."
                }

                # Ports
                $ports = Get-NetTCPConnection -CimSession $session | Where-Object { $_.State -eq 'Listen' -and $_.LocalAddress -eq '::' }
                if ($ports) {
                    $serverInfo.Ports = $ports | Select-Object -ExpandProperty LocalPort
                }
                else {
                    Write-Verbose "No ports found."
                }

                $results += $serverInfo

            }
            catch {
                Write-Error "Error processing computer {$computer}: $_"
            }
        }

        $results
    }
}

# Example usage
# Get-ServerInfo -ComputerName EXCHANGE01 -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-ServerInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServerInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

