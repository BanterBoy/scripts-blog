function Get-RemoteComputerScheduledShutdown {
    <#
    .SYNOPSIS
    Retrieves scheduled or recent shutdown/restart/hibernate events (Event ID 1074) for one or more remote computers.

    .DESCRIPTION
    Queries the System event log on the target computer(s) for Event ID 1074 and returns a collection of objects describing the action, time, and raw message.
    The function supports pipeline input and multiple computer names, optional credentials, and a configurable maximum events per computer.

    .PARAMETER ComputerName
    One or more remote computer names to query. Accepts pipeline input by value or property name.

    .PARAMETER MaxEvents
    The maximum number of recent events to retrieve per computer. Default is 5.

    .PARAMETER Credential
    Optional PSCredential to use for the remote connection.

    .EXAMPLE
    'SRV01','SRV02' | Get-RemoteComputerScheduledShutdown -MaxEvents 10

    .EXAMPLE
    Get-RemoteComputerScheduledShutdown -ComputerName RDGDC01 -Credential (Get-Credential)
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]
        $MaxEvents = 5,

        [Parameter(Mandatory = $false)]
        [PSCredential]
        $Credential
    )

    begin {
        $allResults = @()
    }

    process {
        foreach ($target in $ComputerName) {
            try {
                Write-Verbose "Querying event log on $target for up to $MaxEvents events."

                $invokeParams = @{ 
                    ComputerName = $target
                    ScriptBlock  = {
                        param ($maxEvents)
                        Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 1074 } -MaxEvents $maxEvents -ErrorAction Stop
                    }
                    ArgumentList = $MaxEvents
                    ErrorAction  = 'Stop'
                }

                if ($Credential) { $invokeParams.Credential = $Credential }

                $events = Invoke-Command @invokeParams

                if ($events -and $events.Count -gt 0) {
                    Write-Verbose "Found $($events.Count) event(s) on $target."
                    foreach ($evt in $events) {
                        $msg = $evt.Message
                        $time = $evt.TimeCreated
                        $action = switch -Regex ($msg) {
                            'shutdown'   { 'Shutdown'; break }
                            'restart|reboot' { 'Restart'; break }
                            'hibernate|sleep' { 'Hibernate'; break }
                            default { 'Unknown' }
                        }

                        $allResults += [PSCustomObject]@{
                            ComputerName    = $target
                            EventRecordId    = $evt.RecordId
                            TimeCreated      = $time
                            Action           = $action
                            ScheduledTime    = $time
                            Message          = $msg
                        }
                    }
                }
                else {
                    Write-Verbose "No scheduled shutdown/restart/hibernate events found on $target."
                    $allResults += [PSCustomObject]@{
                        ComputerName    = $target
                        EventRecordId    = $null
                        TimeCreated      = $null
                        Action           = 'None'
                        ScheduledTime    = $null
                        Message          = 'No scheduled events found.'
                    }
                }
            }
            catch [System.Management.Automation.RemotingException] {
                Write-Error "Remote access failed for $target. Ensure WinRM/remote management is enabled and you have permissions. Error: $($_.Exception.Message)"
                $allResults += [PSCustomObject]@{
                    ComputerName    = $target
                    EventRecordId    = $null
                    TimeCreated      = $null
                    Action           = 'Error'
                    ScheduledTime    = $null
                    Message          = "Remote access failed: $($_.Exception.Message)"
                }
            }
            catch {
                Write-Error "Failed to retrieve scheduled shutdown event from $target. Error: $($_.Exception.Message)"
                if ($_.Exception.InnerException) {
                    Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
                }
                $allResults += [PSCustomObject]@{
                    ComputerName    = $target
                    EventRecordId    = $null
                    TimeCreated      = $null
                    Action           = 'Error'
                    ScheduledTime    = $null
                    Message          = "General failure: $($_.Exception.Message)"
                }
            }
        }
    }

    end {
        return ,$allResults
    }
}
