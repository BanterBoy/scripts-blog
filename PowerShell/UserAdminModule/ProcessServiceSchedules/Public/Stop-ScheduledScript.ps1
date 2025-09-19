
<#
.SYNOPSIS
    Stops a scheduled task by its name.

.DESCRIPTION
    The Stop-ScheduledScript function stops a scheduled task by its name. It first checks if the task exists using the Get-ScheduledTask cmdlet, and if found, stops the task using the Stop-ScheduledTask cmdlet.

.PARAMETER TaskName
    Specifies the name of the scheduled task to stop.

.EXAMPLE
    Stop-ScheduledScript -TaskName "MyTask"
    Stops the scheduled task named "MyTask".

.INPUTS
    System.String

.OUTPUTS
    None

.NOTES
    Author: Your Name
    Date:   Current Date

#>
function Stop-ScheduledScript {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TaskName
    )

    if ($PSCmdlet.ShouldProcess("$TaskName", "Stop scheduled task")) {
        try {
            if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
                Stop-ScheduledTask -TaskName $TaskName
            }
            else {
                Write-Error "No scheduled task found with the name $TaskName"
            }
        }
        catch {
            Write-Error "Failed to stop scheduled task: $_"
        }
    }
}
