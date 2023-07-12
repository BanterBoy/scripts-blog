---
layout: post
title: Detect-KeyInput.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script is designed to detect which key is pressed and execute a specific action based on the key pressed. The script begins by adding the required assemblies for the script to function properly. The script then pauses for 2 seconds to allow the user to press and hold a key.

The script then defines a list of keys that can be pressed, including the "None" key, LeftCtrl, and LeftShift. The script then checks to see which key is pressed by using the IsKeyDown method from the PresentationCore assembly. The results of these checks are stored in variables for later use.

The script then uses a series of if-else statements to determine which action to take based on the key pressed. If no key is pressed, the script launches the user's home PowerShell profile. If the LeftCtrl key is pressed, the script connects to Office365. If the LeftShift key is pressed, the script starts PowerShell without a profile.

Overall, this script is a simple but effective way to detect key presses and execute specific actions based on the key pressed. However, the script could be improved by adding more keys to the list of detectable keys, and by adding more actions that can be executed based on the key pressed. Additionally, the script could be made more readable by adding comments to explain what each section of the code does.

---

#### Script

```powershell
# Add required assemblies
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# Pause to be able to press and hold a key
Start-Sleep -Seconds 2

# Key list
$Nokey = [System.Windows.Input.Key]::None
$key1 = [System.Windows.Input.Key]::LeftCtrl
$key2 = [System.Windows.Input.Key]::LeftShift

# Key presses
$isNokey = $Nokey
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key1)
$isShift = [System.Windows.Input.Keyboard]::IsKeyDown($key2)

# If no key is pressed, launch User Home Profile
if ($isNokey -eq 'None') {
    & (Join-Path $PSScriptRoot "/PersonalProfiles/HomePowerShell_profile.ps1")
}

# If LeftCtrl key is pressed, connect to Office365
elseif ($isCtrl) {
    & (Join-Path $PSScriptRoot "/PersonalProfiles/Connect-Office365Services.ps1")
}

# If LeftShift key is pressed, start PowerShell without a Profile
elseif ($isShift) {
    Start-Process "pwsh.exe" -ArgumentList  "-noprofile" -NoNewWindow
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Detect-KeyInput.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Detect-KeyInput.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/snippets.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Snippets
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
