---
layout: post
title: Search-GPOsForStringOrig.ps1
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
#########################################################
#
# Name: Search-GPOsForString.ps1
# Author: Tony Murray
# Version: 1.0
# Date: 13/07/2016
# Comment: Simple search for GPOs within a domain
# that match a given string
########################################################

# Get the string we want to search for
$string = Read-Host -Prompt "What string do you want to search for?"

# Set the domain to search for GPOs
$DomainName = $env:USERDNSDOMAIN

# Find all GPOs in the current domain
write-host "Finding all the GPOs in $DomainName"
Import-Module grouppolicy
$allGposInDomain = Get-GPO -All -Domain $DomainName

# Look through each GPO's XML for the string
Write-Host "Starting search...."
foreach ($gpo in $allGposInDomain) {
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml
    if ($report -match $string) {
        write-host "********** Match found in: $($gpo.DisplayName) **********"
    } # end if
    else {
        Write-Host "No match in: $($gpo.DisplayName)"
    } # end else
} # end foreach
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Search-GPOsForStringOrig.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Search-GPOsForStringOrig.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
