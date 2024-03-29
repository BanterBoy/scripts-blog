---
layout: post
title: New-JekyllBlogPost.ps1
---

### Description

Some information about the exciting thing

- [Table of Contents](#table-of-contents)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

#### Script

```powershell
function New-JekyllScriptsPost {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Tag = 'Draft',
        [Parameter(Mandatory = $false)]
        [string]$Date = (Get-Date -Format yyyy-MM-dd),
        [Parameter(Mandatory = $false)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [ValidateSet(Post, Page)]
        [string]$Layout,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )
    $Content = Get-Content -Path  -Raw -ReadAllBytes
    $Path = $Destination + "\$date\$date-blogpost.md"
    New-Item -ItemType File -Value $Content -Path $Path
    New-Item -ItemType directory -Path ".\$date"
    code $Path
}

# Find-Files -Path C:\GitRepos\scripts-blog\PowerShell\

<#
    $Content =
    "---
    layout: $Layout
    title: $Title
    permalink: /menu/_pages/$Title.html
    tags:
    - $Tag
    - PowerShell
    ---

    $Content
    "

    $Path = $Destination + "\$date\$date-blogpost.md"
    New-Item -ItemType File -Value $Content -Path $Path
    New-Item -ItemType directory -Path ".\$date"
    code $Path
#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/templatePage.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=templatePage.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
