---
layout: post
title: Enable-RDPRemotelyCIM.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell function called `Enable-RDPRemotelyCIM`. This function enables Remote Desktop Protocol (RDP) on a remote host by running two lines of code.

The function is defined with `[CmdletBinding()]` and a `param` block that takes a parameter called `$ComputerName`. This parameter is an array of strings that represents the names of the remote computers on which RDP needs to be enabled.

The function then uses a `foreach` loop to iterate through each computer name in the `$ComputerName` array. Inside the loop, the function uses the `Get-CimInstance` cmdlet to retrieve an instance of the `Win32_TerminalServiceSetting` class from the `root/cimv2/TerminalServices` namespace on the remote computer. This instance is stored in the `$Win32TerminalServiceSettings` variable.

Finally, the function uses the `Invoke-CimMethod` cmdlet to invoke the `SetAllowTSConnections` method on the `$Win32TerminalServiceSettings` object. This method takes two arguments: `AllowTSConnections` and `ModifyFirewallException`. Both arguments are set to `1`, which enables RDP and modifies the firewall exception to allow RDP traffic.

In terms of improving the code, one possible suggestion is to add error handling to the function. For example, if a remote computer is not reachable or does not have the necessary permissions to enable RDP, the function should gracefully handle these errors and provide feedback to the user. Additionally, the function could be made more efficient by using PowerShell remoting to enable RDP on multiple remote computers simultaneously.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here's an example of how to use the `Enable-RDPRemotelyCIM` function:

```powershell
# Enable RDP on two remote computers
Enable-RDPRemotelyCIM -ComputerName "computer1", "computer2"
```

In this example, the `Enable-RDPRemotelyCIM` function is called with the `-ComputerName` parameter, which takes an array of strings representing the names of the remote computers on which RDP needs to be enabled. In this case, RDP will be enabled on two remote computers named "computer1" and "computer2".

Note that you can pass any number of computer names to the `-ComputerName` parameter, separated by commas.

---

#### Script

```powershell
function Enable-RDPRemotelyCIM {
    # You can enable RDP on a remote host by simply running the below two lines.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
        $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections=1;ModifyFirewallException=1} -ComputerName $Computer
    }

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Enable-RDPRemotelyCIM.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RDPRemotelyCIM.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
