---
layout: post
title: Install-PoshBot.ps1
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
<#
How to Install and Run PoshBot, the PowerShell ChatOps Tool - TechSnips
https://www.techsnips.io/en/playing/how-to-install-and-run-poshbot-the-powershell-chatops-tool

Script - GitHub
https://github.com/TechSnips/SnipScripts/tree/master/How%20to%20install%20and%20run%20PoshBot
#>

Install-Module -Name PoshBot -Repository PSGallery -Scope CurrentUser
Import-Module -Name PoshBot

<#
Create a bot token
https://my.slack.com/services/new/bot

Make note of your Slack username
Replace 'poshbot-techsnips' with your Slack workspace name
https://poshbot-techsnips.slack.com/account/settings#username
#>

# Create bot configuration
$botParams = @{
    Name = 'poshbot'
    BotAdmins = @('<SLACK-USERNAME>')
    CommandPrefix = '!'
    LogLevel = 'Info'
    BackendConfiguration = @{
        Name = 'SlackBackend'
        Token = '<SLACK-TOKEN>'
    }
}
$botConfig = New-PoshBotConfiguration @botParams
$botConfig | Format-List

# Create backend instance
$backend = New-PoshBotSlackBackend -Configuration $botConfig.BackendConfiguration
$backend | Format-List

# Create and start bot
$bot = New-PoshBotInstance -Configuration $botConfig -Backend $backend
$bot | Format-List
$bot | Start-PoshBot -Verbose
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/installScripts/Install-PoshBot.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-PoshBot.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
