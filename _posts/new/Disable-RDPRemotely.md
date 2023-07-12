---
layout: post
title: Disable-RDPRemotely.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Disable-RDPRemotely`. This function disables Remote Desktop Protocol (RDP) on one or more remote computers. The function takes an array of computer names as input and iterates through each computer to disable RDP.

The function uses the `[CmdletBinding()]` attribute to specify the default parameter set, confirm impact, support for ShouldProcess, and a help URI. The `[OutputType()]` attribute specifies the output type of the function.

The function has one parameter called `$ComputerName`, which is an array of strings. This parameter is optional, can be piped in, and has an alias of `cn`. The parameter is used to specify the name of the computer(s) to disable RDP on.

The function uses an `if` statement to check the version of PowerShell. If the version is 6 or greater, the function uses the `Get-CimInstance` cmdlet to get an instance of the `Win32_TerminalServiceSetting` class from the `root/cimv2/TerminalServices` namespace. The function then uses the `Invoke-CimMethod` cmdlet to call the `SetAllowTSConnections` method on the instance, passing in arguments to disable RDP and modify the firewall exception.

If the version of PowerShell is less than 6, the function uses the `Get-WmiObject` cmdlet to get an instance of the `Win32_TerminalServiceSetting` class from the `Root\CimV2\TerminalServices` namespace. The function then calls the `SetAllowTSConnections` method on the instance, passing in arguments to disable RDP.

In terms of readability, the code is well-structured and easy to follow. The use of comments and descriptive variable names helps to make the code more understandable. However, the function could benefit from additional error handling and logging to make it more robust. Additionally, the function could be optimized for performance by using parallel processing to disable RDP on multiple computers simultaneously.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure, here are some examples of how you can use the `Disable-RDPRemotely` function:

1. Disable RDP on a single remote computer:

```powershell
Disable-RDPRemotely -ComputerName "RemoteComputer01"
```

2. Disable RDP on multiple remote computers:

```powershell
Disable-RDPRemotely -ComputerName "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
```

3. Disable RDP on remote computers specified in a text file:

```powershell
$computers = Get-Content -Path "C:\Computers.txt"
Disable-RDPRemotely -ComputerName $computers
```

4. Disable RDP on remote computers specified by pipeline input:

```powershell
Get-Content -Path "C:\Computers.txt" | Disable-RDPRemotely
```

These examples assume that the `Disable-RDPRemotely` function is defined in a PowerShell script or module that has been loaded into the current PowerShell session.

---

#### Script

```powershell
function Disable-RDPRemotely {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        # Disable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 0; ModifyFirewallException = 0 } -ComputerName $Computer
        }
        # Disable RDP using WMI
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(0, 0)
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Disable-RDPRemotely.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-RDPRemotely.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
