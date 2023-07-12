---
layout: post
title: Stop-FailedServiceScript.ps1
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
# Create a secure string for the password
$Username = Read-Host "Enter Username"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Server Variables
$Server = Read-Host "Enter Server Name"
$ProcessName = Read-Host "Enter Process Name (e.g. something.exe)"

# Create Remote Session
Write-Warning -Message "Connecting to Server $Server" -WarningAction Continue
Enter-PSSession -ComputerName $Server -Credential $Credentials
Wait-Event -Timeout 5
Write-Warning -Message "You are PSRemoting to $Server" -WarningAction Continue

# Stop a service that is stuck when stopping
$Process = Get-WmiObject -Class Win32_Process -ComputerName $Server -Filter "name='$ProcessName'"
IF ($null -ne $Process) {
        $returnval = $process.terminate()
        $processid = $process.handle
        if ($returnval.returnvalue -eq 0) {
                Write-Warning -Message "The process $ProcessName `($processid`) terminated successfully on Server $Server" -WarningAction Continue
        }
        else {
                Write-Warning -Message "The process $ProcessName `($processid`) termination has some problems on Server $Server" -WarningAction Continue
        }
}
Else {
        Write-Warning -Message "Process Not Running On Server $Server" -WarningAction Continue
}

<#
$process = Get-Process -Name Kodi | Select-Object -Property MainModule -ExpandProperty MainModule
$process.ModuleName.terminate()
#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/Stop-FailedServiceScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-FailedServiceScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
