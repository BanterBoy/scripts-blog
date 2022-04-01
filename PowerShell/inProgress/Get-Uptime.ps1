function Get-Uptime {
    param(
        [string[]]$ComputerName,
        [Int32]$Days,
        [Switch]$Since
    )
 
    foreach ($Computer in $ComputerName) {
        $date = (Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime).LastBootUpTime
        if ($Since) {
            return $date
        }
        else {
            New-Timespan -Start $date
        }
    }
}
