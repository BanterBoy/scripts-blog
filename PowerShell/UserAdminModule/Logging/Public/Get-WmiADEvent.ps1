<#
.SYNOPSIS
    Retrieves WMI events based on the specified query.

.DESCRIPTION
    The Get-WmiADEvent function retrieves WMI events based on the specified query. It uses the System.Management namespace to create a WMI event watcher and waits for events to occur. When an event is received, it outputs the event details.

.PARAMETER query
    The WMI query string used to filter the events.

.EXAMPLE
    $query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
    Get-WmiADEvent -query $query

    This example retrieves all instance creation events for Active Directory user objects within the last 10 seconds.

.EXAMPLE
    $query = "Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
    Get-WmiADEvent -query $query

    This example retrieves all instance modification events for Active Directory computer objects within the last 10 seconds.
#>

Function Get-WmiADEvent {
    Param([string]$query)
  
    $Path = "root\directory\ldap"
    $EventQuery = New-Object System.Management.WQLEventQuery $query
    $Scope = New-Object System.Management.ManagementScope $Path
    $Watcher = New-Object System.Management.ManagementEventWatcher $Scope, $EventQuery
    $Options = New-Object System.Management.EventWatcherOptions
    $Options.TimeOut = [timespan]"0.0:0:1"
    $Watcher.Options = $Options
    Write-Output "("Waiting for events in response to: { 0 }" -F $($EventQuery.querystring))"
    $Watcher.Start()
    while ($true) {
        trap [System.Management.ManagementException] { continue }
  
        $Evt = $Watcher.WaitForNextEvent()
        if ($Evt) {
            $Evt.TargetInstance | Select-Object *
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
