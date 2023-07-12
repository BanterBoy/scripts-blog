---
layout: post
title: Install-PSTools.ps1
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

**_@GitHub Copilot_** - This code is a PowerShell script that installs PSTools, a suite of command-line tools for managing and troubleshooting Windows systems. The `Install-PSTools` function is defined on lines 1-8, and it performs the following steps:

1. Downloads the PSTools ZIP archive from the Sysinternals website using the `Invoke-WebRequest` cmdlet and saves it to the local file system with the name `pstools.zip`.
2. Extracts the contents of the ZIP archive to a temporary directory using the `Expand-Archive` cmdlet.
3. Creates a new directory named `Sysinternals` in the `C:\Program Files\` directory using the `New-Item` cmdlet.
4. Copies all files and subdirectories from the temporary directory to the `C:\Program Files\Sysinternals` directory using the `Copy-Item` cmdlet.
5. Deletes the temporary directory and all its contents using the `Remove-Item` cmdlet.

This function is useful for automating the installation of PSTools on multiple systems, or for ensuring that the tools are installed in a consistent location on a single system. The code is well-organized and easy to read, with descriptive function and variable names. One possible improvement would be to add error handling code to handle cases where the download or extraction steps fail. Additionally, the function could be modified to accept a parameter specifying the destination directory for the PSTools files, rather than hard-coding the path to `C:\Program Files\Sysinternals`.

---

#### Script

```powershell
function Install-PSTools {
	Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile 'pstools.zip'
	Expand-Archive -Path 'pstools.zip' -DestinationPath "$env:TEMP\pstools"
	New-Item -Path 'C:\Program Files\' -Name Sysinternals -ItemType Directory
	Copy-Item -Path "$env:TEMP\pstools\*.*" -Destination 'C:\Program Files\Sysinternals'
	Remove-Item -Path "$env:TEMP\pstools" -Recurse -Force
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Install-PSTools.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-PSTools.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
