---
layout: post
title: Get-ActiveDirectoryTombstonePeriod.ps1
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
function Get-ActiveDirectoryTombstonePeriod {
  <#

    This function will get the Active Directory Tombstone Period.

    Notes:
    - The tombstonelifetime period will default to 60 days if missing.
    - From Windows Server 2003 with Service Pack 1 (SP1), the default tombstonelifetime value is set
      to 180 days to increase shelf-life of backups and allow longer disconnection times.
    - The tombstonelifetime attribute and value is only set on a new forest build and not an upgrade,
      so if it is missing, the forest probably started its life as a Windows 2000 or Windows 2003
      pre-SP1 domain. However, there was also a known bug the CD2 of the Windows 2003 R2 media which
      was missing the tombstonelifetime attribute, even though the CD1 media is Windows 2003 SP1. As
      this is only set for a new build, upgrades to the forest/domain over the years does not fix this.
   -  Microsoft increased this back in Q1 2005 to help Companies avoid issues with management and
      backups of Active Directory. You don't necessarily need to set it to 180 days. It is preferable
      to adjust the value to what is appropriate for the Company's backup and recovery strategy.
      However, the value should at least be present to remove any confusion for future assessments and
      any functionality that may leverage the attribute in the future.

    References:
    - http://blog.joeware.net/2006/07/21/476/
    - http://blog.joeware.net/2006/07/23/484/

  #>

  [CmdletBinding()]
  param (
    $defaultNamingContext = (Get-ADRootDSE).defaultnamingcontext,
    $Days = (Get-ADObject "cn=Directory Service,cn=Windows NT,cn=Services,cn=Configuration,$defaultNamingContext" -properties "tombstonelifetime").tombstonelifetime
  )

  begin {
    Import-Module ActiveDirectory
  }

  process {
    if ($Days -eq "" -OR $null -eq $Days) {
      $Days = "missing so will default to 60"
    }
  }

  end {
    Write-Host -ForegroundColor green "The Active Directory Tombstone Period is $Days days."
  }

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-ActiveDirectoryTombstonePeriod.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ActiveDirectoryTombstonePeriod.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
