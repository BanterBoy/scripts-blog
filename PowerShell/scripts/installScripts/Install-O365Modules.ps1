$execpol = Get-ExecutionPolicy -List
foreach ($exec in $execpol) { Set-ExecutionPolicy -ExecutionPolicy Unrestricted }

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name AADRM -Scope AllUsers -Force
Install-Module -Name AzureAD -Scope AllUsers -Force
Install-Module -Name AzureADPreview -Scope AllUsers -Force -AllowClobber
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope AllUsers -Force
Install-Module -Name MicrosoftTeams -Scope AllUsers -Force
Install-Module -Name MSOnline -Scope AllUsers -Force
Install-Module -Name SharePointPnPPowerShellOnline -Scope AllUsers -Force
Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

