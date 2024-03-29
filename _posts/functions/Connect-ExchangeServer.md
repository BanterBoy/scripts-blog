---
layout: post
title: Connect-ExchangeServer.ps1
---

---

Interesting stuff further down the page! 🤔

- [Description](#description)
  - [Examples](#examples)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

Something about the lack of information and the thought about making as many scripts available as possible, regardless of any missing additional content.

Some information about the exciting thing.....that's actually what will be here, rather than this filler text.

Please report any issues or suggestions using the link in the [Report Issues](#report-issues) section. If you report a requirement for more information, I can prioritise which pages are updated first. At present, I am working on adding information for each exciting thing contained within these pages.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Examples

This section will, in the near future, contain one or more examples of the script/function/etc in use and a small sample of the output and will hopefully prove somewhat more useful than the current content 🤷‍♂️

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

```powershell
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Connect-ExchangeServer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible. Something heartfelt about "Helping me, to help you.......?" or something like that.....I am sure you understand where I am coming from.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-ExchangeServer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>
