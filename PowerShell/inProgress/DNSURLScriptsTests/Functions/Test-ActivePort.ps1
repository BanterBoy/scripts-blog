<# 
    .SYNOPSIS
    Test-OpenPort is an advanced Powershell function. Test-OpenPort acts like a port scanner. 

    .DESCRIPTION
    Uses Test-NetConnection. Define multiple targets and multiple ports. 

    .PARAMETER
    Target
    Define the target by hostname or IP-Address. Separate them by comma. Default: localhost 

    .PARAMETER
    Port
    Mandatory. Define the TCP port. Separate them by comma. 

    .EXAMPLE
    Test-OpenPort -Target sid-500.com,cnn.com,10.0.0.1 -Port 80,443 

    .NOTES
    Author: Patrick Gruenauer
    Web:
    https://sid-500.com 

    .LINK
    None. 

    .INPUTS
    None. 

    .OUTPUTS
    None.
#>

function Test-ActivePort {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True,
            Position = 0,
            HelpMessage = "Please enter DNS record name to be tested. Expectd format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or 151.101.0.81)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $Destination,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            Helpmessage = 'Enter Port Numbers. Separate them by comma.')]
        [int[]]
        $Port,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            Helpmessage = 'Enter Port Numbers. Separate them by comma.')]
        [ValidateSet('Exchange', 'Web')]
        [string]
        $StandardPorts

    )

    begin {

    }

    process {
        if ($Port) {
            foreach ($d in $Destination) {
                foreach ($p in $Port) {
                    $result = Test-NetConnection -ComputerName $d -Port $p -InformationLevel Detailed -WarningAction SilentlyContinue
                    $properties = [ordered]@{
                        "Destination"   = $result.ComputerName
                        "SourceAddress" = $result.SourceAddress
                        "RemoteAddress" = $result.RemoteAddress
                        "PortTested"    = $result.RemotePort
                        "PortOpen"      = $result.tcpTestSucceeded
                    }
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
        else {
            switch ($StandardPorts) {
                Exchange {
                    try {
                        foreach ($d in $Destination) {
                            $ports = '80', '110', '143', '443', '587'
                            foreach ($p in $ports) {
                                $result = Test-NetConnection -ComputerName $d -Port $p -InformationLevel Detailed -WarningAction SilentlyContinue
                                $properties = [ordered]@{
                                    "Destination"   = $result.ComputerName
                                    "SourceAddress" = $result.SourceAddress
                                    "RemoteAddress" = $result.RemoteAddress
                                    "PortTested"    = $result.RemotePort
                                    "PortOpen"      = $result.tcpTestSucceeded
                                }
                                $obj = New-Object -TypeName PSObject -Property $properties
                                Write-Output $obj
                            }
                        }
                    }
                    catch {
                        Write-Warning "$_"
                    }
                }
                Web {
                    try {
                        foreach ($d in $Destination) {
                            $ports = '80', '443'
                            foreach ($p in $ports) {
                                $result = Test-NetConnection -ComputerName $d -Port $p -InformationLevel Detailed -WarningAction SilentlyContinue
                                $properties = [ordered]@{
                                    "Destination"   = $result.ComputerName
                                    "SourceAddress" = $result.SourceAddress
                                    "RemoteAddress" = $result.RemoteAddress
                                    "PortTested"    = $result.RemotePort
                                    "PortOpen"      = $result.tcpTestSucceeded
                                }
                                $obj = New-Object -TypeName PSObject -Property $properties
                                Write-Output $obj
                            }
                        }
                    }
                    catch {
                        Write-Warning "$_"
                    }
                }
            }
            
        }
    }

    end {
        
    }

}

