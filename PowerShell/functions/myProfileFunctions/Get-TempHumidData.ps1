Function Get-TempHumidData {
    Set-ConsoleConfig -WindowHeight 2 -WindowWidth 45
    Get-Content -Path "\\HOTH\TEMPerX\TEMPerX\1.csv" | ConvertFrom-Csv -Delimiter ',' | Select-Object -Last 1
    Start-Sleep -Seconds 5
    Clear-Host
    Get-TempHumidData
}

Function Restore-Console {
    Set-ConsoleConfig -WindowHeight 40 -WindowWidth 150
}
