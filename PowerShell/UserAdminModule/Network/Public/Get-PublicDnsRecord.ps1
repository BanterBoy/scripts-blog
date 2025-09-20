Function Get-PublicDnsRecord {
    <#
    .SYNOPSIS
        Make some DNS query based on Stat DNS.
    .DESCRIPTION
        Use Invoke-WebRequest on Stat DNS to resolve DNS query.
    .EXAMPLE
        Get-PublicDnsRecord -DomaineNAme "ItForDummies.net" -DnsRecordType A,MX
    .EXAMPLE
        Get-PublicDnsRecord -DomaineNAme "www.valbox.fr" -DnsRecordType A,MX
    .PARAMETER DomainName
        Domain name to query.
    .PARAMETER DnsRecordType
        DNS type to query.
    .INPUTS
    .OUTPUTS
    .NOTES
    .LINK
    #>
    Param(
        [Parameter(Mandatory = $true,
            HelpMessage = 'DNS domain name to query.',
            Position = 1)]
        [String]$DomainName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'DNS record type to query.',
            Position = 2)]
        [ValidateSet('A', 'AAAA', 'CERT', 'CNAME', 'DHCIP', 'DLV', 'DNAME', 'DNSKEY', 'DS', 'HINFO', 'HIP', 'IPSECKEY', 'KX', 'LOC', 'MX', 'NAPTR', 'NS', 'NSEC', 'NSEC3', 'NSEC3PARAM', 'OPT', 'PTR', 'RRSIG', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TA', 'TALINK', 'TLSA', 'TXT')]
        [String[]]$DnsRecordType
    )

    DynamicParam {        
        $AttribColl = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
        $ParamAttrib = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamAttrib.Mandatory = $false
        $ParamAttrib.ParameterSetName = '__AllParameterSets'
        $ParamAttrib.ValueFromPipeline = $false
        $ParamAttrib.ValueFromPipelineByPropertyName = $false
        $AttribColl.Add($ParamAttrib)
        $AttribColl.Add((New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList ((Invoke-WebRequest -Uri 'http://www.dns-lg.com/nodes.json' | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty nodes | Select-Object -ExpandProperty name))))
        $RuntimeParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('Node', [string], $AttribColl)
        $RuntimeParamDic = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Node', $RuntimeParam)
        $RuntimeParamDic
    }

    Begin {
        $PsBoundParameters.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Key -Value $_.Value -ErrorAction 'SilentlyContinue' }
        if (!$Node) { $Node = Invoke-WebRequest -Uri 'http://www.dns-lg.com/nodes.json' | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty nodes | Select-Object -ExpandProperty name | Get-Random }
    }
    Process {
        ForEach ($Record in $DnsRecordType) {
            Try {
                $WebUrl = 'http://www.dns-lg.com/{0}/{1}/{2}' -f $Node, $DomainName, $Record
                
                Write-Verbose -Message "Constructed URL for query is $WebUrl."

                $WebData = Invoke-WebRequest -Uri $WebUrl -ErrorAction Stop | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty answer
                $WebData | % {
                    New-Object -TypeName PSObject -Property @{
                        'Name'   = $_.name
                        'Type'   = $_.type
                        'Target' = $_.rdata
                        'Node'   = $Node
                    }
                }
            }
            catch {
                Write-Warning -Message $_
                New-Object -TypeName PSObject -Property @{
                    'Name'   = $DomainName
                    'Type'   = $Record
                    'Target' = ($_[0].ErrorDetails.Message -split '"')[-2]
                    'Node'   = $Node
                }
            }
        }
    }
    End {}
}
