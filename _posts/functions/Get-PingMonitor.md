---
layout: post
title: Get-PingMonitor.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
[CmdletBinding()]
Param (
    [int32]$Count = 5,
    [Parameter(ValueFromPipeline = $true)]
    [String[]]$ComputerName,
    [string]$LogPath = "c:\pinglog\pinglog.csv"
)

$Ping = @()
#Test if path exists, if not, create it
If (-not (Test-Path (Split-Path $LogPath) -PathType Container)) {
    Write-Verbose "Folder doesn't exist $(Split-Path $LogPath), creating..."
    New-Item (Split-Path $LogPath) -ItemType Directory | Out-Null
}

#Test if log file exists, if not seed it with a header row
If (-not (Test-Path $LogPath)) {
    Write-Verbose "Log file doesn't exist: $($LogPath), creating..."
    Add-Content -Value '"TimeStamp","Source","Destination","IPV4Address","Status","ResponseTime"' -Path $LogPath
}

#Log collection loop
Write-Verbose "Beginning Ping monitoring of $ComputerName for $Count tries:"
While ($Count -gt 0) {
    $Ping = Get-WmiObject Win32_PingStatus -Filter "Address = '$ComputerName'" | Select-Object @{Label = "TimeStamp"; Expression = { Get-Date } }, @{Label = "Source"; Expression = { $_.__Server } }, @{Label = "Destination"; Expression = { $_.Address } }, IPv4Address, @{Label = "Status"; Expression = { If ($_.StatusCode -ne 0) { "Failed" } Else { "" } } }, ResponseTime
    $Result = $Ping | Select-Object TimeStamp, Source, Destination, IPv4Address, Status, ResponseTime | ConvertTo-Csv -NoTypeInformation
    $Result[1] | Add-Content -Path $LogPath
    Write-verbose ($Ping | Select-Object TimeStamp, Source, Destination, IPv4Address, Status, ResponseTime | Format-Table -AutoSize | Out-String)
    $Count --
    Start-Sleep -Seconds 1
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/ip/Get-PingMonitor.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PingMonitor.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
