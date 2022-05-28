---
layout: post
title: RaiseActiveDirectoryFunctionalLevel.ps1
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
# This script will raise the Active Directory Functional Level.
# The functionality level should already be set to Windows 2008 R2 during the DCPromo process.

$RaiseTo = "windows2008R2Forest"

Import-Module ActiveDirectory

$ForestInfo = Get-ADForest
$ForestName = $ForestInfo.Name
$RaiseFrom = $ForestInfo.ForestMode

If ($RaiseFrom -ne $RaiseTo) {
  Write-Host -ForegroundColor green "Raising the $ForestName forest from $RaiseFrom to $RaiseTo mode..."
  # Use either one of the following lines:
  Set-ADForestMode -ForestMode $RaiseTo -confirm:$false
  #Set-ADForestMode -Identity $ForestName -ForestMode $RaiseTo -confirm:$false
}
Else {
  Write-Host -ForegroundColor yellow "The $ForestName forest is already set to $RaiseFrom functionality level."
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/RaiseActiveDirectoryFunctionalLevel.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=RaiseActiveDirectoryFunctionalLevel.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
