function Get-InfoNIC {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $ComputerName
    )
    $nics = Get-WmiObject -class Win32_NetworkAdapter -ComputerName $ComputerName -Filter "PhysicalAdapter=True"
    foreach ($nic in $nics) {
        $props = @{'NICName' = $nic.servicename;
            'Speed'          = $nic.speed / 1MB -as [int];
            'Manufacturer'   = $nic.manufacturer;
            'MACAddress'     = $nic.macaddress
        }
        New-Object -TypeName PSObject -Property $props
    }
}
