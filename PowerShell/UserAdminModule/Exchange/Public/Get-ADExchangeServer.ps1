Function Get-ADExchangeServer {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0)]
        [Management.Automation.PSCredential]$credential,
  
        [Parameter(Position = 1)]
        [String]$server,
  
        [Parameter(Position = 2)]
        [String]$siteName
    )
    Begin {
        Function ConvertToExchangeRole {
            Param(
                [Parameter(Position = 0)]
                [int]$roles
            )
            $roleNumber = @{
                2  = 'MBX';
                4  = 'CAS';
                16 = 'UM';
                32 = 'HUB';
                64 = 'EDGE';
            }
            $roleList = New-Object -TypeName Collections.ArrayList
            foreach ($key in ($roleNumber).Keys) {
                if ($key -band $roles) {
                    [void]$roleList.Add($roleNumber.$key)
                }
            }
            Write-Output $roleList
        }
  
        $adParameters = @{
            ErrorAction = 'Stop';
        }
        $adExchProperties = @(
            'msExchCurrentServerRoles',
            'networkAddress',
            'serialNumber',
            'msExchServerSite'
        )
    }
    Process {
        Try {
            $filter = "objectCategory -eq 'msExchExchangeServer'"
            if ($PSBoundParameters.ContainsKey('credential')) {
                $adParameters.Add('Credential', $credential)
            }
            if ($PSBoundParameters.ContainsKey('server')) {
                $adParameters.Add('Server', $server)
            }
            $rootDse = Get-ADRootDse @adParameters
            $adParameters.Add('SearchBase', $rootDse.ConfigurationNamingContext)
  
            if ($PSBoundParameters.ContainsKey('siteName')) {
                Write-Verbose "Getting Site: $siteName"
                $site = Get-ADObject @adParameters `
                    -Filter "ObjectClass -eq 'site' -and Name -eq '$siteName'"
                if (!$site) {
                    Write-Error "Site not found: [$siteName]" `
                        -ErrorAction Stop
                }
                $filter = "$filter -and msExchServerSite -eq '$($site.DistinguishedName)'"
            }
            $adParameters.Add('Filter', $filter)
  
            $exchServers = Get-ADObject @adParameters `
                -Properties $adExchProperties
  
            foreach ($exServer in $exchServers) {
                $roles = ConvertToExchangeRole -roles $exServer.msExchCurrentServerRoles
  
                $fqdn = ($exServer.networkAddress | 
                    Where-Object { $_ -like 'ncacn_ip_tcp:*' }).Split(':')[1]
                New-Object -TypeName PSObject -Property @{
                    Name              = $exServer.Name;
                    DnsHostName       = $fqdn;
                    ExchangeVersion   = $exServer.serialNumber[0];
                    ServerRoles       = $roles;
                    DistinguishedName = $exServer.DistinguishedName;
                    Site              = $exServer.msExchServerSite;
                }
            }
        }
        Catch {
            Write-Error $_
        }
    }
    End {}
}
