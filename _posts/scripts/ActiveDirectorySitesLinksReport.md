---
layout: post
title: ActiveDirectorySitesLinksReport.ps1
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

  Active Directory Site Link Reporting

  Original script written by Ashley McGlone, Microsoft PFE, June 2011
  Report and Edit AD Site Links From PowerShell:
    http://blogs.technet.com/b/ashleymcglone/archive/2011/06/29/report-and-edit-ad-site-links-from-powershell-turbo-your-ad-replication.aspx

#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$SiteLinksReport = $(&$ScriptPath) + "\ActiveDirectorySiteLinksReport.csv"

#----------------------Site Link Report-----------------------

Import-Module -Name ActiveDirectory

# Report of all site links and related settings
$AllSiteLinks = Get-ADObject -Filter 'objectClass -eq "siteLink"' -Searchbase (Get-ADRootDSE).ConfigurationNamingContext -Property Description, Options, Cost, ReplInterval, SiteList, Schedule | Select-Object Name, Description, @{Name = "SiteCount"; Expression = { $_.SiteList.Count } }, Cost, ReplInterval, @{Name = "Schedule"; Expression = { If ($_.Schedule) { If (($_.Schedule -Join " ").Contains("240")) { "NonDefault" }Else { "24x7" } }Else { "24x7" } } }, Options

#$AllSiteLinks | Format-Table * -AutoSize
$AllSiteLinks | Export-Csv -NoTypeInformation "$SiteLinksReport"

#Remove the quotes
(Get-Content "$SiteLinksReport") | ForEach-Object { $_ -replace '"', "" } | Out-File "$SiteLinksReport" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/ActiveDirectorySitesLinksReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ActiveDirectorySitesLinksReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
