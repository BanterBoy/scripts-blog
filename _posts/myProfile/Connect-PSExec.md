---
layout: post
title: Connect-PSExec.ps1
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

**_@GitHub Copilot_** - This code is a PowerShell script that establishes a remote connection to a computer using PsExec. The script takes two parameters: ComputerName and Prompt. ComputerName is a mandatory parameter that specifies the name of the computer to connect to. Prompt is an optional parameter that specifies which prompt to connect to, either PowerShell or Command.

The script begins with a parameter block that defines the two parameters. The ComputerName parameter is defined as a string array and is given an alias of 'cn'. The Prompt parameter is defined as a string array and is given a validation set of 'PowerShell' and 'Command'.

The script then defines a switch statement that checks the value of the Prompt parameter. If the value is 'PowerShell', the script uses a foreach loop to iterate through each computer specified in the ComputerName parameter and attempts to establish a PsExec PowerShell console session. If the value is 'Command', the script uses a foreach loop to iterate through each computer specified in the ComputerName parameter and attempts to establish a PsExec command prompt session. If the value is not specified, the script defaults to establishing a PsExec PowerShell console session.

The script uses the ShouldProcess method to check if the current operation should be performed. If ShouldProcess returns true, the script attempts to establish a remote connection to the specified computer using PsExec. If the connection is successful, the script launches either a PowerShell console or a command prompt on the remote computer, depending on the value of the Prompt parameter. If the connection is unsuccessful, the script writes an error message to the console.

To improve the readability of the code, the script could benefit from additional comments to explain the purpose of each section of code. Additionally, the script could be optimized for performance by using a parallel foreach loop to establish connections to multiple computers simultaneously.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how to use the `Connect-PSExec` function:

1. To connect to a single computer using the default PowerShell prompt:

```
Connect-PSExec -ComputerName COMPUTERNAME
```

2. To connect to multiple computers using the default PowerShell prompt:

```
Connect-PSExec -ComputerName COMPUTER1, COMPUTER2, COMPUTER3
```

3. To connect to a single computer using the command prompt:

```
Connect-PSExec -ComputerName COMPUTERNAME -Prompt Command
```

4. To connect to multiple computers using the command prompt:

```
Connect-PSExec -ComputerName COMPUTER1, COMPUTER2, COMPUTER3 -Prompt Command
```

Note that in each example, you would replace `COMPUTERNAME`, `COMPUTER1`, `COMPUTER2`, and `COMPUTER3` with the actual names of the computers you want to connect to.

---

#### Script

```powershell
function Connect-PSExec {
    <#
	.SYNOPSIS
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer.

	.DESCRIPTION
		Connect-PSExec - Spawn PSEXEC and launches a PSEXEC PowerShell or Command Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted in the powershell session.

	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN

	.EXAMPLE
		Connect-PSExec -ComputerName COMPUTERNAME

	.OUTPUTS
		System.String. Connect-PSExec

	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		ComputerName - You can pipe objects to this perameters.

	.LINK
		https://scripts.lukeleigh.com
		PsExec.exe
		powershell.exe
        cmd.exe
#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('cpsxc')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Select which Prompt you would like to connect to.')]
        [ValidateSet('PowerShell', 'Command')]
        [string[]]
        $Prompt
    )

    BEGIN {
    }
    PROCESS {

        switch ($Prompt) {
            'PowerShell' {
                foreach ($Computer in $ComputerName) {
                if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                                & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                            }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            'Command' {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC Command Prompt session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer cmd.exe
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
            Default {
                foreach ($Computer in $ComputerName) {
                    if ($PSCmdlet.ShouldProcess("$Computer", "Establishing PSEXEC PowerShell Console session")) {
                        try {
                            & $PSScriptRoot\PsExec.exe \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                        }
                        catch {
                            Write-Error "Unable to connect to $($Computer)"
                        }
                    }
                }
            }
        }
    }
    END {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Connect-PSExec.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

This function requires the following executable and is included in the repository:

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/psexec.exe')">
    <i class="fa fa-cloud-download-alt">
    </i>
        psexec.exe
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-PSExec.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
