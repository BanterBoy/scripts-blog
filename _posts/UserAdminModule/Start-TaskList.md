---
layout: post
title: Start-TaskList.ps1
date: 2025-09-19
permalink: /useradminmodule/processserviceschedules/start-tasklist/
categories:
  - UserAdminModule
  - ProcessServiceSchedules
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Start-TaskList` reads phrases from `C:\GitRepos\TextFiles\prankphrases.txt` and displays them through `Write-Progress`, advancing every five seconds. The function sets the default progress activity title to the current phrase to create a playful animated task list.

**Usage examples**

```powershell
Start-TaskList
```

Ensure the text file exists at the specified path or modify the script to point at your own list of status updates.

---

#### Script

```powershell
function Start-TaskList {
    $PSDefaultParameterValues['Write-Progress:Activity'] = $phrase
    $phrases = Get-Content -Path C:\GitRepos\TextFiles\prankphrases.txt
    $i = 0
    foreach ($phrase in $phrases) {
        $i++
        Write-Progress -activity “Listing Commands” -status $phrase -PercentComplete (($i / $phrases.count) * 100)
        Start-Sleep -Seconds 5
    }
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Start-TaskList.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-TaskList.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
