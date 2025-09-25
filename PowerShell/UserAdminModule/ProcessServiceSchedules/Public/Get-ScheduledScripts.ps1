<#
.SYNOPSIS
    Retrieves scheduled scripts from the local or remote machine.

.DESCRIPTION
    The Get-ScheduledScripts function retrieves all scheduled tasks on the local or remote machine that execute PowerShell scripts.

.PARAMETER TaskName
    Filters the scheduled tasks by name. Accepts pipeline input.

.PARAMETER TaskPath
    Filters the scheduled tasks by path. Accepts pipeline input.

.PARAMETER ComputerName
    Specifies the remote computer(s) to retrieve the scheduled tasks from. If not specified, it defaults to the local computer. Accepts pipeline input.

.PARAMETER Credential
    Specifies the user account to use for the remote connection. Accepts pipeline input.

.EXAMPLE
    Get-ScheduledScripts

    Retrieves all scheduled scripts on the local machine.

.EXAMPLE
    Get-ScheduledScripts -TaskName "MyTask"

    Retrieves scheduled scripts with the name "MyTask".

.EXAMPLE
    Get-ScheduledScripts -TaskPath "\MyTasks\"

    Retrieves scheduled scripts under the specified task path.

.EXAMPLE
    Get-ScheduledScripts -ComputerName "RemotePC"

    Retrieves all scheduled scripts from the remote computer "RemotePC".

.EXAMPLE
    Get-ScheduledScripts -ComputerName "RemotePC" -Credential (Get-Credential)

    Retrieves all scheduled scripts from the remote computer "RemotePC" using the specified credentials.

.EXAMPLE
    "RemotePC1","RemotePC2" | Get-ScheduledScripts -Verbose

    Retrieves all scheduled scripts from the remote computers "RemotePC1" and "RemotePC2" with verbose output.

.EXAMPLE
    "RemotePC1","RemotePC2" | Get-ScheduledScripts -TaskName "MyTask" -TaskPath "\MyTasks\" -Credential (Get-Credential) -Verbose

    Retrieves all scheduled scripts with the specified task name and path from the remote computers "RemotePC1" and "RemotePC2" using the specified credentials and verbose output.

.OUTPUTS
    Custom.ScheduledTask

.NOTES
    Author: Luke Leigh
    Date: [Current Date]
    Version: 2.0

.LINK
    [Link to any related documentation or resources]

