<#
.SYNOPSIS
    Retrieves scheduled scripts from the local machine.

.DESCRIPTION
    The Get-AllScheduledScripts function retrieves all scheduled tasks on the local machine that execute PowerShell scripts.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Get-AllScheduledScripts

    Retrieves all scheduled scripts on the local machine.

.OUTPUTS
    System.Management.Automation.TaskScheduler.ScheduledTask[]

    This function returns an array of ScheduledTask objects representing the scheduled scripts.

.NOTES
    Author: Luke Leigh
    Date: [Current Date]
    Version: 1.0

.LINK
    [Link to any related documentation or resources]

#>
function Get-AllScheduledScripts {
    Get-ScheduledTask | Where-Object { $_.Actions.Execute -eq 'powershell.exe' } | ForEach-Object {
        $task = $_
        $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath

        $lastTaskResultDescription = switch ($taskInfo.LastTaskResult) {
            0 { "The operation completed successfully." }
            2147750687 { "The task is already running." }
            2147750686 { "The task will be triggered by user logon." }
            2147942402 { "The system cannot find the file specified." }
            2147942405 { "Access is denied." }
            default { "Unknown error." }
        }

        if ($taskInfo.LastTaskResult -eq 267011 -and $taskInfo.LastRunTime -eq "30/11/1999 00:00:00") {
            $lastTaskResultDescription = "New Task - Task Schedule not yet started."
        }
        elseif ($taskInfo.LastTaskResult -eq 267011) {
            $lastTaskResultDescription = "The task is currently running."
        }

        $output = New-Object PSObject
        $output | Add-Member -MemberType NoteProperty -Name "TaskName" -Value $task.TaskName
        $output | Add-Member -MemberType NoteProperty -Name "TaskPath" -Value $task.TaskPath
        $output | Add-Member -MemberType NoteProperty -Name "State" -Value $task.State
        $output | Add-Member -MemberType NoteProperty -Name "LastRunTime" -Value $taskInfo.LastRunTime
        $output | Add-Member -MemberType NoteProperty -Name "NextRunTime" -Value $taskInfo.NextRunTime
        $output | Add-Member -MemberType NoteProperty -Name "LastTaskResult" -Value $lastTaskResultDescription
        $output | Add-Member -MemberType NoteProperty -Name "NumberOfMissedRuns" -Value $taskInfo.NumberOfMissedRuns

        $output
    }
}
