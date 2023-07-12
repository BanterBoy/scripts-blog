---
layout: post
title: Get-TimeServer.ps1
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

**_@GitHub Copilot_** -

---

#### Script

```powershell
function Get-TimeServer {
    <#
        .Synopsis
        Gets the time server as configured on a computer.
        .DESCRIPTION
        Gets the time server as configured on a computer.
        The default is localhost but can be used for remote computers.
        .EXAMPLE
        Get-TimeServer -ComputerName "Server1"
        .EXAMPLE
        Get-TimeServer -ComputerName "Server1","Server2"
        .EXAMPLE
        Get-TimeServer -Computer "Server1","Server2"
        .EXAMPLE
        Get-TimeServer "Server1","Server2"
        .NOTES
        Written by Jeff Wouters.
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0)]
        [alias("computer")]
        [array]$ComputerName
    )
    begin {
        $HKLM = 2147483650
    }
    process {
        foreach ($Computer in $ComputerName) {
            $TestConnection = Test-Connection -ComputerName $Computer -Quiet -Count 1
            $Output = New-Object -TypeName psobject
            $Output | Add-Member -MemberType 'NoteProperty' -Name 'ComputerName' -Value $Computer
            $Output | Add-Member -MemberType 'NoteProperty' -Name 'TimeServer' -Value "WMI Error"
            $Output | Add-Member -MemberType 'NoteProperty' -Name 'Type' -Value "WMI Error"
            if ($TestConnection) {
                try {
                    $reg = [wmiclass]"\\$Computer\root\default:StdRegprov"
                    $key = "SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
                    $servervalue = "NtpServer"
                    $server = $reg.GetStringValue($HKLM, $key, $servervalue)
                    $ServerVar = $server.sValue -split ","
                    $Output.TimeServer = $ServerVar[0]
                    $typevalue = "Type"
                    $type = $reg.GetStringValue($HKLM, $key, $typevalue)
                    $Output.Type = $Type.sValue
                    $Output
                }
                catch {
                }
            }
            else {
            }
        }
    }
}
Get-TimeServer -ComputerName $Server.Name
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/time/Get-TimeServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TimeServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
