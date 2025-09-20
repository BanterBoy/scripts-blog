---
layout: post
title: Get-GoogleDirections.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-GoogleDirections/
categories:
  - UserAdminModule
  - Shell
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Get-GoogleDirections` is a convenience function that opens Google Maps in your default browser with driving directions between two points. Provide origin and destination strings and the script builds the URL and launches it with `Start-Process`.

**Usage examples**

```powershell
Get-GoogleDirections -From 'London' -To 'Manchester'
Get-GoogleDirections -From 'EC2A 2BA' -To 'Heathrow Airport'
```

The parameters accept any URL-encoded string accepted by Google Maps, so you can supply postcodes, cities, or full street addresses.

---

#### Script

```powershell
function Get-GoogleDirections {
    param([string] $From, [String] $To)

    process {
        Start-Process "https://www.google.com/maps/dir/$From/$To/"
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-GoogleDirections.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GoogleDirections.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
