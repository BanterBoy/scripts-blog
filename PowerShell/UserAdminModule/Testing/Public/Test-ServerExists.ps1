Function Test-ServerExists {
    param (
        [CmdletBinding()]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    begin {
        $SelectHash = @{
            'Property' = @('Name', 'ADObject', 'DNSEntry', 'PingResponse', 'RDPConnection')
        }
    }

    process {
        foreach ($CurrentComputer in $ComputerName) {
            # Create new Hash
            $HashProps = @{
                'Name'          = $CurrentComputer
                'ADObject'      = $false
                'DNSEntry'      = $false
                'RDPConnection' = $false
                'PingResponse'  = $false
            }
        
            # Perform Checks
            switch ($true) {
                { ([adsisearcher]"samaccountname=$CurrentComputer`$").findone() } { $HashProps.ADObject = $true }
                { $(try { [system.net.dns]::gethostentry($CurrentComputer) } catch {}) } { $HashProps.DNSEntry = $true }
                { $(try { $socket = New-Object Net.Sockets.TcpClient($CurrentComputer, 3389); if ($socket.Connected) { $true }; $socket.Close() } catch {}) } { $HashProps.RDPConnection = $true }
                { Test-Connection -ComputerName $CurrentComputer -Quiet -Count 1 } { $HashProps.PingResponse = $true }
                Default {}
            }

            # Output object
            New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
        }
    }

    end {
    }
}
