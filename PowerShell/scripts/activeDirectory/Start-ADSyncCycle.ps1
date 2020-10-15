Import-Module ADSync

Get-ADSyncScheduler

# To force a full sync from Windows PowerShell

Start-ADSyncSyncCycle -PolicyType Initial

# To force a delta sync:

Start-ADSyncSyncCycle -PolicyType Delta
