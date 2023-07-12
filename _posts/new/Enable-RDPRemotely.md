---
layout: post
title: Enable-RDPRemotely.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Enable-RDPRemotely`. This function enables Remote Desktop Protocol (RDP) on one or more remote computers. The function takes a single parameter called `$ComputerName`, which is an array of strings that contains the names of the computers on which RDP should be enabled.

The function uses the `foreach` loop to iterate over each computer name in the `$ComputerName` array. For each computer, the function uses either the `Get-CimInstance` cmdlet or the `Get-WmiObject` cmdlet to retrieve the `Win32_TerminalServiceSetting` object that represents the RDP settings on the remote computer.

If the version of PowerShell is 6 or greater, the function uses the `Get-CimInstance` cmdlet to retrieve the `Win32_TerminalServiceSetting` object. Otherwise, it uses the `Get-WmiObject` cmdlet. Once the `Win32_TerminalServiceSetting` object is retrieved, the function calls the `SetAllowTSConnections` method on the object to enable RDP on the remote computer.

The `SetAllowTSConnections` method takes two arguments: `AllowTSConnections` and `ModifyFirewallException`. Both arguments are set to 1 to enable RDP and modify the firewall exception, respectively.

Finally, the function outputs a string that indicates whether RDP was successfully enabled on each remote computer.

To improve the code's readability, the developer could add comments to explain the purpose of each section of the code. Additionally, the developer could use more descriptive variable names to make the code easier to understand. To improve the code's performance, the developer could consider using the `Invoke-Command` cmdlet to run the RDP enabling code on multiple remote computers simultaneously.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use the `Enable-RDPRemotely` function:

Example 1: Enable RDP on a single remote computer

```powershell
Enable-RDPRemotely -ComputerName 'RemoteComputer01'
```

This command enables RDP on a single remote computer named "RemoteComputer01".

Example 2: Enable RDP on multiple remote computers

```powershell
$Computers = 'RemoteComputer01', 'RemoteComputer02', 'RemoteComputer03'
Enable-RDPRemotely -ComputerName $Computers
```

This command enables RDP on three remote computers named "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03".

Example 3: Enable RDP on all computers in an Active Directory organizational unit

```powershell
$Computers = Get-ADComputer -Filter * -SearchBase 'OU=Computers,DC=Contoso,DC=com' | Select-Object -ExpandProperty Name
Enable-RDPRemotely -ComputerName $Computers
```

This command retrieves all computers in the "Computers" organizational unit of the "Contoso.com" domain using the `Get-ADComputer` cmdlet, selects only the computer names using the `Select-Object` cmdlet, and then enables RDP on all of the computers using the `Enable-RDPRemotely` function.

---

#### Script

```powershell
function Enable-RDPRemotely {
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
        # Enable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 1; ModifyFirewallException = 1 } -ComputerName $Computer
        }
        # Enable RDP using CIM
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(1, 1)
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Enable-RDPRemotely.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RDPRemotely.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
