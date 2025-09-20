---
layout: post
title: Get-TempHumidData.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-TempHumidData/
categories:
- UserAdminModule
- Weather
tags:
- PowerShell
- User Admin Module
- Temp Humid Data
description: Get-TempHumidData monitors the most recent temperature and humidity sample
  stored in \\HOTH\TEMPerX\TEMPerX\1.csv. The function temporarily resizes the...
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Get-TempHumidData` monitors the most recent temperature and humidity sample stored in `\\HOTH\TEMPerX\TEMPerX\1.csv`. The function temporarily resizes the console window, reads the last CSV row, displays it, waits five seconds, clears the screen, and loops to provide a live feed. A helper `Restore-Console` function is included so you can return the console to its original size when finished.

**Usage examples**

```powershell
Get-TempHumidData
# When finished
Restore-Console
```

Ensure `Set-ConsoleConfig` is available in your session and that the network share is accessible before running the monitor.

---

#### Script

```powershell
Function Get-TempHumidData {
    Set-ConsoleConfig -WindowHeight 2 -WindowWidth 45
    Get-Content -Path "\\HOTH\TEMPerX\TEMPerX\1.csv" | ConvertFrom-Csv -Delimiter ',' | Select-Object -Last 1
    Start-Sleep -Seconds 5
    Clear-Host
    Get-TempHumidData
}

Function Restore-Console {
    Set-ConsoleConfig -WindowHeight 40 -WindowWidth 150
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Weather/Public/Get-TempHumidData.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TempHumidData.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
