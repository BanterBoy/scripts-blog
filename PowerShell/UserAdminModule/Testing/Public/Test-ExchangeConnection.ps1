function Test-ExchangeConnection {
    $sessions = Get-PSSession
    $connections = Get-ConnectionInformation
    $result = @()

    foreach ($session in $sessions) {
        if ($session.State -eq 'Opened') {
            $sessionDetails = New-Object PSObject -Property @{
                SessionName            = $session.Name
                ComputerName           = $session.ComputerName
                ConfigurationName      = $session.ConfigurationName
                SessionState           = "Established"
                ApplicationPrivateData = $session.ApplicationPrivateData
                Availability           = $session.Availability
                ComputerType           = $session.ComputerType
                ContainerId            = $session.ContainerId
                InstanceId             = $session.InstanceId
                Runspace               = $session.Runspace
                Transport              = $session.Transport
                VMId                   = $session.VMId
                VMName                 = $session.VMName
                DisconnectedOn         = $session.DisconnectedOn
                ExpiresOn              = $session.ExpiresOn
                IdleTimeout            = $session.IdleTimeout
                OutputBufferingMode    = $session.OutputBufferingMode
            }
            $result += $sessionDetails
        }
        else {
            $sessionDetails = New-Object PSObject -Property @{
                SessionName  = $session.Name
                SessionState = "Not Established"
            }
            $result += $sessionDetails
        }
    }

    foreach ($connection in $connections) {
        if ($connection.State -eq 'Connected') {
            $connectionDetails = New-Object PSObject -Property @{
                ConnectionId                    = $connection.ConnectionId
                ConnectionState                 = "Connected"
                ConnectionName                  = $connection.Name
                UserPrincipalName               = $connection.UserPrincipalName
                ConnectionUri                   = $connection.ConnectionUri
                AzureAdAuthorizationEndpointUri = $connection.AzureAdAuthorizationEndpointUri
                TokenExpiryTimeUTC              = $connection.TokenExpiryTimeUTC
                CertificateAuthentication       = $connection.CertificateAuthentication
                ModuleName                      = $connection.ModuleName
                ModulePrefix                    = $connection.ModulePrefix
                Organization                    = $connection.Organization
                DelegatedOrganization           = $connection.DelegatedOrganization
                AppId                           = $connection.AppId
                PageSize                        = $connection.PageSize
                TenantID                        = $connection.TenantID
                TokenStatus                     = $connection.TokenStatus
                ConnectionUsedForInbuiltCmdlets = $connection.ConnectionUsedForInbuiltCmdlets
                IsEopSession                    = $connection.IsEopSession
            }
            $result += $connectionDetails
        }
        else {
            $connectionDetails = New-Object PSObject -Property @{
                ConnectionName  = $connection.Name
                ConnectionState = "Not Connected"
            }
            $result += $connectionDetails
        }
    }

    return $result
}
