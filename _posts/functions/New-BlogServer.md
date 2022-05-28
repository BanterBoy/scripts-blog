---
layout: post
title: New-BlogServer.ps1
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
function global:New-BlogServer {
    [CmdletBinding(DefaultParameterSetName = 'default')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter path or Browse to select dockerfile")]
        [ValidateSet('Select', 'Blog')]
        [string]$BlogPath,
        [string]$Path
    )
    switch ($BlogPath) {
        Select {
            try {
                $PSRootFolder = Select-FolderLocation
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }
        Blog {
            try {
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root "$Path"
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }
        Default {
            try {
                $PSRootFolder = Select-FolderLocation
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/New-BlogServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-BlogServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
