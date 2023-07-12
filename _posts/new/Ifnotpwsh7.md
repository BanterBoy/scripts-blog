---
layout: post
title: Ifnotpwsh7.ps1
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

**_@GitHub Copilot_** - This PowerShell code is using an if-else statement to check the version of PowerShell that is currently running. The if statement checks if the major version of the PowerShell version is greater than or equal to 6. If this condition is true, then the code block inside the if statement will execute and the string "Do something" will be outputted to the console using the Write-Output cmdlet. If the condition is false, then the code block inside the else statement will execute and the string "Do something else" will be outputted to the console.

In this specific case, the cursor is on line 10 which is the code block inside the else statement. This means that the PowerShell version is less than 6 and the string "Do something else" will be outputted to the console.

Overall, this code is a simple example of how to check the version of PowerShell that is currently running and execute different code blocks based on the version. To improve the readability of this code, it could be helpful to add comments explaining the purpose of the if-else statement and the code blocks inside each statement. Additionally, the indentation of the code could be improved to make it easier to read and understand.

---

#### Script

```powershell
if ($PSVersionTable.PSVersion.Major -ge 6) {

    Write-Output "Do something"

}
else {

    Write-Output "Do something else"

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Ifnotpwsh7.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Ifnotpwsh7.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
