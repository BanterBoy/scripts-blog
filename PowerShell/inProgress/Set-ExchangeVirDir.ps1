$Servers = 'MAIL01', 'MAIL02', 'MAIL03', 'MAIL04'
$InternalUrl = "mail.ventrica.co.uk"
$ExternalUrl = "mail.ventrica.co.uk"

foreach ($item in $Servers) {
    Write-Host "Configuring Outlook Web App URLs"
    Get-OwaVirtualDirectory -Server $item | Set-OwaVirtualDirectory -ExternalUrl https://$ExternalUrl/owa -InternalUrl https://$InternalUrl/owa -WhatIf
    Write-Host "Configuring Exchange Control Panel URLs"
    Get-OwaVirtualDirectory -Server $item | Set-EcpVirtualDirectory -ExternalUrl https://$ExternalUrl/ecp -InternalUrl https://$InternalUrl/ecp -WhatIf
    Write-Host "Configuring ActiveSync URLs"
    Get-OwaVirtualDirectory -Server $item | Set-ActiveSyncVirtualDirectory -ExternalUrl https://$ExternalUrl/Microsoft-Server-ActiveSync -InternalUrl https://$InternalUrl/Microsoft-Server-ActiveSync -WhatIf
    Write-Host "Configuring Exchange Web Services URLs"
    Get-OwaVirtualDirectory -Server $item | Set-WebServicesVirtualDirectory -ExternalUrl https://$ExternalUrl/EWS/Exchange.asmx -InternalUrl https://$InternalUrl/EWS/Exchange.asmx -WhatIf
    Write-Host "Configuring Offline Address Book URLs"
    Get-OwaVirtualDirectory -Server $item | Set-OabVirtualDirectory -ExternalUrl https://$ExternalUrl/OAB -InternalUrl https://$InternalUrl/OAB -WhatIf
    Write-Host "Configuring MAPI/HTTP URLs"
    Get-OwaVirtualDirectory -Server $item | Set-MapiVirtualDirectory -ExternalUrl https://$ExternalUrl/mapi -InternalUrl https://$InternalUrl/mapi -WhatIf
}
