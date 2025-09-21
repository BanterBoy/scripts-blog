[cmdletbinding()]
param (
    [parameter(ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $ComputerName = $env:ComputerName
)

begin {}
process {
    foreach ($Computer in $ComputerName) {
        if (Test-Connection -ComputerName $Computer -Count 1 -ErrorAction 0) {
            try {
                $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | Where-Object { $_.IPEnabled }
            }
            catch {
                Write-Warning "Error occurred while querying $Computer."
                Continue
            }
            foreach ($Network in $Networks) {
                $IPAddress = $Network.IpAddress[0]
                $SubnetMask = $Network.IPSubnet[0]
                $DefaultGateway = $Network.DefaultIPGateway
                $DNSServers = $Network.DNSServerSearchOrder
                $IsDHCPEnabled = $false
                If ($network.DHCPEnabled) {
                    $IsDHCPEnabled = $true
                }
                $MACAddress = $Network.MACAddress
                $OutputObj = New-Object -Type PSObject
                $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()
                $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
                $OutputObj | Add-Member -MemberType NoteProperty -Name SubnetMask -Value $SubnetMask
                $OutputObj | Add-Member -MemberType NoteProperty -Name Gateway -Value $DefaultGateway
                $OutputObj | Add-Member -MemberType NoteProperty -Name IsDHCPEnabled -Value $IsDHCPEnabled
                $OutputObj | Add-Member -MemberType NoteProperty -Name DNSServers -Value $DNSServers
                $OutputObj | Add-Member -MemberType NoteProperty -Name MACAddress -Value $MACAddress
                $OutputObj
            }
        }
    }
}

end {}
