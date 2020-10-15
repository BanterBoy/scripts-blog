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
