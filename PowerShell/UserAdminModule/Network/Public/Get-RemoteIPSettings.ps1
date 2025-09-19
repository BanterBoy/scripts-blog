<#
.SYNOPSIS
    Retrieves remote computer IP configuration details.
.DESCRIPTION
    Get-RemoteIPSettings uses PowerShell remoting to fetch network settings such as IP addresses,
    default gateways, and DNS server addresses from one or more remote computers.
.EXAMPLE
    Get-RemoteIPSettings -ComputerName "Server01","Server02" -Credential (Get-Credential)
.NOTES
    Ensure that PowerShell remoting is enabled on the target computers.
    This function is as remote as it gets—bringing your network details right to your console!
#>

function Get-RemoteIPSettings {
    [CmdletBinding()]
    param(
        # One or more target computer names
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string[]]$ComputerName,

        # Optional credentials if needed for remote access
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    
    process {
        foreach ($computer in $ComputerName) {
            try {
                Write-Verbose "Connecting to $computer..."
                
                # Prepare the parameters for Invoke-Command
                $invokeParams = @{
                    ComputerName = $computer
                    ScriptBlock  = {
                        # Retrieve network configuration and format the output
                        Get-NetIPConfiguration | ForEach-Object {
                            [PSCustomObject]@{
                                InterfaceAlias = $_.InterfaceAlias
                                IPv4Address    = ($_.IPv4Address | ForEach-Object { $_.IPAddress }) -join ', '
                                IPv6Address    = ($_.IPv6Address | ForEach-Object { $_.IPAddress }) -join ', '
                                DefaultGateway = ($_.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) -join ', '
                                DNSServers     = ($_.DNSServer.ServerAddresses) -join ', '
                            }
                        }
                    }
                    ErrorAction  = 'Stop'
                }

                if ($Credential) {
                    $invokeParams.Credential = $Credential
                }

                $results = Invoke-Command @invokeParams
                Write-Output $results
            }
            catch {
                Write-Warning "Failed to retrieve IP settings from $computer. Error: $_"
            }
        }
    }
}
