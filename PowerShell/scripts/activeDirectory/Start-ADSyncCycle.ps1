Import-Module –Name ADSync

# Import-Module –Name "C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync" -Verbose

Get-ADSyncScheduler

# To force a full sync from Windows PowerShell

Start-ADSyncSyncCycle -PolicyType Full

# To force a delta sync:

Start-ADSyncSyncCycle -PolicyType Delta
