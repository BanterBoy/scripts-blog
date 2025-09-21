---
layout: post
title: New-JekyllBlogPost.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/jekyllblog/new-jekyllblogpost/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Creates a new Jekyll blog post or page with specified parameters.

#### Detailed Description

The New-JekyllScriptsPost function creates a new Jekyll blog post or page with the specified parameters. It generates a Markdown file with the given title, content, layout, and destination. By default, the post is tagged as 'Draft' and the date is set to the current date.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-JekyllScriptsPost -Title "My First Blog Post" -Content "Hello, world!" -Layout "Post" -Destination "C:\my-blog"
```

This example creates a new Jekyll blog post with the title "My First Blog Post", content "Hello, world!", layout set to "Post", and the destination directory set to "C:\my-blog".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates a new Jekyll blog post or page with specified parameters.

.DESCRIPTION
The New-JekyllScriptsPost function creates a new Jekyll blog post or page with the specified parameters. It generates a Markdown file with the given title, content, layout, and destination. By default, the post is tagged as 'Draft' and the date is set to the current date.

.PARAMETER Title
The title of the blog post or page.

.PARAMETER Tag
The tag for the blog post or page. Default value is 'Draft'.

.PARAMETER Date
The date of the blog post or page. Default value is the current date in the format 'yyyy-MM-dd'.

.PARAMETER Content
The content of the blog post or page.

.PARAMETER Layout
The layout for the blog post or page. Valid values are 'Post' or 'Page'.

.PARAMETER Destination
The destination directory where the blog post or page will be created.

.EXAMPLE
New-JekyllScriptsPost -Title "My First Blog Post" -Content "Hello, world!" -Layout "Post" -Destination "C:\my-blog"

This example creates a new Jekyll blog post with the title "My First Blog Post", content "Hello, world!", layout set to "Post", and the destination directory set to "C:\my-blog".

#>
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
        [ValidateSet("Post", "Page")]
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/JekyllBlog/Public/New-JekyllBlogPost.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-JekyllBlogPost.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

