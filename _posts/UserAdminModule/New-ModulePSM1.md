---
layout: post
title: New-ModulePSM1.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-ModulePSM1/
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

`New-ModulePSM1` rebuilds the `.psm1` file for a module by concatenating every script found in the module's `Public` folder. Pass the root module path with `-FilePath` and the function removes the existing `.psm1` before appending each script's contents.

**Usage examples**

```powershell
New-ModulePSM1 -FilePath 'C:\GitRepos\UserAdminModule'
```

The function expects helper variables (such as `$path`) to exist in scope; ensure the module's structure matches the repository layout before running it to avoid deleting the wrong file.

---

#### Script

```powershell
function New-ModulePSM1 {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the file path for the data input. The location should be an HR Share with restricted access."
        )]
        [string]
        $FilePath
    )

    $ModuleName = $path.Parent.name[0]

    $Scripts = Get-ChildItem -Path $FilePath\Public -File | Select-Object -Property FullName
    Remove-Item -Path $FilePath\$ModuleName.psm1

    foreach ( $Script in $Scripts) {
        $Content = Get-Content -Path "$($Script.fullname)"
        Add-Content -Path $FilePath\$ModuleName.psm1 -Value $Content
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-ModulePSM1.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-ModulePSM1.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
