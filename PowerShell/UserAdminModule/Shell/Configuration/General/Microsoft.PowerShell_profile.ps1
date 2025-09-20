# Add required assemblies
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
 
# Pause to be able to press and hold a key
Start-Sleep -Seconds 1

# Key list
$Nokey = [System.Windows.Input.Key]::None
$key1 = [System.Windows.Input.Key]::LeftCtrl
$key2 = [System.Windows.Input.Key]::LeftShift

# Key presses
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key1)
$isShift = [System.Windows.Input.Keyboard]::IsKeyDown($key2)

# If LeftCtrl key is pressed, launch User Work Profile
if ($isCtrl) {
	Write-Warning -Message "LeftCtrl key has been pressed - User Work Profile"
	& (Join-Path $PSScriptRoot "/personalProfiles/WorkPowerShell_profile.ps1")
	& (Join-Path $PSScriptRoot "/personalProfiles/Connect-Office365Services.ps1")
}

# If LeftShift key is pressed, start PowerShell without a Profile
elseif ($isShift) {
	Write-Warning -Message "LeftShift key has been pressed - PowerShell without a Profile"
	Start-Process "pwsh.exe" -ArgumentList "-NoNewWindow -noprofile"
}

# If no key is pressed, launch User Home Profile
elseif ($Nokey -eq 'None') {
	Write-Warning -Message "No key has been pressed - User Home Profile"
	& (Join-Path $PSScriptRoot "/personalProfiles/HomePowerShell_profile.ps1")
}
