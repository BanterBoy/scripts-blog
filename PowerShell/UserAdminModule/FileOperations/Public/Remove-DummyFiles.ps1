# Function to remove dummy files manually
function Remove-DummyFiles {
    param (
        [string]$DummyFilePath = "C:\Temp"
    )
    $logFiles = Get-ChildItem -Path $DummyFilePath -Filter "CopyLog-*.json" | Select-Object -ExpandProperty FullName
    Cleanup-TestFiles -LogFiles $logFiles -Verbose
}
