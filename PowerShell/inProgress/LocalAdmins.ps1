New-Item -Path "C:\inetpub\wwwroot\LocalAdmins.md" -ItemType File -Value "---
" -Force
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" "Title: Local Administrators"
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" "TemplateName: Material"
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" "Robots: noindex, nofollow"
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" "Border: true"
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" "---"
Add-Content "C:\inetpub\wwwroot\LocalAdmins.md" ""

$GetAdmins = Get-LocalGroup Administrators | Get-LocalGroupMember

$Admins = $GetAdmins | Select-Object -Property 'Name','PrincipalSource','ObjectClass','SID'

ConvertTo-Markdown -Inputobject $Admins -AsTable | Out-File C:\inetpub\wwwroot\LocalAdmins.md -Append

Add-Content "C:\inetpub\wwwroot\toc.md" "- [Local Admins](/LocalAdmins.md)"
