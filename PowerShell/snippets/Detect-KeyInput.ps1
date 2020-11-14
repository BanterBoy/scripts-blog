# Add required assemblies
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
 
# Pause to be able to press and hold a key
Start-Sleep -Seconds 2

# Key list
$Nokey = [System.Windows.Input.Key]::None
$key1 = [System.Windows.Input.Key]::LeftCtrl
$key2 = [System.Windows.Input.Key]::LeftShift

# Key presses
$isNokey = $Nokey
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key1)
$isShift = [System.Windows.Input.Keyboard]::IsKeyDown($key2)

# If no key is pressed, launch User Home Profile
if ($isNokey -eq 'None') {
    & (Join-Path $PSScriptRoot "/PersonalProfiles/HomePowerShell_profile.ps1")
}

# If LeftCtrl key is pressed, connect to Office365
elseif ($isCtrl) {
    & (Join-Path $PSScriptRoot "/PersonalProfiles/Connect-Office365Services.ps1")
}

# If LeftShift key is pressed, start PowerShell without a Profile
elseif ($isShift) {
    Start-Process "pwsh.exe" -ArgumentList  "-noprofile" -NoNewWindow
}

