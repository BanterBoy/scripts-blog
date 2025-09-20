function Restart-ExchangeServices {
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string[]]$ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Services = Get-Service -ComputerName $Computer | Where-Object { $_.Name -like "MSExchange*" -and $_.Status -eq "Running" }
        foreach ($Service in $Services) {
            Restart-Service $Service.name -Force
        }
    }
}
