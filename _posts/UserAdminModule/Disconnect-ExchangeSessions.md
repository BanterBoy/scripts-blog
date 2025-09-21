---
layout: post
title: Disconnect-ExchangeSessions.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/disconnect-exchangesessions/
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

Disconnects all active Exchange sessions and connections.

#### Detailed Description

The Disconnect-ExchangeSessions function disconnects all active Exchange sessions and connections. It first retrieves all active PowerShell sessions using the Get-PSSession cmdlet, and then retrieves all active Exchange connections using the Get-ConnectionInformation function. It then iterates through each session and connection, and disconnects them if they are in the 'Opened' or 'Connected' state respectively.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Disconnect-ExchangeSessions
```

Disconnects all active Exchange sessions and connections.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Disconnects all active Exchange sessions and connections.

.DESCRIPTION
The Disconnect-ExchangeSessions function disconnects all active Exchange sessions and connections. It first retrieves all active PowerShell sessions using the Get-PSSession cmdlet, and then retrieves all active Exchange connections using the Get-ConnectionInformation function. It then iterates through each session and connection, and disconnects them if they are in the 'Opened' or 'Connected' state respectively.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Disconnect-ExchangeSessions
Disconnects all active Exchange sessions and connections.

.NOTES
Author: Your Name
Date: Today's Date
#>
function Disconnect-ExchangeSessions {
    $sessions = Get-PSSession
    $connections = Get-ConnectionInformation

    foreach ($session in $sessions) {
        if ($session.State -eq 'Opened') {
            Write-Output "Disconnecting session: $($session.Name)"
            Remove-PSSession -Session $session
        }
    }

    foreach ($connection in $connections) {
        if ($connection.State -eq 'Connected' -and $null -ne $connection.ConnectionId) {
            Write-Output "Disconnecting connection: $($connection.ConnectionId)"
            Disconnect-ExchangeOnline -ConnectionId $connection.ConnectionId -Confirm:$false
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Disconnect-ExchangeSessions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disconnect-ExchangeSessions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

