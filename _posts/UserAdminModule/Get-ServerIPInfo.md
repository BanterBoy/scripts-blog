---
layout: post
title: Get-ServerIPInfo.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ServerIPInfo/
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

Retrieves IP information for servers in Active Directory.

#### Detailed Description

The Get-ServerIPInfo function retrieves IP information for servers in Active Directory. It queries the Active Directory for enabled computers with an operating system that contains the word "server". It then tests the connection to each server and retrieves the IP configuration and routing information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ServerIPInfo
```

Retrieves IP information for servers in Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Active Directory module and administrative privileges to run.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves IP information for servers in Active Directory.

.DESCRIPTION
The Get-ServerIPInfo function retrieves IP information for servers in Active Directory. It queries the Active Directory for enabled computers with an operating system that contains the word "server". It then tests the connection to each server and retrieves the IP configuration and routing information.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-ServerIPInfo
Retrieves IP information for servers in Active Directory.

.OUTPUTS
The function returns an array of custom objects with the following properties:
- Server: The name of the server.
- Interface: The interface alias(es) of the server.
- IPv4Address: The IPv4 address(es) of the server.
- Gateway: The default gateway of the server.
- DNSServer: The DNS server(s) of the server.

.NOTES
This function requires the Active Directory module and administrative privileges to run.

.LINK
https://github.com/your-repo/Get-ServerIPInfo.ps1
#>

function Get-ServerIPInfo {
    $ServerList = (Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"').Name
    $test = Test-Connection -ComputerName $ServerList -Count 1 -ErrorAction SilentlyContinue
    $Available = $test | Select-Object -ExpandProperty Address
    $result = @()
     
    foreach ($Server in $Available) {
        $Invoke = Invoke-Command -ComputerName $Server -ScriptBlock {
            Get-NetIPConfiguration | Select-Object -Property InterfaceAlias, Ipv4Address, DNSServer
            Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -ExpandProperty NextHop
        }
        $result += New-Object -TypeName PSCustomObject -Property ([ordered]@{
                'Server'      = $Server
                'Interface'   = $Invoke.InterfaceAlias -join ','
                'IPv4Address' = $Invoke.Ipv4Address.IPAddress -join ','
                'Gateway'     = $Invoke | Select-Object -Last 1
                'DNSServer'   = ($Invoke.DNSServer | Select-Object -ExpandProperty ServerAddresses) -join ',' 
            })
    }
    $result
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-ServerIPInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServerIPInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

