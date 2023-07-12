---
layout: post
title: SomeScriptFile.ps1
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

**_@GitHub Copilot_** - This PowerShell script creates a scheduled task to restart a computer daily at three different times: midday, quarter past midday, and half past midday. The script begins by defining a function called `Restart-ComputerDaily` that restarts the computer and logs an event to the Windows event log. The function is then called to restart the computer immediately.

Next, the script creates a PowerShell script file called `ScheduledRestart.ps1` in the directory `C:\DIRECTORYNAME\`. The contents of the file are set to the value of the `$Content` variable, which is not defined in the provided code snippet. The script then logs an event to the Windows event log to indicate that the scheduled task has been created.

The script then enters a `do` loop that prompts the user to make a selection. If the user enters `1`, `2`, or `3`, the script creates a scheduled task to restart the computer at the corresponding time. The task is created using the `Register-ScheduledTask` cmdlet, which takes a task name, a trigger, and an action. The task is set to run the `ScheduledRestart.ps1` script file using the `Powershell.exe` executable. The task is set to run as the `SYSTEM` user with the highest possible privileges. The task is also given a description and is forced to run.

If the user enters `q`, the script exits the `do` loop and terminates. If the user enters any other value, the script pauses and prompts the user to make another selection.

To improve the readability of the code, the script could benefit from more descriptive variable names. Additionally, the script could be refactored to use functions to reduce code duplication. To improve performance, the script could be optimized to use more efficient data structures and algorithms.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are some examples of how you could use this PowerShell script:

1. Restart the computer daily at midday:
   - Run the script and enter `1` at the prompt.
2. Restart the computer daily at quarter past midday:
   - Run the script and enter `2` at the prompt.
3. Restart the computer daily at half past midday:
   - Run the script and enter `3` at the prompt.
4. Create a custom scheduled task to restart the computer at a specific time:
   - Modify the script to create a custom trigger using the `New-ScheduledTaskTrigger` cmdlet.
   - Modify the script to create a custom action using the `New-ScheduledTaskAction` cmdlet.
   - Run the script and enter `4` at the prompt.
5. Exit the script:
   - Run the script and enter `q` at the prompt.

---

#### Script

```powershell
#Requires -RunAsAdministrator

<#
Establish Secure Remote Session
Create Script
- Create new directory - DIRECTORYNAME
- Create new file - ScheduledRestart.ps1
- Populate contents of new file with reboot script
Write Event Log message confirming creation of files
Schedule Task to run script at selected interval
#>

$Title = 'Select Time'
Write-Output "================ $Title ================"
Write-Output "1: Press '1' for Mid-day."
Write-Output "2: Press '2' for Quarter Past."
Write-Output "3: Press '3' for Half Past."
Write-Output "Q: Press 'Q' to quit."

$NewEvent = [PSCustomObject]@{
    LogName   = 'Application'
    Source    = 'YourSourceName'
    EntryType = 'Information'
    EventId   = '4668', '4666', '6006'
    Message   = 'The daily PC Restart has taken place in order to update starter and leaver changes', 'The daily PC Restart folder/files have been created.', 'The daily PC Restart Scheduled task has been created.'
}

New-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source
Set-Location "C:\"
New-Item -Path "C:" -Name DIRECTORYNAME -ItemType Directory
New-Item -Path "C:\DIRECTORYNAME" -Name ScheduledRestart.ps1 -ItemType File

$Content = { $params = [PSCustomObject]@{
        LogName   = 'Application'
        Source    = 'YourSourceName'
        EntryType = 'Information'
        EventId   = '4668', '4666', '6006'
        Message   = 'The daily PC Restart folder/files have been created.', 'The daily PC Restart Scheduled task has been created.', 'The daily PC Restart has taken place in order to update starter and leaver changes'
    }
    Write-EventLog -LogName $params.LogName -Source $params.Source   -EntryType $params.EntryType -EventId $params.EventId[2] -Message $params.Message[2]
    Restart-Computer -Force
}

Set-Content -Path "C:\DIRECTORYNAME\ScheduledRestart.ps1" -Value $Content
Write-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source -EntryType $NewEvent.EntryType -EventId $NewEvent.EventId[2] -Message $NewEvent.Message[0]

$taskName = 'ScheduledRestart'
$scriptPath = "C:\DIRECTORYNAME\ScheduledRestart.ps1"

do {
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' {
            if ($selection -eq '1') {
                $Midday = (Get-Date -Hour 12 -Minute 00 -Second 0 -Millisecond 0).ToShortTimeString()
                $Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-executionpolicy bypass -noprofile -file $scriptPath"
                $Trigger = New-ScheduledTaskTrigger -Daily -At $Midday
                Register-ScheduledTask -TaskName $taskName -Trigger $Trigger -Action $Action -user SYSTEM -Description "A daily PC Restart is required in order to to update starter and leaver changes within the filemaker application." -RunLevel Highest -Force
                Write-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source[1] -EntryType $NewEvent.EntryType -EventId $NewEvent.EventId[1] -Message $NewEvent.Message[1]
                'Task has been scheduled for Mid-day'
            }
        } '2' {
            if ($selection -eq '2') {
                $QuarterPast = (Get-Date -Hour 12 -Minute 00 -Second 0 -Millisecond 0).AddMinutes(15).ToShortTimeString()
                $Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-executionpolicy bypass -noprofile -file $scriptPath"
                $Trigger = New-ScheduledTaskTrigger -Daily -At $QuarterPast
                Register-ScheduledTask -TaskName $taskName -Trigger $Trigger -Action $Action -user SYSTEM -Description "A daily PC Restart is required in order to to update starter and leaver changes within the filemaker application." -RunLevel Highest -Force
                Write-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source[1] -EntryType $NewEvent.EntryType -EventId $NewEvent.EventId[1] -Message $NewEvent.Message[1]
                'Task has been scheduled for Quarter Past'
            }
        } '3' {
            if ($selection -eq '3') {
                $HalfPast = (Get-Date -Hour 12 -Minute 00 -Second 0 -Millisecond 0).AddMinutes(30).ToShortTimeString()
                $Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-executionpolicy bypass -noprofile -file $scriptPath"
                $Trigger = New-ScheduledTaskTrigger -Daily -At $HalfPast
                Register-ScheduledTask -TaskName $taskName -Trigger $Trigger -Action $Action -user SYSTEM -Description "A daily PC Restart is required in order to to update starter and leaver changes within the filemaker application." -RunLevel Highest -Force
                Write-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source[1] -EntryType $NewEvent.EntryType -EventId $NewEvent.EventId[1] -Message $NewEvent.Message[1]
                'Task has been scheduled for Half Past'
            }
        } 'q' {
            return
        }
    }
    pause
}
until ($selection -eq 'q')
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/SomeScriptFile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=SomeScriptFile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/snippets.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Snippets
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
