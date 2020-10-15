#Requires -RunAsAdministrator

<#
Establish Secure Remote Session
Create Script
- Create new directory - SoloScripts
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
    Source    = 'Solopress'
    EntryType = 'Information'
    EventId   = '4668', '4666', '6006'
    Message   = 'The daily PC Restart has taken place in order to update starter and leaver changes', 'The daily PC Restart folder/files have been created.', 'The daily PC Restart Scheduled task has been created.'
}

New-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source
Set-Location "C:\"
New-Item -Path "C:" -Name SoloScripts -ItemType Directory
New-Item -Path "C:\SoloScripts" -Name ScheduledRestart.ps1 -ItemType File

$Content = { $params = [PSCustomObject]@{
        LogName   = 'Application'
        Source    = 'Solopress'
        EntryType = 'Information'
        EventId   = '4668', '4666', '6006'
        Message   = 'The daily PC Restart folder/files have been created.', 'The daily PC Restart Scheduled task has been created.', 'The daily PC Restart has taken place in order to update starter and leaver changes'
    }
    Write-EventLog -LogName $params.LogName -Source $params.Source   -EntryType $params.EntryType -EventId $params.EventId[2] -Message $params.Message[2]
    Restart-Computer -Force
}

Set-Content -Path "C:\SoloScripts\ScheduledRestart.ps1" -Value $Content
Write-EventLog -LogName $NewEvent.LogName -Source $NewEvent.Source -EntryType $NewEvent.EntryType -EventId $NewEvent.EventId[2] -Message $NewEvent.Message[0]

$taskName = 'Solo Restart'
$scriptPath = "C:\SoloScripts\ScheduledRestart.ps1"

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

