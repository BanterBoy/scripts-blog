---
layout: post
title: New-AdminTerminal.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-AdminTerminal/
categories:
  - UserAdminModule
  - Shell
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`New-AdminTerminal` launches Windows Terminal elevated as an administrator, targeting the PowerShell profile (`-p pwsh`). If the user is already running an elevated window, Windows prompts accordingly. Because the function simply wraps `Start-Process` with `-Verb runas`, it inherits the standard UAC prompt behaviour.

**Usage examples**

```powershell
New-AdminTerminal
```

Run this from a non-elevated console to quickly open an admin terminal without navigating the Start menu.

---

#### Script

```powershell
function New-AdminTerminal {
    <#
        .Synopsis
        Starts an Elevated Microsoft Terminal.

        .Description
        Opens a new Microsoft Terminal Elevated as Administrator. If the user is already running an elevated
        Microsoft Terminal, a message is displayed in the console session.

        .Example
        New-AdminShell

        #>

        Start-Process "wt.exe" -ArgumentList "-p pwsh" -Verb runas -PassThru
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-AdminTerminal.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-AdminTerminal.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
