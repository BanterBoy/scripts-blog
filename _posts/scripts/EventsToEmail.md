---
layout: post
title: EventsToEmail.ps1
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
#Event Logs Send to Email Script
#Version:1.0, June 2018, James Pearman

#Parameters
$ServerName = "$env:computername"
$EmailTo = "<INSERT EMAIL ADDRESS>"
$EmailFrom = "<INSERT EMAIL ADDRESS>"
$EmailSubject = "Server Events for " + $ServerName
$SMTPServer = "<INSERT SMTP>"
$ReportFileName = "C:\Support\LogAppView.html"
$yesterday = (Get-Date).AddHours(-24)
$Date = Get-Date

#Create HTML Table
$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Application and System event logs with either warning or error status for $ServerName within last 24 hours"

#Get event logs and convert to HTML file
$Events = Get-WinEvent -FilterHashTable @{LogName = 'Application', 'System'; Level = 2, 3; StartTime = $Yesterday } -ErrorAction SilentlyContinue | Select-Object TimeCreated, LogName, ProviderName, Id, LevelDisplayName, Message

$Events | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Send Email
$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/EventLogs/EventsToEmail.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=EventsToEmail.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
