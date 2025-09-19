<#
.SYNOPSIS
    Retrieves the services and processes running on a remote machine and matches them to their associated network ports.

.DESCRIPTION
    This function queries a remote machine using CIM for running processes, services, and network connections.
    It filters the results to show unique entries for IPv4 addresses, with local ports less than or equal to 10000.
    The function also includes the computer name and descriptions in the output.

.PARAMETER ComputerName
    The name of the remote computer to query.

.PARAMETER Credential
    Optional credentials to use for the connection.

.INPUTS
    System.String
        You can pipe a computer name to the ComputerName parameter.

.OUTPUTS
    PSCustomObject
        Custom objects representing the matched services, processes, and network ports.

.EXAMPLE
    Get-RemoteServerPorts -ComputerName "EXCHANGE01"

.EXAMPLE
    "EXCHANGE01" | Get-RemoteServerPorts

.EXAMPLE
    Get-RemoteServerPorts -ComputerName "EXCHANGE01" -Credential (Get-Credential)
#>

function Get-RemoteServerPorts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        $results = @()
    }

    process {
        try {
            if ($Credential) {
                $options = New-CimSessionOption -Protocol DCOM
                $cimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential -SessionOption $options
            } else {
                $cimSession = New-CimSession -ComputerName $ComputerName
            }

            Write-Verbose "Querying processes on $ComputerName"
            $processes = Get-CimInstance -CimSession $cimSession -ClassName Win32_Process

            Write-Verbose "Querying services on $ComputerName"
            $services = Get-CimInstance -CimSession $cimSession -ClassName Win32_Service

            Write-Verbose "Querying network connections on $ComputerName"
            $networkConnections = Get-CimInstance -CimSession $cimSession -Namespace "root/StandardCimv2" -ClassName MSFT_NetTCPConnection

            foreach ($connection in $networkConnections) {
                $process = $processes | Where-Object { $_.ProcessId -eq $connection.OwningProcess }
                $service = $services | Where-Object { $_.ProcessId -eq $connection.OwningProcess }

                if ($connection.LocalPort -le 10000 -and $connection.LocalAddress -notmatch ":") {
                    $results += [PSCustomObject]@{
                        ComputerName       = $ComputerName
                        ProcessName        = $process.Name
                        ProcessId          = $process.ProcessId
                        LocalAddress       = $connection.LocalAddress
                        LocalPort          = $connection.LocalPort
                        RemoteAddress      = $connection.RemoteAddress
                        RemotePort         = $connection.RemotePort
                        State              = switch ($connection.State) {
                                                1 { "Closed" }
                                                2 { "Listening" }
                                                3 { "SYN Sent" }
                                                4 { "SYN Received" }
                                                5 { "Established" }
                                                6 { "FIN Wait 1" }
                                                7 { "FIN Wait 2" }
                                                8 { "Close Wait" }
                                                9 { "Closing" }
                                                10 { "Last ACK" }
                                                11 { "Time Wait" }
                                                12 { "Delete TCB" }
                                                default { "Unknown" }
                                            }
                        ServiceName        = $service.Name
                        ServiceDisplayName = $service.DisplayName
                        Description        = $service.Description
                    }
                }
            }
        } catch {
            Write-Error "An error occurred: $_"
        } finally {
            Remove-CimSession -CimSession $cimSession
        }
    }

    end {
        $results | Sort-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, Protocol -Unique
        Update-FormatData -PrependPath "$PSScriptRoot\Get-RemoteServerPorts.Format.ps1xml"
    }
}
