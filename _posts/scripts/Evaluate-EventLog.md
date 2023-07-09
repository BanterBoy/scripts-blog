---
layout: post
title: Evaluate-EventLog.ps1
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
<#----------
Evaluating Event Log Information

Get-EventLog provides access to the content written to the classic Windows event logs.
The most valuable information can be found in a secret property called ReplacementStrings.
Here is an approach to make this information visible so you can examine it and build reports.

In the example, the event ID 44 written by the Windows Update Client is retrieved, and the code outputs the replacement strings.
They tell you exactly which updates were downloaded, and when:
----------#>

Get-EventLog -LogName System -InstanceId 44 -Source Microsoft-Windows-WindowsUpdateClient |

ForEach-Object {

    $hash = [Ordered]@{}
    $counter = 0
    foreach ($value in $_.ReplacementStrings) {
        $counter++
        $hash.$counter = $value
    }
    $hash.EventID = $_.EventID
    $hash.Time = $_.TimeWritten
    [PSCustomObject]$hash
}

<#----------
Always make sure you query for one distinct event ID: the information found in ReplacementStrings is unique per event ID, and you don't want to mix information from different event ID types.
----------#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/EventLogs/Evaluate-EventLog.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Evaluate-EventLog.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
