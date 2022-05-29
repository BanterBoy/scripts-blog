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
