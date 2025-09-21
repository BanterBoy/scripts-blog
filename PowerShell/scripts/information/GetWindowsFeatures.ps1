# This script will list the installed Windows Features

import-module ServerManager
$InstalledFeatures = Get-WindowsFeature | Where-Object { $_.Installed -eq $True }
Write-Host "Installed Features:"
ForEach ($Feature in $InstalledFeatures) {
  $Message = " - " + $Feature.DisplayName + " (" + $Feature.Name + ")"
  Write-Host $Message
}
