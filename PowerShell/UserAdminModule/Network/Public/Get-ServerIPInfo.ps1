<#
.SYNOPSIS
Retrieves IP information for servers in Active Directory.

.DESCRIPTION
The Get-ServerIPInfo function retrieves IP information for servers in Active Directory. It queries the Active Directory for enabled computers with an operating system that contains the word "server". It then tests the connection to each server and retrieves the IP configuration and routing information.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-ServerIPInfo
Retrieves IP information for servers in Active Directory.

.OUTPUTS
The function returns an array of custom objects with the following properties:
- Server: The name of the server.
- Interface: The interface alias(es) of the server.
- IPv4Address: The IPv4 address(es) of the server.
- Gateway: The default gateway of the server.
- DNSServer: The DNS server(s) of the server.

.NOTES
This function requires the Active Directory module and administrative privileges to run.

.LINK
https://github.com/your-repo/Get-ServerIPInfo.ps1
#>

function Get-ServerIPInfo {
    $ServerList = (Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"').Name
    $test = Test-Connection -ComputerName $ServerList -Count 1 -ErrorAction SilentlyContinue
    $Available = $test | Select-Object -ExpandProperty Address
    $result = @()
     
    foreach ($Server in $Available) {
        $Invoke = Invoke-Command -ComputerName $Server -ScriptBlock {
            Get-NetIPConfiguration | Select-Object -Property InterfaceAlias, Ipv4Address, DNSServer
            Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -ExpandProperty NextHop
        }
        $result += New-Object -TypeName PSCustomObject -Property ([ordered]@{
                'Server'      = $Server
                'Interface'   = $Invoke.InterfaceAlias -join ','
                'IPv4Address' = $Invoke.Ipv4Address.IPAddress -join ','
                'Gateway'     = $Invoke | Select-Object -Last 1
                'DNSServer'   = ($Invoke.DNSServer | Select-Object -ExpandProperty ServerAddresses) -join ',' 
            })
    }
    $result
}
