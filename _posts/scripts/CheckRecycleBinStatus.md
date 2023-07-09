---
layout: post
title: CheckRecycleBinStatus.ps1
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
# Check the Active Directory Recycle Bin Status

Import-Module ActiveDirectory

$ForestName = (Get-ADForest).Name
$ForestDomainNamingMaster = $((Get-ADForest -Current LocalComputer).DomainNamingMaster)

$ForestInfo = Get-ADOptionalFeature "Recycle Bin Feature" -server $ForestDomainNamingMaster
If ($NULL -eq $ForestInfo.EnabledScopes -OR $ForestInfo.EnabledScopes -eq "") {
    write-host -ForegroundColor yellow "The Recycle Bin Feature is not enabled on the $ForestName forest."
}
Else {
    write-host -ForegroundColor green "The Recycle Bin Feature is enabled on the $ForestName forest with the following scopes:"
    ForEach ($scope in $ForestInfo.EnabledScopes) {
        write-host -ForegroundColor green " - $scope"
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CheckRecycleBinStatus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CheckRecycleBinStatus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
