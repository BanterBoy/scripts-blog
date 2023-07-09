

$Servers = Get-ADComputer -Filter "Name -like '*' " -Properties OperatingSystem | Where-Object -Property OperatingSystem -Like '*server*'

$Servers | ForEach-Object -Process {
    try {
        $Test = (Test-Connection -ComputerName $_.dnshostname -Count 1 -Ping -ErrorAction SilentlyContinue ).Status
        if (  $Test.Status -eq 'Success' ) {
            Write-Output "$_.DNSHostName : Available"
        }
        else {
            Write-Output "$_.DNSHostName : Un-Available"
        }
    }
    catch {
        Write-Error $_
    }
}
