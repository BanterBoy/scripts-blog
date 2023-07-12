---
layout: post
title: Get-Uptime.ps1
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
function Get-Uptime {
        <#
        .SYNOPSIS
            Get-Uptime will extract the current system uptime from the computer entered.

        .DESCRIPTION
            A detailed description of the Get-Uptime function.

        .PARAMETER ComputerName
            Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.

        .PARAMETER Days
            A description of the Days parameter.

        .PARAMETER Since
            A description of the Since parameter.

        .EXAMPLE
            Get-Uptime

        .EXAMPLE
            Get-ADComputer -Filter { Name -like '*' } -Properties * | Where-Object -Property Name -NotLike '*AGAMAR*' | ForEach-Object -Process { Get-Uptime -ComputerName $_.Name } | Format-Table -AutoSize -Property Name,Days,Hours,Minutes

        .EXAMPLE
            'HOTH','KAMINO','DANTOOINE' | ForEach-Object -Process { Get-Uptime -ComputerName $_ } | Format-Table -AutoSize -Property Name,Days,Hours,Minutes

        .OUTPUTS
            string

        .NOTES
            Additional information about the function.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsPaging = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        # Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME
    )
    begin {
    }
    process {
        if ($PSCmdlet.ShouldProcess("$Computer", "Retrieving uptime")) {
        foreach ($Computer in $ComputerName) {
                $Date = (Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem).LastBootUpTime
                $TimeSpan = New-Timespan -Start $Date
                try {
                    $properties = @{
                        'Name'              = $Computer
                        'Date'              = $Date
                        'Days'              = $TimeSpan.Days
                        'Hours'             = $TimeSpan.Hours
                        'Minutes'           = $TimeSpan.Minutes
                        'Seconds'           = $TimeSpan.Seconds
                        'Milliseconds'      = $TimeSpan.Milliseconds
                        'Ticks'             = $TimeSpan.Ticks
                        'TotalDays'         = $TimeSpan.TotalDays
                        'TotalHours'        = $TimeSpan.TotalHours
                        'TotalMinutes'      = $TimeSpan.TotalMinutes
                        'TotalSeconds'      = $TimeSpan.TotalSeconds
                        'TotalMilliseconds' = $TimeSpan.TotalMilliseconds
                    }
                    $obj = New-Object PSObject -Property $properties
                    Write-Output $obj
                }
                catch {
                    Write-Error -Message $_
                }
            }
        }
    }
    end {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-Uptime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Uptime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
