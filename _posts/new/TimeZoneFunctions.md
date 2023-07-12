---
layout: post
title: Blank-Page.ps1
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

**_@GitHub Copilot_** - The PowerShell script that defines a function called `Set-ServerTimeZone`. This function takes in an array of computer names as input and sets the time zone of each computer to "GMT Standard Time".

The function is defined with a `[CmdletBinding]` attribute, which allows it to be used as a cmdlet in PowerShell. The `DefaultParameterSetName` parameter of the attribute is set to 'Default', which means that if no parameter set is specified, the default parameter set will be used. The `HelpUri` parameter of the attribute is set to a GitHub repository, which provides help documentation for the function.

The function takes in a single parameter called `$ComputerName`, which is an array of strings. This parameter is marked as mandatory and can be piped into the function. The `Alias` attribute is used to provide an alternative name for the parameter, which is 'cn'. The `HelpMessage` parameter is used to provide a help message for the parameter.

The `BEGIN` block is empty, which means that it will be executed once before the input is processed. The `PROCESS` block contains a loop that iterates over each computer name in the `$ComputerName` array. For each computer name, the `Invoke-Command` cmdlet is used to run a script block on the remote computer. The script block sets the time zone of the remote computer to "GMT Standard Time" using the `Set-TimeZone` cmdlet.

To improve the readability of the code, the `BEGIN` block could be removed since it is empty. Additionally, the `PROCESS` block could be indented to make it more clear that it is a loop. Finally, the `HelpUri` parameter could be updated to point to more detailed documentation, and the `HelpMessage` parameter could be updated to provide more specific guidance on how to use the parameter.

**_@GitHub Copilot_** - The PowerShell script that defines a function called `Get-ServerTimeZone`. This function takes in an array of computer names as input and retrieves the time zone of each computer.

The function is defined with a `[CmdletBinding]` attribute, which allows it to be used as a cmdlet in PowerShell. The `DefaultParameterSetName` parameter of the attribute is set to 'Default', which means that if no parameter set is specified, the default parameter set will be used. The `HelpUri` parameter of the attribute is set to a GitHub repository, which provides help documentation for the function.

The function takes in a single parameter called `$ComputerName`, which is an array of strings. This parameter is marked as mandatory and can be piped into the function. The `Alias` attribute is used to provide an alternative name for the parameter, which is 'cn'. The `HelpMessage` parameter is used to provide a help message for the parameter.

The `BEGIN` block is empty, which means that it will be executed once before the input is processed. The `PROCESS` block contains a loop that iterates over each computer name in the `$ComputerName` array. For each computer name, the `Invoke-Command` cmdlet is used to run a script block on the remote computer. The script block retrieves the time zone of the remote computer using the `Get-TimeZone` cmdlet.

To improve the readability of the code, the `BEGIN` block could be removed since it is empty. Additionally, the `PROCESS` block could be indented to make it more clear that it is a loop. Finally, the `HelpUri` parameter could be updated to point to more detailed documentation, and the `HelpMessage` parameter could be updated to provide more specific guidance on how to use the parameter.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use the `Set-ServerTimeZone` function:

Example 1: Set the time zone of a single remote computer

```
Set-ServerTimeZone -ComputerName "RemoteComputer01"
```

This command sets the time zone of the remote computer "RemoteComputer01" to "GMT Standard Time".

Example 2: Set the time zone of multiple remote computers

```
Set-ServerTimeZone -ComputerName "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
```

This command sets the time zone of the remote computers "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03" to "GMT Standard Time".

Example 3: Set the time zone of remote computers using pipeline input

```
"RemoteComputer01", "RemoteComputer02", "RemoteComputer03" | Set-ServerTimeZone
```

This command sets the time zone of the remote computers "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03" to "GMT Standard Time" using pipeline input.

I hope these examples help you understand how to use the `Set-ServerTimeZone` function!

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use the `Get-ServerTimeZone` function:

Example 1: Get the time zone of a single remote computer

```
Get-ServerTimeZone -ComputerName "RemoteComputer01"
```

This command retrieves the time zone of the remote computer "RemoteComputer01".

Example 2: Get the time zone of multiple remote computers

```
Get-ServerTimeZone -ComputerName "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
```

This command retrieves the time zone of the remote computers "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03".

Example 3: Get the time zone of remote computers using pipeline input

```
"RemoteComputer01", "RemoteComputer02", "RemoteComputer03" | Get-ServerTimeZone
```

This command retrieves the time zone of the remote computers "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03" using pipeline input.

I hope these examples help you understand how to use the `Get-ServerTimeZone` function!

---

#### Script

```powershell
function Set-ServerTimeZone {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            Invoke-Command -ComputerName $Computer -ScriptBlock {
                Set-TimeZone -Id "GMT Standard Time"
            }
        }
    }
}


function Get-ServerTimeZone {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            Invoke-Command -ComputerName $Computer -ScriptBlock {
                Get-TimeZone
            }
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Blank-Page.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Blank-Page.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
