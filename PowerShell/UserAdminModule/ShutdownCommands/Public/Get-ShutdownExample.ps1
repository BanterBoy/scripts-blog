function Get-ShutdownExample {
    <#
    .SYNOPSIS
        Displays an example PowerShell script for scheduling remote server shutdowns.
    
    .DESCRIPTION
        This function outputs a sample script showing how to import servers from a CSV
        and schedule shutdowns with error handling.
    
    .EXAMPLE
        Get-ShutdownExample
        Displays the shutdown scheduling example code in the console.
    #>

    [CmdletBinding()]
    param()

    $scriptBlock = @'
# Import server list from CSV
$results = Import-Csv -Path "C:\GitRepos\ShutdownServers.csv"

# Array to store failed shutdowns
$failedShutdowns = @()

# Schedule shutdown for each server
foreach ($entry in $results) {
    $computer = $entry.ServerName
    try {
        Start-RemoteComputerShutdownSchedule -ComputerName $computer `
            -ShutdownTime (Get-Date -Date "16:00") `
            -Action "Shutdown" `
            -Comment "Scheduled shutdown at 4pm" `
            -Force
        Write-Host "Shutdown scheduled for $computer"
    }
    catch {
        Write-Warning "Failed to schedule shutdown for ${$computer}: $_"
        $failedShutdowns += $computer
    }
}

# Report failed shutdowns
if ($failedShutdowns.Count -gt 0) {
    Write-Host "`nThe following servers failed to schedule shutdown:"
    $failedShutdowns | ForEach-Object { Write-Host "- $_" }
} else {
    Write-Host "`nAll shutdowns scheduled successfully."
}
'@

    $scriptBlock
}
