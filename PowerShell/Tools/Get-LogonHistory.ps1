function Get-LogonHistory {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [int]$Days = 10
    )
    # Clear-Host
    $Result = @()
    $eventLogs = Get-EventLog System -Source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-$Days) -ComputerName $ComputerName
    If ($eventLogs) {
        ForEach ($Log in $eventLogs) {
            If ($Log.InstanceId -eq 7001) {
                $eventType = "Logon"
            }
            ElseIf ($Log.InstanceId -eq 7002) {
                $eventType = "Logoff"
            }
            Else {
                Continue
            }
            $Result += New-Object PSObject -Property @{
                Time         = $Log.TimeWritten
                EventType    = $eventType
                User         = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
            }
        }
        $Result | Sort-Object Time -Descending
    }
    Else {
        Write-Warning "Problem with $ComputerName."
        Write-Warning "If you see a 'Network Path not found' error, try starting the Remote Registry service on that Computer."
        Write-Warning "Or there are no logon/logoff events (XP requires auditing be turned on)"
    }
}
