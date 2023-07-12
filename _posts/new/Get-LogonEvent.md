---
layout: post
title: Get-LogonEvent.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Get-LogonEvent.ps1 and it retrieves logon events from the Microsoft-Windows-Winlogon provider on one or more remote computers. The script takes two parameters: ComputerName and Number. ComputerName is a mandatory parameter that specifies the name of the remote computer(s) to search for logon events. Number is an optional parameter that specifies the number of historical records to return.

The script begins by defining the two parameters and then proceeds to define the begin, process, and end blocks. The begin block is empty, the process block contains the main logic of the script, and the end block is also empty.

The process block first checks if the ShouldProcess method of the PSCmdlet object returns true. If it does, the script proceeds to loop through each computer specified in the ComputerName parameter. For each computer, the script uses the Get-WinEvent cmdlet to retrieve logon events from the Microsoft-Windows-Winlogon provider. The MaxEvents parameter of Get-WinEvent is set to the value of the Number parameter, if it was specified.

The script then loops through each log retrieved by Get-WinEvent and checks its instanceid property. If the instanceid is 7001, the log is a logon event. If the instanceid is 7002, the log is a logoff event. If the instanceid is neither 7001 nor 7002, the script skips to the next log.

For each log that is a logon or logoff event, the script creates a new PSObject with three properties: Time, Event, and User. Time is set to the TimeWritten property of the log. Event is set to either "Logon" or "Logoff", depending on the instanceid of the log. User is set to the user who performed the logon or logoff event, using the SecurityIdentifier and NTAccount classes.

Finally, the script outputs the results of the search for each computer to the console.

Possible ways to improve the code with respect to readability and performance include:

- Adding comments to explain the purpose of each block of code and each variable.
- Using the -FilterHashtable parameter of Get-WinEvent instead of the -ProviderName parameter to filter events by provider and event ID.
- Using the -Credential parameter of Get-WinEvent to specify the credentials to use when connecting to the remote computer(s).
- Using the -AsHashtable parameter of New-Object to create the PSObject instead of using the -Property parameter.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are some examples of how to use the Get-LogonEvent.ps1 script:

Example 1: Retrieve logon events from a single remote computer

```
.\Get-LogonEvent.ps1 -ComputerName "RemoteComputer1"
```

This command will retrieve all logon events from the Microsoft-Windows-Winlogon provider on the "RemoteComputer1" remote computer.

Example 2: Retrieve logon events from multiple remote computers

```
.\Get-LogonEvent.ps1 -ComputerName "RemoteComputer1", "RemoteComputer2"
```

This command will retrieve all logon events from the Microsoft-Windows-Winlogon provider on the "RemoteComputer1" and "RemoteComputer2" remote computers.

Example 3: Retrieve the last 10 logon events from a single remote computer

```
.\Get-LogonEvent.ps1 -ComputerName "RemoteComputer1" -Number 10
```

This command will retrieve the last 10 logon events from the Microsoft-Windows-Winlogon provider on the "RemoteComputer1" remote computer.

Example 4: Retrieve logon events from a remote computer using alternate credentials

```
$cred = Get-Credential
.\Get-LogonEvent.ps1 -ComputerName "RemoteComputer1" -Credential $cred
```

This command will prompt you for alternate credentials to use when connecting to the "RemoteComputer1" remote computer. It will then retrieve all logon events from the Microsoft-Windows-Winlogon provider on that computer using the specified credentials.

I hope these examples help you get started with using the Get-LogonEvent.ps1 script!

---

#### Script

```powershell
function Get-LogonEvent {
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
        $ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the number of historical records to return.')]
        [int]$Number

    )

    begin {}

    process {

        if ($PSCmdlet.ShouldProcess("$Computer", "Searching for logon events on...")) {

            foreach ($Computer in $ComputerName) {

                $logs = Get-WinEvent -ComputerName $Computer  -ProviderName Microsoft-Windows-Winlogon -MaxEvents $Number
                $results = @(); foreach ($log in $logs) {
                    if ($log.instanceid -eq 7001) {
                        $type = "Logon"
                    }
                    Elseif ($log.instanceid -eq 7002) {
                        $type = "Logoff"
                    }
                    Else {
                        Continue
                    }
                    $results += New-Object PSObject -Property @{
                        Time    = $log.TimeWritten;
                        "Event" = $type;
                        User    = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
                    }
                }

                Write-Output $results

            }

        }
    }

    end {}

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-LogonEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LogonEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
