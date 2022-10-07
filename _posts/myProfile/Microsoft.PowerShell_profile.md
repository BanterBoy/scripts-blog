---
layout: post
title: Microsoft.PowerShell_profile.ps1
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
#--------------------
# Generic Profile Commands
Get-ChildItem C:\GitRepos\ProfileFunctions\ProfileFunctions\*.ps1 | ForEach-Object {. $_ }
oh-my-posh init pwsh --config C:\GitRepos\ProfileFunctions\BanterBoyOhMyPoshConfig.json | Invoke-Expression

#--------------------
# basic greeting function, contents to be added to current function
Write-Output "Type Get-ProfileFunctions to see the available functions"

#--------------------
# Configure PowerShell Console Window Size/Preferences
Set-ConsoleConfig -WindowHeight 45 -WindowWidth 180 | Out-Null

#--------------------
# PSDrives
New-PSDrive -Name GitRepos -PSProvider FileSystem -Root C:\GitRepos\ -Description "GitHub Repositories" | Out-Null
New-PSDrive -Name Sysint -PSProvider FileSystem -Root "$env:OneDrive\Software\SysinternalsSuite" -Description "Sysinternals Suite Software" | Out-Null

#--------------------
# Aliases
New-Alias -Name 'Notepad++' -Value 'C:\Program Files\Notepad++\notepad++.exe' -Description 'Launch Notepad++'

#--------------------
# Profile Starts here!
Write-Output ""
Show-IsAdminOrNot
Write-Output ""
New-Greeting
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Microsoft.PowerShell_profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Microsoft.PowerShell_profile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
