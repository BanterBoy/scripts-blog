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
