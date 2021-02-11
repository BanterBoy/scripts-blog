& (Join-Path $PSScriptRoot "\Get-OUDialog.ps1")
& (Join-Path $PSScriptRoot "\New-FakeADUser.ps1")
& (Join-Path $PSScriptRoot "\New-FakeADUserDetails.ps1")

$OU = Get-OUDialog
$O365user = New-FakeADUserDetails -Nationality GB -PassLength 10 -Quantity 10 -Email "leigh-services.com" -Path $OU
$OnPremUser = New-FakeADUserDetails -Nationality GB -PassLength 10 -Quantity 10 -Path $OU
$O365user | New-FakeADUser -Path $OU -WhatIf
$OnPremUser | New-FakeADUser -Path $OU -WhatIf
$OnPremUser | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File $env:TEMP\NewTempUsers.csv -Encoding utf8
$O365user | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File $env:TEMP\NewTempUsers.csv -Encoding utf8 -Append
notepad.exe $env:TEMP\NewTempUsers.csv
