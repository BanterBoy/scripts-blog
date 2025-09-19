function Switch-VpnFailover {
    <#
    .SYNOPSIS
    Switches the VPN client to failover or failback.

    .DESCRIPTION
    The Switch-VpnFailover function manages the failover and failback of a VPN client by stopping and starting the Cisco VPN service, modifying the hosts file, and logging the active connection.

    .PARAMETER Action
    The action to perform. Valid values are "Failover" and "Failback".

    .INPUTS
    System.String. You can pipe a string that specifies the action ("Failover" or "Failback") to the function.

    .OUTPUTS
    None. This function does not produce any output.

    .EXAMPLE
    Switch-VpnFailover -Action Failover
    Switches the VPN client to the secondary site.

    .EXAMPLE
    Switch-VpnFailover -Action Failback
    Switches the VPN client back to the primary site.

    .EXAMPLE
    "Failover" | Switch-VpnFailover
    Pipes the action to the function.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Specify the action to perform. Valid values are 'Failover' and 'Failback'.")]
        [ValidateSet("Failover", "Failback")]
        [string]$Action
    )

    begin {
        # Define variables
        $vpnService = "csc_vpnagent"
        $hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
        $vpnHostEntry = "127.0.0.1 vpn.rdg.co.uk"

        # Function to stop the VPN service
        function Stop-VpnService {
            Stop-Service -Name $vpnService -Force
        }

        # Function to start the VPN service
        function Start-VpnService {
            Start-Service -Name $vpnService
        }

        # Function to add an entry to the hosts file
        function Add-HostsEntry {
            if (-not (Get-Content $hostsFilePath | Select-String -Pattern $vpnHostEntry)) {
                Add-Content -Path $hostsFilePath -Value $vpnHostEntry
            }
        }

        # Function to remove an entry from the hosts file
        function Remove-HostsEntry {
            $hostsContent = Get-Content $hostsFilePath
            $updatedHostsContent = $hostsContent -replace [regex]::Escape($vpnHostEntry), ''
            Set-Content -Path $hostsFilePath -Value $updatedHostsContent
        }

        # Function to log an event
        function Write-EventLogEntry {
            param (
                [string]$Message,
                [string]$EventType = "Information"
            )
            $eventID = 1001 # Custom event ID
            $source = "Switch-VpnFailover"
            if (-not (Get-EventLog -LogName Application -Source $source -ErrorAction SilentlyContinue)) {
                New-EventLog -LogName Application -Source $source
            }
            Write-EventLog -LogName Application -Source $source -EventID $eventID -EntryType $EventType -Message $Message
        }

        # Function to test the current connection
        function Test-CurrentConnection {
            if (Get-Content $hostsFilePath | Select-String -Pattern $vpnHostEntry) {
                return "Secondary"
            } else {
                return "Primary"
            }
        }
    }

    process {
        $action = $Action

        if ($PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Perform $action")) {
            try {
                switch ($action) {
                    "Failover" {
                        Write-Output "Failing over to secondary site..."
                        Stop-VpnService
                        Add-HostsEntry
                        Start-VpnService
                        Write-Output "Failover complete."
                        Write-EventLogEntry -Message "Failover to secondary site completed." -EventType "Information"
                    }
                    "Failback" {
                        Write-Output "Failing back to primary site..."
                        Stop-VpnService
                        Remove-HostsEntry
                        Start-VpnService
                        Write-Output "Failback complete."
                        Write-EventLogEntry -Message "Failback to primary site completed." -EventType "Information"
                    }
                }

                # Test and log the current connection
                $currentConnection = Test-CurrentConnection
                Write-EventLogEntry -Message "Current connection: $currentConnection" -EventType "Information"
                Write-Output "Current connection: $currentConnection"
            }
            catch {
                Write-EventLogEntry -Message "Failed to perform {$action}: $_" -EventType "Error"
                Write-Error "Failed to perform {$action}: $_"
            }
        }
    }
}

# Example usage:
# Switch-VpnFailover -Action Failover
# Switch-VpnFailover -Action Failback
# "Failover" | Switch-VpnFailover
# "Failback" | Switch-VpnFailover
