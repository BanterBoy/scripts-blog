---
layout: post
title: Exch-AgentLogs.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
# Exchange Server Admin Audit Report
# This script has been written to report on events in the Exchange server admin audit log over the last 48 hours.
# This has been written for Exchange 2010 SP3 and to be compatible with PowerShell 2.0
# Version 1.0 -  James Pearman, November 2018


#Parameters

$Date = Get-Date
$yesterday = (Get-Date).AddHours(-48)
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exch@domain.com"
$EmailSubject = "Exchange Server Audit Report" + $Date
$SMTPServer = "smtp.domain.com"
$ReportFileName = "C:\Support\ExchAdminLog.html"


#Create HTML Table

$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Exchange Server Admin Log"

#Get Admin Logs

$logs = Search-AdminAuditLog -StartDate $yesterday | Select-Object ObjectModified, CmdletName, @{Expression = { $_.CmdletParameters }; Label = "CmdletParameters"; }, @{Expression = { $_.ModifiedProperties }; Label = "ModifiedProperties"; }, Caller, Succeeded, Error, RunDate

$Logs | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Send Email

$Body = [System.IO.File]::ReadAllText('C:\Support\ExchAdminLog.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/Exchange/Exch-AgentLogs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Exch-AgentLogs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
