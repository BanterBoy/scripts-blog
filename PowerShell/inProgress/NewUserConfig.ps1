function New-ADUserConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParameterSet1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [OutputType([string])]
        [ArgumentCompleter( {
                $baseOU = (Get-ADDomain).DistinguishedName
                $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
                foreach ($OU in $OUs) { 
                    ($OU).DistinguishedName
                }
            } ) ]
        [string]
        $SelectOU
    )
}


