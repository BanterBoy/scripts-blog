$Servers = Get-ADComputer -Filter 'Name -like "*"' -Properties * | Where-Object { ( $_.OperatingSystem -like '*server*' ) -and ( $_.Enabled -eq $true ) -and ( $_.IPv4Address -ne "$null" ) }
foreach ( $Server in $Servers ) {
    $filename = $Server.Name
    Invoke-Command -ComputerName $Server.Name -ScriptBlock {
        $FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound
        $FirewallRules | Select-Object -Property DisplayName, Description, Profile, Direction, Action, DisplayGroup
    } -ErrorAction SilentlyContinue | Out-File -FilePath "C:\GitRepos\$filename.FirewallRules.txt"
}


function Test-FirewallAllServer {
    $servers = (Get-ADComputer -Filter * -Properties Operatingsystem | Where-Object { $_.operatingsystem -like "*server*" }).Name
    $check = Invoke-Command -ComputerName $servers { Get-NetFirewallProfile -Profile Domain | Select-Object -ExpandProperty Enabled } -ErrorAction SilentlyContinue
    $line = "__________________________________________________________"
    $line2 = "=========================================================="
    $en = $check | Where-Object value -EQ "true"
    $di = $check | Where-Object value -EQ "false"
    If ($null -ne $en) {
        Write-Host ""; Write-Host "The following Windows Server have their firewall enabled:" -ForegroundColor Green; $line; Write-Output ""$en.PSComputerName""; Write-Host ""
    }
    If ($null -ne $di) {
        Write-Host ""; Write-Host "The following Windows Server have their firewall disabled:" -ForegroundColor Red ; $line; Write-Output ""$di.PSComputerName""; Write-Host ""
    }
    If ($null -eq $di) {
        Write-Host $line2; Write-Host "All Windows Servers have it's firewall enabled" -ForegroundColor Green; Write-Host ""
    }
    If ($null -eq $en) {
        Write-Host $line2; Write-Host "All Windows Servers have it's firewall disabled" -ForegroundColor Red; Write-Host ""
    }
}
