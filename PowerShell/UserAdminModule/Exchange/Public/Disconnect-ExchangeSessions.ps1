<#
.SYNOPSIS
Disconnects all active Exchange sessions and connections.

.DESCRIPTION
The Disconnect-ExchangeSessions function disconnects all active Exchange sessions and connections. It first retrieves all active PowerShell sessions using the Get-PSSession cmdlet, and then retrieves all active Exchange connections using the Get-ConnectionInformation function. It then iterates through each session and connection, and disconnects them if they are in the 'Opened' or 'Connected' state respectively.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Disconnect-ExchangeSessions
Disconnects all active Exchange sessions and connections.

.NOTES
Author: Your Name
Date: Today's Date
#>
function Disconnect-ExchangeSessions {
    $sessions = Get-PSSession
    $connections = Get-ConnectionInformation

    foreach ($session in $sessions) {
        if ($session.State -eq 'Opened') {
            Write-Output "Disconnecting session: $($session.Name)"
            Remove-PSSession -Session $session
        }
    }

    foreach ($connection in $connections) {
        if ($connection.State -eq 'Connected' -and $null -ne $connection.ConnectionId) {
            Write-Output "Disconnecting connection: $($connection.ConnectionId)"
            Disconnect-ExchangeOnline -ConnectionId $connection.ConnectionId -Confirm:$false
        }
    }
}