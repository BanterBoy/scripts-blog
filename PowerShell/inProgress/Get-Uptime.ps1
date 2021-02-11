function Get-Uptime {
    param(
        [string[]]$ComputerName,
        [Int32]$Days,
        [Switch]$Since
    )
 
    foreach ($Computer in $ComputerName) {
        $date = (Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem).LastBootUpTime
        if ($Since) {
            return $date
        }
        else {
            New-Timespan -Start $date
        }
    }
}
