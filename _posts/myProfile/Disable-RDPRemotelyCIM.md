---
layout: post
title: Disable-RDPRemotelyCIM.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell function called `Disable-RDPRemotelyCIM`. It disables Remote Desktop Protocol (RDP) on one or more remote computers. The function takes an array of computer names as input and then loops through each computer to disable RDP.

The function uses the `Get-CimInstance` cmdlet to retrieve the `Win32_TerminalServiceSetting` class from the `root/cimv2/TerminalServices` namespace on each remote computer. The `Win32_TerminalServiceSetting` class contains properties and methods that allow you to configure Terminal Services settings on a Windows computer.

The function then pipes the `Win32TerminalServiceSettings` object to the `Invoke-CimMethod` cmdlet to call the `SetAllowTSConnections` method. This method takes two arguments: `AllowTSConnections` and `ModifyFirewallException`. The `AllowTSConnections` argument is set to `0` to disable RDP, and the `ModifyFirewallException` argument is set to `0` to prevent the method from modifying the Windows Firewall exception for RDP.

Overall, this function is a useful tool for disabling RDP on multiple remote computers at once. However, it's worth noting that the function assumes that the remote computers are running Windows and that they have the `Win32_TerminalServiceSetting` class available in the `root/cimv2/TerminalServices` namespace. If these assumptions are not met, the function may not work as expected.

To improve the code's readability, the function could benefit from more descriptive variable names. Additionally, the function could be optimized for performance by using the `Invoke-Command` cmdlet to run the `SetAllowTSConnections` method in parallel on multiple remote computers.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use the `Disable-RDPRemotelyCIM` function:

1. Disable RDP on a single remote computer:

```powershell
Disable-RDPRemotelyCIM -ComputerName "RemoteComputer01"
```

2. Disable RDP on multiple remote computers:

```powershell
Disable-RDPRemotelyCIM -ComputerName "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
```

3. Disable RDP on all computers in an Active Directory domain:

```powershell
$Computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
Disable-RDPRemotelyCIM -ComputerName $Computers
```

Note that in the third example, we're using the `Get-ADComputer` cmdlet to retrieve a list of all computers in the Active Directory domain, and then passing that list to the `Disable-RDPRemotelyCIM` function. This is just one way to generate a list of computer names programmatically - you could also hard-code the list of computer names or retrieve them from a CSV file, for example.

---

#### Script

```powershell
function Disable-RDPRemotelyCIM {
    # You can also disable it using the below method.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
        $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections=0;ModifyFirewallException=0} -ComputerName $Computer
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Disable-RDPRemotelyCIM.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-RDPRemotelyCIM.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
