---
layout: post
title: Detect-KeyInput2.ps1
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

**_@GitHub Copilot_** - This PowerShell script demonstrates how to detect if a specific key is pressed on the keyboard. The script starts by adding two .NET assemblies, WindowsBase and PresentationCore, which are required for working with keyboard input in PowerShell.

After the assemblies are loaded, the script waits for 2 seconds using the Start-Sleep cmdlet. This is to give the user time to press and hold the key that the script will detect.

Next, the script sets the `$key` variable to the `LeftCtrl` key. This is the key that the script will detect. The script then uses the `[System.Windows.Input.Keyboard]::IsKeyDown($key)` method to check if the `LeftCtrl` key is pressed. If the key is pressed, the script outputs a message to the console saying "You pressed left CTRL, so I am now doing extra stuff".

Overall, this script is a simple example of how to detect keyboard input in PowerShell. It can be useful for automating tasks that require specific keyboard input, such as hotkeys or shortcuts.

Possible ways to improve the code with respect to readability and performance include adding comments to explain the purpose of each line of code, using more descriptive variable names, and optimizing the code to reduce unnecessary operations.

---

#### Script

```powershell
# this could be part of your profile script

Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# assume the script is doing something
# (so you can get ready to press and hold left Ctrl!)
Start-Sleep -Seconds 2

# choose the key you are after
$key = [System.Windows.Input.Key]::LeftCtrl
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key)

if ($isCtrl) {
    'You pressed left CTRL, so I am now doing extra stuff'
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Detect-KeyInput2.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Detect-KeyInput2.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
