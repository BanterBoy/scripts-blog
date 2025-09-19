function Test-LDAPConnection {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DomainName,
        
        [string]$ComputerName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("LDAP", "LDAPS", "Both")]
        [string]$Protocol
    )

    $searchBase = "DC=" + $DomainName.Replace('.', ',DC=')
    $searchFilter = "(objectClass=user)"
    
    function Test-LDAP {
        param (
            [string]$hostname,
            [bool]$useSSL
        )

        $protocolType = if ($useSSL) { "LDAPS" } else { "LDAP" }
        $port = if ($useSSL) { 636 } else { 389 }
        $result = [PSCustomObject]@{
            Hostname    = $hostname
            Protocol    = $protocolType
            Port        = $port
            Status      = "Unknown"
            Message     = ""
        }

        try {
            Write-Verbose "Attempting to connect to $hostname on port $port using $protocolType..."

            $ldapConnection = New-Object System.DirectoryServices.Protocols.LdapConnection($hostname)
            $ldapConnection.SessionOptions.SecureSocketLayer = $useSSL
            $ldapConnection.SessionOptions.ProtocolVersion = 3

            $ldapConnection.Bind()
            Write-Verbose "Successfully connected to $hostname on port $port using $protocolType."

            $searchRequest = New-Object System.DirectoryServices.Protocols.SearchRequest(
                $searchBase, 
                $searchFilter, 
                [System.DirectoryServices.Protocols.SearchScope]::Subtree, 
                $null
            )

            $searchResponse = $ldapConnection.SendRequest($searchRequest)

            if ($searchResponse.Entries.Count -gt 0) {
                $result.Status = "Success"
                $result.Message = "$protocolType is working on $hostname"
            } else {
                $result.Status = "Fail"
                $result.Message = "$protocolType is NOT working on $hostname"
            }

            $ldapConnection.Dispose()
        } catch {
            $result.Status = "Error"
            $result.Message = "Error testing $protocolType on {$hostname}: $_"
        }

        return $result
    }

    if (-not $ComputerName) {
        $domainControllers = Get-ADDomainController -Filter *
    } else {
        $domainControllers = @(Get-ADDomainController -Identity $ComputerName)
    }

    $results = @()

    foreach ($dc in $domainControllers) {
        $hostname = $dc.HostName
        
        if ($Protocol -eq "LDAP" -or $Protocol -eq "Both") {
            $results += Test-LDAP -hostname $hostname -useSSL $false
        }

        if ($Protocol -eq "LDAPS" -or $Protocol -eq "Both") {
            $results += Test-LDAP -hostname $hostname -useSSL $true
        }
    }

    return $results
}
