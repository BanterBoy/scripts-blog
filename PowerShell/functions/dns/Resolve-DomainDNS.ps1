function Get-DMARCRecord {
    <#
    .SYNOPSIS
        Get DMARC Record for a domain.
    .DESCRIPTION
        This function uses Resolve-DNSName to get the DMARC Record for a given domain. Objects with a DomainName property,
        such as returned by Get-AcceptedDomain, can be piped to this function.
    .EXAMPLE
        Get-AcceptedDomain | Get-DMARCRecord

        This example gets DMARC records for all domains returned by Get-AcceptedDomain.
    #>
    [CmdletBinding(HelpUri = 'https://ntsystems.it/PowerShell/TAK/Get-DMACRecord/')]
    param (
        # Specify the Domain name to use for the query.
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [string]
        $DomainName,
        
        # Specify a DNS server to query.
        [string]
        $Server
    )
    process {    
        $params = @{
            Name        = "_dmarc.$DomainName"
            ErrorAction = "SilentlyContinue"
        }
        if ($Server) { $params.Add("Server", $Server) }
        $dnsTxt = Resolve-DnsName @params -Type  TXT | Where-Object Type -eq TXT  
        $dnsTxt | Select-Object @{Name = "DMARC"; Expression = { "$DomainName`:$s" } }, @{Name = "Record"; Expression = { $_.Strings } }    
    }    
}

function Get-DKIMRecord {
    <#
    .SYNOPSIS
        Get DKIM Record for a domain.
    .DESCRIPTION
        This function uses Resolve-DNSName to get the DKIM Record for a given domain. Objects with a DomainName property,
        such as returned by Get-AcceptedDomain, can be piped to this function. The function defaults to "selector1" as this
        is typically used with Exchange Online.
    .EXAMPLE
        Get-AcceptedDomain | Get-DKIMRecord

        This example gets DKIM records for all domains returned by Get-AcceptedDomain.
    #>
    [CmdletBinding(HelpUri = 'https://ntsystems.it/PowerShell/TAK/Get-DKIMRecord/')]
    param (
        # Specify the Domain name to use in the query.
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [string]
        $DomainName,

        # Specify a selector name to use in the query.
        [Parameter()]
        [string[]]
        $Selector,

        # Specify a DNS server to query.
        [Parameter()]
        [string]
        $Server
    )
    process {
        foreach ($name in $Selector) {
            $params = @{
                Name        = "$name._domainkey.$DomainName"
                ErrorAction = "SilentlyContinue"
            }
            if ($Server) { $params.Add("Server", $Server) }
            $dnsTxt = Resolve-DnsName @params -Type TXT | Where-Object Type -eq TXT
            $dnsTxt | Select-Object @{Name = "DKIM"; Expression = { "$DomainName`:$s" } }, @{Name = "Record"; Expression = { $_.Strings } }
        }
    }
}

function Get-SPFRecord {
    <# 
    .Synopsis 
    Get SPF Record for a domain. 
    .DESCRIPTION 
    This function uses Resolve-DNSName to get the SPF Record for a given domain. Objects with a DomainName property, 
    such as returned by Get-AcceptedDomain, can be piped to this function. 
    .EXAMPLE 
    Get-AcceptedDomain | Get-SPFRecord 
 
    This example gets SPF records for all domains returned by Get-AcceptedDomain. 
    #>
    [CmdletBinding(HelpUri = 'https://ntsystems.it/PowerShell/TAK/Get-SPFRecord/')]
    param (
        # Specify the Domain name for the query.
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [string]
        $DomainName,
        
        # Specify the Domain name for the query.
        [string]
        $Server
    )
    process {
        $params = @{
            Type        = "txt"
            Name        = $DomainName
            ErrorAction = "Stop"
        }
        if ($Server) { $params.Add("Server", $Server) }
        try {
            $dns = Resolve-DnsName @params | Where-Object Strings -Match "spf1"
            $dns | Select-Object @{Name = "DomainName"; Expression = { $_.Name } }, @{Name = "Record"; Expression = { $_.Strings } }
        }
        catch {
            Write-Warning $_
        }
    }
}

Resolve-DnsName -Name $env:USERDOMAIN -Type A -Server 8.8.8.8 -ErrorAction Stop
Get-SPFRecord -DomainName example.co.uk -Server 8.8.4.4 -ErrorAction Stop
Get-DMARCRecord -DomainName example.co.uk -Server 8.8.8.8 -ErrorAction Stop
Get-DKIMRecord -DomainName example.co.uk -Server 8.8.8.8 -ErrorAction Stop
