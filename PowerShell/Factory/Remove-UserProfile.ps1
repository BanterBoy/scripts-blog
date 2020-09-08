#requires -version 3.0

#Remove-UserProfile.ps1

[cmdletbinding(SupportsShouldProcess)]

Param(
[Parameter(Position=0)]
[ValidateNotNullorEmpty()]
[int]$Days=3
)

$Logging = "C:\CSScripts\Logging"
If ((Test-Path $Logging) –eq $false) {
    New-Item -Path C:\CSScripts\ -Name Logging -ItemType Directory
}
Start-Transcript -Path $Logging\ProfileCleanup.txt -Append


Write-Warning "Filtering for user profiles older than $Days days" 
Get-CimInstance win32_userprofile -Verbose | 
Where {$_.LastUseTime -lt $(Get-Date).Date.AddDays(-$days)} |
Remove-CimInstance -Verbose

Stop-Transcript