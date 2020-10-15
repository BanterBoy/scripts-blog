Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

# choose the abort key
$key = [System.Windows.Input.Key]::LeftCtrl
  
Write-Warning "PRESS $key TO ABORT!"
  
do {
    $isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key)
    if ($isCtrl) {
        Write-Host
        Write-Host "You pressed $key, so exiting!" -ForegroundColor Green
        break
    }
    Write-Host "." -NoNewline
    Start-Sleep -Milliseconds 100
} while ($true)
