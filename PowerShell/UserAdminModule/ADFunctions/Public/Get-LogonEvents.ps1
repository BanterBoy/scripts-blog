<#
.SYNOPSIS
    Retrieves logon events from a specified computer.

.DESCRIPTION
    The Get-LogonEvents function retrieves logon events from the Security log on a specified computer. It filters the events based on the event ID 4624, 
    which represents successful logon events. The function returns the time the logon event occurred and the user who logged on.

.PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve logon events.

.EXAMPLE
    Get-LogonEvents -ComputerName "Server01"
    Retrieves logon events from the Security log on "Server01" and displays the time and user information for each logon event.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Get-LogonEvents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )
    
    try {
        # Retrieve logon events from the specified computer
        $events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{LogName = 'Security'; ID = 4624 } -ErrorAction Stop
        
        if ($events) {
            # Select relevant properties from each event
            $events | Select-Object -Property TimeCreated, @{Name = 'User'; Expression = { $_.Properties[5].Value } }
        }
        else {
            Write-Warning -Message "No logon events found on $ComputerName"
        }
    }
    catch {
        Write-Error -Message "Failed to retrieve logon events from $ComputerName. Error: $_"
    }
}
