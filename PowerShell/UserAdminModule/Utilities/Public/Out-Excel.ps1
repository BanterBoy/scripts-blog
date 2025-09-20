function Out-Excel {
    param(
        $path = "$env:temp\report$(Get-Date -Format yyyyMMddHHmmss).csv"
    )
    $Input |
    Export-Csv $path -NoTypeInformation -UseCulture -Encoding UTF8
    Invoke-Item $path
}
# Get-Process | Out-Excel
