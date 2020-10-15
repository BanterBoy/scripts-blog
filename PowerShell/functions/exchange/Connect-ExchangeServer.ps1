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
  
Function Connect-ExchangeServer {
    [CmdletBinding(DefaultParameterSetName = 'enumerate')]
    Param(
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'name')]
        [String]$name,
  
        [Parameter(Position = 0, ParameterSetName = 'Enumerate')]
        [Bool]$enumerate = $true,
  
        [Parameter(Position = 1)]
        [Management.Automation.PSCredential]$credential,
  
        [Parameter(Position = 2)]
        [String]$domainController,
  
  
        [Parameter(Position = 3, ParameterSetName = 'Enumerate')]
        [String]$siteName
    )
    Begin {
        $adParameters = @{
            ErrorAction = 'Stop';
        }
    }
    Process {
        if ($PSBoundParameters.ContainsKey('credential')) {
            $adParameters.Add('credential', $credential)
        }
        if ($PSBoundParameters.ContainsKey('domainController')) {
            $adParameters.Add('server', $domainController)
        }
        if ($PSBoundParameters.ContainsKey('siteName')) {
            $adParameters.Add('siteName', $siteName)
        }
        Try {
            if ($enumerate) {
                Write-Verbose "Getting list of Exchange Servers"
                $exchServers = Get-ADExchangeServer @adParameters
            }
            else {
                $exchServers = New-Object -TypeName PSObject -Property @{
                    DnsHostName = $name;
                }
            }
            $winrmParameters = @{
                'ErrorAction' = 'Stop';
            }
  
            $snParameters = @{
                'ErrorAction'       = 'Stop';
                'ConfigurationName' = 'Microsoft.Exchange';
            }
            if ($adParameters.credential) {
                $snParameters.Add('Credential', $adParameters.Credential)
            }
            foreach ($exServer in $exchServers) {
                Try {
                    Write-Verbose "Testing WinRm: $($exServer.DnsHostName)"
                    $winrm = Test-WSMan @winrmParameters `
                        -ComputerName $exServer.DnsHostName
                    if ($winrm) {
                        Write-Verbose "Connecting to: $($exServer.DnsHostName)"
                        $exSn = New-PSSession @snParameters `
                            -ConnectionUri "http://$($exServer.DnsHostName)/powershell"
                    }
                    return $exSn
                }
                Catch {
                    $errMsg = "Server: $($exServer.DnsHostName)] $($_.Exception.Message)"
                    Write-Error -Message $errMsg
                    continue
                }
            }
        }
        Catch {
            Write-Error $_
        }
    }
    End {}
}
