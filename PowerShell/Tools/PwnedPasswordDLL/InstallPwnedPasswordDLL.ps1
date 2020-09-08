Copy-Item -Path .\PwnedPasswordsDLL-API.dll -Destination C:\Windows\System32\PwnedPasswordsDLL-API.dll
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Lsa\ -Name "Notification Packages" -Value "PwnedPasswordsDLL-API" -Type MultiString
