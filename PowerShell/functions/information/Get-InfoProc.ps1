function Get-InfoProc {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $ComputerName
    )
    
    $procs = Get-WmiObject -class Win32_Process -ComputerName $ComputerName
    foreach ($proc in $procs) {
        $props = @{'ProcName' = $proc.name;
            'Executable'      = $proc.ExecutablePath
        }
        New-Object -TypeName PSObject -Property $props
    }
}
