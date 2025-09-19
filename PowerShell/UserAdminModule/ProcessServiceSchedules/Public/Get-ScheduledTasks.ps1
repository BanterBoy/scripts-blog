<#
.SYNOPSIS
    Retrieves scheduled tasks from one or more servers.

.DESCRIPTION
    The Get-ScheduledTasks function retrieves scheduled tasks from one or more servers. It uses the ScheduledTasks module 
    to interact with the Task Scheduler service on the specified servers. The function supports filtering tasks based on 
    their state, task name, task path, description, author, and principal.

.PARAMETER ComputerName
    Specifies the servers from which to retrieve scheduled tasks. By default, the function retrieves tasks from the local computer.

.PARAMETER State
    Specifies the state of the tasks to retrieve. The valid values are "Ready", "Disabled", and "Running". By default, all tasks are retrieved regardless of their state.

.PARAMETER TaskName
    Specifies the name of the tasks to retrieve. Supports wildcards.

.PARAMETER TaskPath
    Specifies the path of the tasks to retrieve. Supports wildcards.

.PARAMETER TaskDescription
    Specifies the description of the tasks to retrieve. Supports wildcards.

.PARAMETER Author
    Specifies the author of the tasks to retrieve. Supports wildcards.

.PARAMETER Principal
    Specifies the principal (user) of the tasks to retrieve. Supports wildcards.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1", "Server2" -State "Ready"
    Retrieves all scheduled tasks in the "Ready" state from Server1 and Server2.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -State "Disabled"
    Retrieves all scheduled tasks in the "Disabled" state from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -TaskName "*Update*"
    Retrieves all scheduled tasks with names containing "Update" from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -TaskPath "\Microsoft\Windows\*"
    Retrieves all scheduled tasks in the "\Microsoft\Windows\" path from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -Author "Microsoft Corporation"
    Retrieves all scheduled tasks authored by "Microsoft Corporation" from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -Principal "SYSTEM"
    Retrieves all scheduled tasks run as "SYSTEM" from Server1.

.NOTES
    - This function requires the ScheduledTasks module to be installed. If the module is not installed, an error message is displayed.
    - The function uses Test-Connection cmdlet to check the connectivity to each server before retrieving tasks.
    - The function returns a custom object with detailed properties for each task.
    - A custom format file (ScheduledTasks.Format.ps1xml) is used for better display of the results.

.LINK
    http://scripts.lukeleigh.com/
#>
function Get-ScheduledTasks {
    [CmdletBinding()]        
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        [Parameter(Position = 1, Mandatory = $false)]
        [ValidateSet("Ready", "Disabled", "Running")]
        [string]$State = $null,
        
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$TaskName = "*",
        
        [Parameter(Position = 3, Mandatory = $false)]
        [string]$TaskPath = "*",

        [Parameter(Position = 4, Mandatory = $false)]
        [string]$TaskDescription = "*",

        [Parameter(Position = 5, Mandatory = $false)]
        [string]$Author = "*",

        [Parameter(Position = 6, Mandatory = $false)]
        [string]$Principal = "*"
    ) 
    
    begin {
    
        Update-FormatData -PrependPath "$PSScriptRoot\ScheduledTasks.Format.ps1xml"

        $ErrorActionPreference = "Stop"
  
        try {
            Import-Module ScheduledTasks -ErrorAction Stop
        }
        catch {
            Write-Warning "Scheduled Tasks module not installed: $_"
            return
        }
    }
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $Computer"
      
            if (!(Test-Connection -ComputerName $Computer -BufferSize 16 -Count 1 -ErrorAction SilentlyContinue -Quiet)) {
                Write-Warning "Failed to connect to $Computer"
            }
            else {
                $TasksArray = @()
  
                try {
                    $Tasks = Get-ScheduledTask -CimSession $Computer | Where-Object {
                    ($_.State -eq $State -or !$State) -and
                    ($_.TaskName -like $TaskName) -and
                    ($_.TaskPath -like $TaskPath) -and
                    ($_.Description -like $TaskDescription) -and
                    ($_.Author -like $Author) -and
                    ($_.Principal.UserId -like $Principal)
                    }
                }
                catch {
                    Write-Warning "Failed to retrieve tasks from {$Computer}: $_"
                    continue
                }
 
                if ($Tasks) {
                    $Tasks | ForEach-Object {
                        $TaskInfo = Get-ScheduledTaskInfo -InputObject $_ -ErrorAction SilentlyContinue
                        $Action = $_.Actions | ForEach-Object { $_.Arguments }
                        $Triggers = $_.Triggers | ForEach-Object { $_.TriggerType }

                        $Object = [PSCustomObject]@{
                            Server      = $Computer
                            Name        = $_.TaskName
                            RunAsUser   = $_.Principal.UserId
                            State       = $_.State
                            TaskName    = $_.TaskName
                            Author      = $_.Author
                            LastRunTime = $TaskInfo.LastRunTime
                            NextRunTime = $TaskInfo.NextRunTime
                            TaskPath    = $_.TaskPath
                            Description = $_.Description
                            Action      = $Action -join ", "
                            Triggers    = $Triggers -join ", "
                        }
                        $TasksArray += $Object
                    }
                    $TasksArray
                }
                else {
                    Write-Warning "No tasks found on $Computer"
                }
            }
        }
    }

    end {
    }
}
