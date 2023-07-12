---
layout: post
title: Restart-ProjectComputer.ps1
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

**_@GitHub Copilot_** - This is a PowerShell script that contains a function called `Restart-ProjectComputer`. The function takes two parameters, `$ComputerName` and `$Credential`. The `$ComputerName` parameter is a mandatory parameter that takes the name of the computer that the user wants to connect to. The `$Credential` parameter is an optional parameter that takes a PSCredential object, which is used to authenticate the user on the remote computer.

The function begins with a `begin` block, which is empty. The `process` block is where the main logic of the function resides. It first checks if the `ShouldProcess` method returns true for the `$ComputerName` parameter. If it does, it checks if the `$Credential` parameter is not null. If it is not null, it restarts the remote computer using the `Restart-Computer` cmdlet with the `-Credential` and `-Force` parameters. It then enters a loop that continuously pings the remote computer using the `Test-Connection` cmdlet until the ping is successful. If the `$Credential` parameter is null, it restarts the remote computer using the `Restart-Computer` cmdlet with the `-Force` parameter. It then enters the same loop that continuously pings the remote computer using the `Test-Connection` cmdlet until the ping is successful.

The function ends with an empty `end` block.

Possible ways to improve the code with respect to readability and performance include adding comments to explain the purpose of the code, using more descriptive variable names, and optimizing the loop that continuously pings the remote computer. For example, instead of continuously pinging the remote computer until the ping is successful, the loop could be modified to ping the remote computer a certain number of times before exiting.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are some examples of how to use the `Restart-ProjectComputer` function:

Example 1: Restart a remote computer without credentials

```powershell
Restart-ProjectComputer -ComputerName "RemoteComputer01"
```

This example restarts a remote computer named "RemoteComputer01" without using any credentials. The function will continuously ping the remote computer until it responds successfully.

Example 2: Restart a remote computer with credentials

```powershell
$Credential = Get-Credential
Restart-ProjectComputer -ComputerName "RemoteComputer01" -Credential $Credential
```

This example restarts a remote computer named "RemoteComputer01" using the credentials provided by the user. The function will continuously ping the remote computer until it responds successfully.

Example 3: Restart multiple remote computers

```powershell
$Computers = "RemoteComputer01", "RemoteComputer02", "RemoteComputer03"
foreach ($Computer in $Computers) {
    Restart-ProjectComputer -ComputerName $Computer
}
```

This example restarts multiple remote computers named "RemoteComputer01", "RemoteComputer02", and "RemoteComputer03". The function will continuously ping each remote computer until it responds successfully.

---

#### Script

```powershell
function Restart-ProjectComputer {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('rpc')]
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
        [string]
        $ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential

    )

    begin {

    }

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Process restart request")) {

            if ($Credential) {
                Restart-Computer -ComputerName $ComputerName -Credential $Credential -Force
                do {
                    Test-Connection -ComputerName $ComputerName Continuous -TimeoutSeconds 5 | Select-Object -Property Ping, Source, Destination, Address, Status
                } while (
                    $_.Status -ne "Success"
                )
            }
            else {
                Restart-Computer -ComputerName $ComputerName -Force
                do {
                    Test-Connection -ComputerName $ComputerName Continuous -TimeoutSeconds 5 | Select-Object -Property Ping, Source, Destination, Address, Status
                } while (
                    $_.Status -ne "Success"
                )
            }
        }
    }

    end {

    }

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Restart-ProjectComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Restart-ProjectComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
