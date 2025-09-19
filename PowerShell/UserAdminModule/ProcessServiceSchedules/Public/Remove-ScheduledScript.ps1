<#
.SYNOPSIS
Removes a scheduled task from specified computers.

.DESCRIPTION
The Remove-ScheduledScript function removes a scheduled task from specified computers. It checks if the task exists and unregisters it if found. If the task is not found, it displays an error message.

.PARAMETER TaskName
The name of the scheduled task to be removed.

.PARAMETER ComputerName
The names of the computers from which the scheduled task should be removed. The default value is the local computer.

.PARAMETER Credential
Specifies a user account that has permission to perform the operation on the remote computers. If not specified, the current user's credentials are used.

.EXAMPLE
Remove-ScheduledScript -TaskName "MyTask" -ComputerName "RemoteComputer1", "RemoteComputer2"

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

.EXAMPLE
"RemoteComputer1", "RemoteComputer2" | Remove-ScheduledScript -TaskName "MyTask"

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

.INPUTS
System.String.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Today's Date

.LINK
https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/unregister-scheduledtask?view=windowsserver2019-ps
#>
function Remove-ScheduledScript {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TaskName,
        
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {
        foreach ($computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$TaskName on $computer", "Remove scheduled task")) {
                $scriptBlock = {
                    param ($TaskName)
                    try {
                        if (Get-ScheduledTask -TaskName $TaskName -TaskPath \ -ErrorAction SilentlyContinue) {
                            Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false
                        }
                        else {
                            Write-Error "No scheduled task found with the name $TaskName"
                        }
                    }
                    catch {
                        Write-Error "Failed to remove scheduled task: $_"
                    }
                }

                if ($computer -eq $env:COMPUTERNAME) {
                    & $scriptBlock -TaskName $TaskName
                }
                else {
                    $sessionParams = @{
                        ComputerName = $computer
                    }
                    if ($Credential) {
                        $sessionParams.Credential = $Credential
                    }
                    $session = New-PSSession @sessionParams
                    Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $TaskName
                    Remove-PSSession -Session $session
                }
            }
        }
    }
}
