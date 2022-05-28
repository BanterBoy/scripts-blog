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
# Add required assemblies
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# Pause to be able to press and hold a key
Start-Sleep -Seconds 1

# Key list
$Nokey = [System.Windows.Input.Key]::None
$key1 = [System.Windows.Input.Key]::LeftCtrl
$key2 = [System.Windows.Input.Key]::LeftShift

# Key presses
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key1)
$isShift = [System.Windows.Input.Keyboard]::IsKeyDown($key2)

# If LeftCtrl key is pressed, launch User Work Profile
if ($isCtrl) {
	Write-Warning -Message "LeftCtrl key has been pressed - User Work Profile"
	& (Join-Path $PSScriptRoot "/personalProfiles/WorkPowerShell_profile.ps1")
	& (Join-Path $PSScriptRoot "/personalProfiles/Connect-Office365Services.ps1")
}

# If LeftShift key is pressed, start PowerShell without a Profile
elseif ($isShift) {
	Write-Warning -Message "LeftShift key has been pressed - PowerShell without a Profile"
	Start-Process "pwsh.exe" -ArgumentList "-NoNewWindow -noprofile"
}

# If no key is pressed, launch User Home Profile
elseif ($Nokey -eq 'None') {
	Write-Warning -Message "No key has been pressed - User Home Profile"
	& (Join-Path $PSScriptRoot "/personalProfiles/HomePowerShell_profile.ps1")
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/powerShellProfile/Microsoft.PowerShell_profile.ps1')">
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

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
