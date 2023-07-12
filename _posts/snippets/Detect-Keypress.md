---
layout: post
title: Detect-Keypress.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to detect when a specific key is pressed and then take action based on that key press. The script begins by adding two types to the PowerShell session: WindowsBase and PresentationCore. These types are necessary for the script to interact with the Windows operating system and the graphical user interface.

Next, the script sets a variable called `$key` to the value of the `LeftCtrl` key. This key is the one that the script will be looking for when it is running. The script then writes a warning message to the console, telling the user to press the `$key` key to abort the script.

The script then enters a `do` loop that will run indefinitely until the script is aborted. Within the loop, the script checks to see if the `$key` key is being pressed by using the `IsKeyDown` method of the `Keyboard` class. If the key is being pressed, the script writes a message to the console indicating that the key has been pressed and then exits the loop.

If the key is not being pressed, the script writes a period to the console and then waits for 100 milliseconds before checking the key again. This loop will continue to run until the `$key` key is pressed.

Overall, this script is a simple but effective way to detect when a specific key is pressed and then take action based on that key press. It uses the `Keyboard` class from the WindowsBase and PresentationCore assemblies to detect the key press and then writes messages to the console to indicate what is happening.

To improve the readability of the code, the script could be broken down into smaller functions or modules. Additionally, the script could be optimized for performance by reducing the amount of time that it spends waiting for the key to be pressed.

---

#### Script

```powershell
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# choose the abort key
$key = [System.Windows.Input.Key]::LeftCtrl

Write-Warning "PRESS $key TO ABORT!"

do {
    $isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key)
    if ($isCtrl) {
        Write-Host
        Write-Host "You pressed $key, so exiting!" -ForegroundColor Green
        break
    }
    Write-Host "." -NoNewline
    Start-Sleep -Milliseconds 100
} while ($true)
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Detect-Keypress.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Detect-Keypress.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
