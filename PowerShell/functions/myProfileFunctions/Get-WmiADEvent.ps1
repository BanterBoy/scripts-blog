Function Get-WmiADEvent {
    Param([string]$query)
  
    $Path="root\directory\ldap"
    $EventQuery  = New-Object System.Management.WQLEventQuery $query
    $Scope       = New-Object System.Management.ManagementScope $Path
    $Watcher     = New-Object System.Management.ManagementEventWatcher $Scope,$EventQuery
    $Options     = New-Object System.Management.EventWatcherOptions
    $Options.TimeOut = [timespan]"0.0:0:1"
    $Watcher.Options = $Options
    cls
    Write-Host ("Waiting for events in response to: {0}" -F $EventQuery.querystring)  -backgroundcolor cyan -foregroundcolor black
    $Watcher.Start()
    while ($true) {
       trap [System.Management.ManagementException] {continue}
  
       $Evt=$Watcher.WaitForNextEvent()
        if ($Evt) {
           $Evt.TargetInstance | select *
        Clear-Variable evt
        }
    }
}
  
# Sample usage

# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_GROUP'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
# Get-WmiADEvent $query
