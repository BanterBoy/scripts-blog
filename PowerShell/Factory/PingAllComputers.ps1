$computers = Get-ADComputer -filter *

Foreach ($computer in $computers) {
    
    $ping = Test-NetConnection -ComputerName $computer.Name

    if ($ping.PingSucceeded -eq "True"){
        $computer.Name | Export-Csv -Path C:\Temp\test.csv -Append
        } 
    else {Write-Host $v.ComputerName "Ping failed"}
}
