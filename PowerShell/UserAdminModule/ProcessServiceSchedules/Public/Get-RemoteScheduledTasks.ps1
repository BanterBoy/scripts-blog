<#
.SYNOPSIS
Export a list of scheduled tasks from a remote computer and their properties.

.DESCRIPTION
The Get-RemoteScheduledTasks function retrieves a list of scheduled tasks from a remote computer and returns their properties. It uses the Get-ScheduledTask cmdlet to get the list of tasks and the Get-ScheduledTaskInfo cmdlet to retrieve additional information about each task.

.PARAMETER ComputerName
The name of the remote computer from which to retrieve the scheduled tasks.

.EXAMPLE
Get-RemoteScheduledTasks -ComputerName "RemoteComputer01"
This example retrieves the scheduled tasks from the remote computer named "RemoteComputer01" and displays their properties.

.INPUTS
System.String

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>

function Get-RemoteScheduledTasks {
    [CmdletBinding( DefaultParameterSetName = 'ComputerName', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    Param(
        [Parameter( Mandatory = $true, Position = 0, ParameterSetName = 'ComputerName' )]
        [string]$ComputerName
    )
    Process {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            foreach ($Computer in $ComputerName) {
                $ScheduledTasks = Get-ScheduledTask -CimSession $Computer -TaskName *
                foreach ($ScheduledTask in $ScheduledTasks) {
                    $ScheduledTaskInfo = Get-ScheduledTaskInfo -CimSession $Computer -TaskName $ScheduledTask.TaskName
                    $ScheduledTaskInfo | Select-Object -Property TaskName, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns, TaskPath, TaskState, PSComputerName
                }
            }
        }
    }
}