#>
#requires -PSEdition Desktop
function Get-ScheduledScripts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$TaskName = '*',

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$TaskPath = '\',

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [pscredential]$Credential
    )

    process {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Processing computer: $computer"

            if ($computer -eq $env:COMPUTERNAME) {
                # Local execution
                Write-Verbose "Retrieving scheduled tasks on local computer: $computer"

                $tasks = Get-ScheduledTask

                if (-not $tasks) {
                    Write-Verbose "No scheduled tasks found."
                    continue
                }

                $filteredTasks = $tasks | Where-Object {
                    $_.TaskName -like $TaskName -and $_.TaskPath -like $TaskPath -and $_.Actions.Execute -eq 'powershell.exe'
                }

                if (-not $filteredTasks) {
                    Write-Verbose "No tasks matched the filter criteria."
                    continue
                }

                $filteredTasks | ForEach-Object {
                    $task = $_
                    $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath

                    $lastTaskResultDescription = switch ($taskInfo.LastTaskResult) {
                        0 { "The operation completed successfully." }
                        1 { "Incorrect function called or unknown error occurred." }
                        267011 { "The task is currently running." }
                        2147750687 { "The task is already running." }
                        2147750686 { "The task will be triggered by user logon." }
                        2147942402 { "The system cannot find the file specified." }
                        2147942405 { "Access is denied." }
                        2147943568 { "An internal error occurred." }
                        default { "Unknown error: $($taskInfo.LastTaskResult)" }
                    }

                    if ($taskInfo.LastRunTime -eq [datetime]::MinValue -or $taskInfo.LastRunTime -eq [datetime]"1/1/0001 12:00:00 AM") {
                        $lastTaskResultDescription = "Task has not run yet."
                    }

                    $scriptPath = $_.Actions | Where-Object { $_.Execute -eq 'powershell.exe' } | Select-Object -ExpandProperty Arguments
                    $actions = $_.Actions | Select-Object -Property Execute, Arguments
                    $triggers = $_.Triggers | Select-Object -Property StartBoundary, EndBoundary, Enabled, Frequency

                    [PSCustomObject]@{
                        PSTypeName         = 'Custom.ScheduledTask'
                        TaskName           = $task.TaskName
                        TaskPath           = $task.TaskPath
                        State              = $task.State
                        LastRunTime        = if ($taskInfo.LastRunTime -ne [datetime]::MinValue -and $taskInfo.LastRunTime -ne [datetime]"1/1/0001 12:00:00 AM") { $taskInfo.LastRunTime } else { "Never" }
                        NextRunTime        = $taskInfo.NextRunTime
                        LastTaskResult     = $lastTaskResultDescription
                        NumberOfMissedRuns = $taskInfo.NumberOfMissedRuns
                        ScriptPath         = $scriptPath
                        Actions            = $actions
                        Triggers           = $triggers
                        PSComputerName     = $computer
                    }
                }
            }
            else {
                # Remote execution
                Write-Verbose "Retrieving scheduled tasks on remote computer: $computer"

                $scriptBlock = {
                    param (
                        $TaskName,
                        $TaskPath,
                        $ComputerName
                    )

                    function Get-ScheduledScriptsInternal {
                        param (
                            [Parameter(Mandatory = $false)]
                            [string]$TaskName = '*',

                            [Parameter(Mandatory = $false)]
                            [string]$TaskPath = '\',

                            [Parameter(Mandatory = $false)]
                            [string]$ComputerName
                        )

                        $tasks = Get-ScheduledTask

                        if (-not $tasks) {
                            Write-Verbose "No scheduled tasks found."
                            return
                        }

                        $filteredTasks = $tasks | Where-Object {
                            $_.TaskName -like $TaskName -and $_.TaskPath -like $TaskPath -and $_.Actions.Execute -eq 'powershell.exe'
                        }

                        if (-not $filteredTasks) {
                            Write-Verbose "No tasks matched the filter criteria."
                            return
                        }

                        $filteredTasks | ForEach-Object {
                            $task = $_
                            $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath

                            $lastTaskResultDescription = switch ($taskInfo.LastTaskResult) {
                                0 { "The operation completed successfully." }
                                1 { "Incorrect function called or unknown error occurred." }
                                267011 { "The task is currently running." }
                                2147750687 { "The task is already running." }
                                2147750686 { "The task will be triggered by user logon." }
                                2147942402 { "The system cannot find the file specified." }
                                2147942405 { "Access is denied." }
                                2147943568 { "An internal error occurred." }
                                default { "Unknown error: $($taskInfo.LastTaskResult)" }
                            }

                            if ($taskInfo.LastRunTime -eq [datetime]::MinValue -or $taskInfo.LastRunTime -eq [datetime]"1/1/0001 12:00:00 AM") {
                                $lastTaskResultDescription = "Task has not run yet."
                            }

                            $scriptPath = $_.Actions | Where-Object { $_.Execute -eq 'powershell.exe' } | Select-Object -ExpandProperty Arguments
                            $actions = $_.Actions | Select-Object -Property Execute, Arguments
                            $triggers = $_.Triggers | Select-Object -Property StartBoundary, EndBoundary, Enabled, Frequency

                            [PSCustomObject]@{
                                PSTypeName         = 'Custom.ScheduledTask'
                                TaskName           = $task.TaskName
                                TaskPath           = $task.TaskPath
                                State              = $task.State
                                LastRunTime        = if ($taskInfo.LastRunTime -ne [datetime]::MinValue -and $taskInfo.LastRunTime -ne [datetime]"1/1/0001 12:00:00 AM") { $taskInfo.LastRunTime } else { "Never" }
                                NextRunTime        = $taskInfo.NextRunTime
                                LastTaskResult     = $lastTaskResultDescription
                                NumberOfMissedRuns = $taskInfo.NumberOfMissedRuns
                                ScriptPath         = $scriptPath
                                Actions            = $actions
                                Triggers           = $triggers
                                PSComputerName     = $ComputerName
                            }
                        }
                    }

                    Get-ScheduledScriptsInternal -TaskName $TaskName -TaskPath $TaskPath -ComputerName $ComputerName
                }

                $invokeCommandParams = @{
                    ComputerName = $computer
                    ScriptBlock  = $scriptBlock
                    ArgumentList = @($TaskName, $TaskPath, $computer)
                }

                if ($Credential) {
                    $invokeCommandParams.Credential = $Credential
                }

                try {
                    $results = Invoke-Command @invokeCommandParams
                    $results | ForEach-Object {
                        $_
                    }
                }
                catch {
                    Write-Error "An error occurred on {$computer}: $_"
                }
            }
        }
    }
}

# Update format data to include the custom view
Update-FormatData -PrependPath "$PSScriptRoot\ScheduledTaskView.format.ps1xml"

# Example run with verbose output
# Get-ScheduledScripts -ComputerName "RemotePC" -Verbose
