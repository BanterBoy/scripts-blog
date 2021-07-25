New-Item -Path "C:\inetpub\wwwroot\Weather.md" -ItemType File -Value "---
" -Force
Add-Content "C:\inetpub\wwwroot\Weather.md" "Title: Local Weather"
Add-Content "C:\inetpub\wwwroot\Weather.md" "TemplateName: Material"
Add-Content "C:\inetpub\wwwroot\Weather.md" "Robots: noindex, nofollow"
Add-Content "C:\inetpub\wwwroot\Weather.md" "Border: true"
Add-Content "C:\inetpub\wwwroot\Weather.md" "---"
Add-Content "C:\inetpub\wwwroot\Weather.md" ""

$Weather = .\adminToolkit\PowerShell\Extras\Get-Weather.ps1 -City Southend-on-Sea
ConvertTo-Markdown -Inputobject $Weather | Out-File C:\inetpub\wwwroot\Weather.md -Append

Add-Content "C:\inetpub\wwwroot\toc.md" "- [Local Weather](/Weather.md)"
