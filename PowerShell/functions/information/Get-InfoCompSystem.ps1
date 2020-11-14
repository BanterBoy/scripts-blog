function Get-InfoCompSystem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $ComputerName
    )
    $cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName
    $props = @{'Model' = $cs.model;
        'Manufacturer' = $cs.manufacturer;
        'RAM (GB)'     = "{0:N2}" -f ($cs.totalphysicalmemory / 1GB);
        'Sockets'      = $cs.numberofprocessors;
        'Cores'        = $cs.numberoflogicalprocessors
    }
    New-Object -TypeName PSObject -Property $props
}
