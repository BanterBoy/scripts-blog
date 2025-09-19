<#
.SYNOPSIS
Starts a scheduled task by its name.

.DESCRIPTION
The Start-ScheduledScript function starts a scheduled task by its name. It checks if the task exists and then starts it.

.PARAMETER TaskName
The name of the scheduled task to start.

.EXAMPLE
Start-ScheduledScript -TaskName "MyTask"

This example starts the scheduled task named "MyTask".

#>
function Start-ScheduledScript {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TaskName
    )

    if ($PSCmdlet.ShouldProcess("$TaskName", "Start scheduled task")) {
        try {
            if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
                Start-ScheduledTask -TaskName $TaskName
            }
            else {
                Write-Error "No scheduled task found with the name $TaskName"
            }
        }
        catch {
            Write-Error "Failed to start scheduled task: $_"
        }
    }
}