---
layout: post
title: ADChangeReport.ps1
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
Import-Module Dashimo # Install-Module Dashimo -Force
Import-Module PSWinReportingV2 # Install-Module PSWinReportingV2 -Force

$Reports = @(
    'ADUserChanges'
    'ADUserChangesDetailed'
    'ADComputerChangesDetailed'
    'ADUserStatus'
    'ADUserLockouts'
    #'ADUserLogon'
    'ADUserUnlocked'
    'ADComputerCreatedChanged'
    'ADComputerDeleted'
    #'ADUserLogonKerberos'
    'ADGroupMembershipChanges'
    'ADGroupEnumeration'
    'ADGroupChanges'
    'ADGroupCreateDelete'
    'ADGroupChangesDetailed'
    'ADGroupPolicyChanges'
    'ADLogsClearedSecurity'
    'ADLogsClearedOther'
    #'ADEventsReboots'
)

$Events = Find-Events -Report $Reports -DatesRange Everything -Servers 'DC01', 'DC02', 'DC03', 'DC04', 'DC05', 'DC06' -Verbose

Dashboard -FilePath $PSScriptRoot\DashboardFromEvents.html -Name 'Dashimo - FindEvents' -Show {
    Tab -Name 'Computer Changes' {
        Section -Name 'ADComputerCreatedChanged' {
            Table -DataTable $Events.ADComputerCreatedChanged
        }
        Section -Name 'ADComputerDeleted' {
            Table -DataTable $Events.ADComputerDeleted
        }
        Section -Name 'ADComputerChangesDetailed' {
            Table -DataTable $Events.ADComputerChangesDetailed
        }
    }
    Tab -Name 'Group Changes' {
        Section -Name 'ADGroupCreateDelete' {
            Table -DataTable $Events.ADGroupCreateDelete
        }
        Section -Name 'ADGroupMembershipChanges' {
            Table -DataTable $Events.ADGroupMembershipChanges
        }
        Section -Name 'ADGroupEnumeration' {
            Table -DataTable $Events.ADGroupEnumeration
        }
        Section -Name 'ADGroupChanges' {
            Table -DataTable $Events.ADGroupChanges
        }
        Section -Name 'ADGroupChangesDetailed' {
            Table -DataTable $Events.ADGroupChangesDetailed
        }
    }
    Tab -Name 'User Changes' {
        Section -Name 'ADUserChanges' {
            Table -DataTable $Events.ADUserChanges
        }
        Section -Name 'ADUserChangesDetailed' {
            Table -DataTable $Events.ADUserChangesDetailed
        }
        Section -Name 'ADUserLockouts' {
            Table -DataTable $Events.ADUserLockouts
        }
        Section -Name 'ADUserStatus' {
            Table -DataTable $Events.ADUserStatus
        }
        Section -Name 'ADUserUnlocked' {
            Table -DataTable $Events.ADUserUnlocked
        }
    }
    Tab -Name 'Group Policy Changes' {
        Section -Name 'ADGroupPolicyChanges' {
            Table -DataTable $Events.ADGroupPolicyChanges
        }
    }
    Tab -Name 'Logs' {
        Section -Name 'ADLogsClearedOther' {
            Table -DataTable $Events.ADLogsClearedOther
        }
        Section -Name 'ADLogsClearedSecurity' {
            Table -DataTable $Events.ADLogsClearedSecurity
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/ADChangeReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ADChangeReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
