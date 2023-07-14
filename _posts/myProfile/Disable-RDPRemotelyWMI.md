---
layout: post
title: Disable-RDPRemotelyWMI.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell function called `Disable-RDPRemotelyWMI`. This function disables Remote Desktop Protocol (RDP) remotely using Windows Management Instrumentation (WMI). The function takes an array of computer names as input and iterates through each computer to disable RDP.

Within the function, there is a `foreach` loop that iterates through each computer name in the input array. For each computer, the function uses the `Get-WmiObject` cmdlet to retrieve the `Win32_TerminalServiceSetting` WMI class from the `Root\CimV2\TerminalServices` namespace. This class contains properties and methods related to Terminal Services settings, including the ability to enable or disable RDP.

The function then calls the `SetAllowTSConnections` method on the retrieved `Win32_TerminalServiceSetting` object, passing in two parameters: `0` and `0`. These parameters respectively disable RDP and prevent the server from listening for RDP connections.

Overall, this function provides a convenient way to disable RDP on multiple remote computers using PowerShell and WMI.

To improve the code's readability, the function could benefit from more descriptive variable names. Additionally, the function could be optimized for performance by using the `Invoke-WmiMethod` cmdlet instead of `Get-WmiObject` and `SetAllowTSConnections`. This would allow the function to directly call the `SetAllowTSConnections` method without first retrieving the entire `Win32_TerminalServiceSetting` object.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you can use the `Disable-RDPRemotelyWMI` function:

Example 1: Disable RDP on a single remote computer

```powershell
Disable-RDPRemotelyWMI -ComputerName "RemoteComputer01"
```

Example 2: Disable RDP on multiple remote computers

```powershell
Disable-RDPRemotelyWMI -ComputerName "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
```

Example 3: Disable RDP on remote computers listed in a text file

```powershell
$computers = Get-Content -Path "C:\Computers.txt"
Disable-RDPRemotelyWMI -ComputerName $computers
```

In these examples, replace "RemoteComputer01", "RemoteComputer02", etc. with the actual names of the remote computers you want to disable RDP on. You can also replace "C:\Computers.txt" with the path to a text file containing a list of remote computer names, with each name on a separate line.

---

#### Script

```powershell
function Disable-RDPRemotelyWMI {
    # You can also disable it using the below method.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        $tsobj.SetAllowTSConnections(0, 0)
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Disable-RDPRemotelyWMI.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-RDPRemotelyWMI.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
