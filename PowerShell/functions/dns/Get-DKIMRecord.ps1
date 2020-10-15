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
