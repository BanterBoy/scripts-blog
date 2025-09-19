---
layout: post
title: Get-RemoteIPSettings.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RemoteIPSettings/
categories:
  - UserAdminModule
  - Network
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

Retrieves remote computer IP configuration details.

#### Detailed Description

Get-RemoteIPSettings uses PowerShell remoting to fetch network settings such as IP addresses, default gateways, and DNS server addresses from one or more remote computers.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RemoteIPSettings -ComputerName "Server01","Server02" -Credential (Get-Credential)
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Ensure that PowerShell remoting is enabled on the target computers. This function is as remote as it gets—bringing your network details right to your console!

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves remote computer IP configuration details.
.DESCRIPTION
    Get-RemoteIPSettings uses PowerShell remoting to fetch network settings such as IP addresses,
    default gateways, and DNS server addresses from one or more remote computers.
.EXAMPLE
    Get-RemoteIPSettings -ComputerName "Server01","Server02" -Credential (Get-Credential)
.NOTES
    Ensure that PowerShell remoting is enabled on the target computers.
    This function is as remote as it gets—bringing your network details right to your console!
#>

function Get-RemoteIPSettings {
    [CmdletBinding()]
    param(
        # One or more target computer names
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string[]]$ComputerName,

        # Optional credentials if needed for remote access
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    
    process {
        foreach ($computer in $ComputerName) {
            try {
                Write-Verbose "Connecting to $computer..."
                
                # Prepare the parameters for Invoke-Command
                $invokeParams = @{
                    ComputerName = $computer
                    ScriptBlock  = {
                        # Retrieve network configuration and format the output
                        Get-NetIPConfiguration | ForEach-Object {
                            [PSCustomObject]@{
                                InterfaceAlias = $_.InterfaceAlias
                                IPv4Address    = ($_.IPv4Address | ForEach-Object { $_.IPAddress }) -join ', '
                                IPv6Address    = ($_.IPv6Address | ForEach-Object { $_.IPAddress }) -join ', '
                                DefaultGateway = ($_.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) -join ', '
                                DNSServers     = ($_.DNSServer.ServerAddresses) -join ', '
                            }
                        }
                    }
                    ErrorAction  = 'Stop'
                }

                if ($Credential) {
                    $invokeParams.Credential = $Credential
                }

                $results = Invoke-Command @invokeParams
                Write-Output $results
            }
            catch {
                Write-Warning "Failed to retrieve IP settings from $computer. Error: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-RemoteIPSettings.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RemoteIPSettings.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

