<#
.SYNOPSIS
    Gets the status of specified processes.

.DESCRIPTION
    The Get-ProcessStatus function retrieves the status of specified processes on a local or remote computer.
    It provides details such as process ID, name, CPU usage, memory usage, start time, total processor time, number of threads, handles, status, and user.

.PARAMETER ProcessName
    The name(s) of the processes to retrieve the status for. Accepts pipeline input.

.PARAMETER ComputerName
    The name(s) of the remote computer(s) to query. Accepts pipeline input. If not specified, the local computer is used.

.PARAMETER Credential
    The credentials to use for the remote session. If not specified, the current user's credentials will be used.

.EXAMPLE
    Get-ProcessStatus -ProcessName "notepad", "explorer"
    Retrieves the status of Notepad and Explorer processes on the local computer.

.EXAMPLE
    Get-ProcessStatus -ProcessName "notepad" -ComputerName "Server01"
    Retrieves the status of the Notepad process on the remote computer "Server01".

.EXAMPLE
    Get-ProcessStatus -ProcessName "chrome"
    Retrieves the status of Chrome processes on the local computer, including the user running each process.

.EXAMPLE
    "chrome", "notepad" | Get-ProcessStatus
    Retrieves the status of Chrome and Notepad processes on the local computer, including the user running each process.

.EXAMPLE
    "DEFIANT" | Get-ProcessStatus -ProcessName "1Password-BrowserSupport"
    Retrieves the status of the "1Password-BrowserSupport" process on the remote computer "DEFIANT".

.NOTES
    Author: Your Name
    Date: Current Date
#>

function Get-ProcessStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ProcessName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        # Initialize arrays to store the computer and process names for later processing
        $allComputerNames = @()
        $allProcessNames = @()
        Write-Verbose "Starting Get-ProcessStatus function"

        # Define the Get-ProcessOwner function in the current scope
        function Get-ProcessOwner {
            param (
                [Parameter(Mandatory = $true)]
                [System.Diagnostics.Process]$Process
            )
            try {
                $query = "SELECT * FROM Win32_Process WHERE ProcessId = " + $Process.Id
                $processOwner = Get-WmiObject -Query $query
                $ownerInfo = $processOwner.GetOwner()
                return $ownerInfo.User
            }
            catch {
                Write-Verbose "Failed to get process owner for PID $($Process.Id)"
                return "N/A"
            }
        }
    }

    process {
        Write-Verbose "Processing ProcessName: $ProcessName and ComputerName: $ComputerName"
        
        # Collect process names
        $allProcessNames += $ProcessName

        # Collect computer names
        if ($PSBoundParameters.ContainsKey('ComputerName')) {
            $allComputerNames += $ComputerName
        }
        else {
            $allComputerNames += $env:COMPUTERNAME
        }
    }

    end {
        # Ensure we have unique lists of computer names and process names
        $allComputerNames = $allComputerNames | Select-Object -Unique
        $allProcessNames = $allProcessNames | Select-Object -Unique

        foreach ($computer in $allComputerNames) {
            Write-Verbose "Querying computer: $computer"

            if ($computer -ne $env:COMPUTERNAME) {
                Write-Verbose "Querying remote computer: $computer"

                $scriptBlock = {
                    param ($ProcessName)
                    function Get-ProcessOwner {
                        param (
                            [Parameter(Mandatory = $true)]
                            [System.Diagnostics.Process]$Process
                        )
                        try {
                            $query = "SELECT * FROM Win32_Process WHERE ProcessId = " + $Process.Id
                            $processOwner = Get-WmiObject -Query $query
                            $ownerInfo = $processOwner.GetOwner()
                            return $ownerInfo.User
                        }
                        catch {
                            return "N/A"
                        }
                    }

                    try {
                        $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
                        foreach ($process in $processes) {
                            $processStatus = [PSCustomObject]@{
                                ProcessId          = $process.Id
                                ProcessName        = $process.Name
                                CPU                = $process.CPU
                                Memory             = [math]::round($process.WorkingSet / 1MB, 2)
                                StartTime          = $process.StartTime
                                TotalProcessorTime = $process.TotalProcessorTime
                                Threads            = $process.Threads.Count
                                Handles            = $process.HandleCount
                                Path               = $process.Path
                                Status             = if ($process.Responding) { "Running" } else { "Not Responding" }
                                User               = Get-ProcessOwner -Process $process
                                PriorityClass      = $process.PriorityClass
                                WorkingSet         = [math]::round($process.WorkingSet / 1MB, 2)
                                VirtualMemorySize  = [math]::round($process.VirtualMemorySize / 1MB, 2)
                                PeakWorkingSet     = [math]::round($process.PeakWorkingSet / 1MB, 2)
                            }
                            $processStatus.PSObject.TypeNames.Insert(0, 'Custom.ProcessStatus')
                            $processStatus
                        }
                    }
                    catch {
                        Write-Error "Failed to retrieve process information on remote computer {$Computer}: $_"
                    }
                }

                try {
                    if ($Credential) {
                        Invoke-Command -ComputerName $computer -Credential $Credential -ScriptBlock $scriptBlock -ArgumentList $allProcessNames
                    }
                    else {
                        Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -ArgumentList $allProcessNames
                    }
                }
                catch {
                    Write-Error "Failed to connect to remote computer {$Computer}: $_"
                }
            }
            else {
                Write-Verbose "Querying local computer"

                # Get process status locally
                try {
                    $processes = Get-Process -Name $allProcessNames -ErrorAction SilentlyContinue
                    foreach ($process in $processes) {
                        $processStatus = [PSCustomObject]@{
                            ProcessId          = $process.Id
                            ProcessName        = $process.Name
                            CPU                = $process.CPU
                            Memory             = [math]::round($process.WorkingSet / 1MB, 2)
                            StartTime          = $process.StartTime
                            TotalProcessorTime = $process.TotalProcessorTime
                            Threads            = $process.Threads.Count
                            Handles            = $process.HandleCount
                            Path               = $process.Path
                            Status             = if ($process.Responding) { "Running" } else { "Not Responding" }
                            User               = Get-ProcessOwner -Process $process
                            PriorityClass      = $process.PriorityClass
                            WorkingSet         = [math]::round($process.WorkingSet / 1MB, 2)
                            VirtualMemorySize  = [math]::round($process.VirtualMemorySize / 1MB, 2)
                            PeakWorkingSet     = [math]::round($process.PeakWorkingSet / 1MB, 2)
                        }
                        $processStatus.PSObject.TypeNames.Insert(0, 'Custom.ProcessStatus')
                        $processStatus
                    }
                }
                catch {
                    Write-Error "Failed to retrieve process information on local {$Computer}: $_"
                }
            }
        }
        Write-Verbose "Ending Get-ProcessStatus function"
    }
}

# Load the formatting file
Update-FormatData -PrependPath "$PSScriptRoot\GetProcessStatus.Format.ps1xml"

# # Example usage
# Get-ProcessStatus -ProcessName "notepad", "chrome" -IncludeUser
