Write-Output "$(Get-GivenName -Country SWEDEN) $(Get-SurName -Country SWEDEN)"
Write-Output "$(Get-GivenName -Country USA) $(Get-SurName -Country USA)"
Write-Output "$(Get-GivenName -Country UK) $(Get-SurName -Country UK)"
Write-Output "$(Get-GivenName -Country ALL) $(Get-SurName -Country ALL)"

or

1..100 | ForEach-Object { Write-Output "$(Get-GivenName -Country ALL) $(Get-SurName -Country ALL)" }

