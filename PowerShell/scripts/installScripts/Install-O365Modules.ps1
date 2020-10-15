$execpol = Get-ExecutionPolicy -List
foreach ($exec in $execpol) { Set-ExecutionPolicy -ExecutionPolicy Unrestricted }

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name AADRM -Scope AllUsers
Install-Module -Name AzureAD -Scope AllUsers
Install-Module -Name AzureADPreview -Scope AllUsers -AllowClobber
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope AllUsers
Install-Module -Name MicrosoftTeams -Scope AllUsers
Install-Module -Name MSOnline -Scope AllUsers
Install-Module -Name SharePointPnPPowerShellOnline -Scope AllUsers

Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

