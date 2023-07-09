---
layout: post
title: Get-LogonHistory.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
function Get-LogonHistory {
    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $ComputerName,

        [int]
        $Days = 10
    )

    $Result = @()
    $eventLogs = Get-EventLog System -Source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-$Days) -ComputerName $ComputerName
    If ($eventLogs) {
        ForEach ($Log in $eventLogs) {
            If ($Log.InstanceId -eq 7001) {
                $eventType = "Logon"
            }
            ElseIf ($Log.InstanceId -eq 7002) {
                $eventType = "Logoff"
            }
            Else {
                Continue
            }
            $Result += New-Object PSObject -Property @{
                Time      = $Log.TimeWritten
                EventType = $eventType
                User      = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
            }
        }
        $Result | Sort-Object Time -Descending
    }
    Else {
        Write-Warning "Problem with $ComputerName."
        Write-Warning "If you see a 'Network Path not found' error, try starting the Remote Registry service on that Computer."
        Write-Warning "Or there are no logon/logoff events (XP requires auditing be turned on)"
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-LogonHistory.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LogonHistory.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
