<#
.SYNOPSIS
    Retrieves issued certificates from one or more CAs with optional filters.

.DESCRIPTION
    Connects to specified Certification Authorities using PSPKI, retrieves all issued
    certificate requests, enriches each record with a friendly Certificate Template
    name, and applies optional filters on CommonName, Request.RequesterName, and
    CertificateTemplateName.

.PARAMETER ComputerName
    One or more CA hostnames (supports wildcard) to query. Defaults to 'rdglonaldppk00*'.

.PARAMETER CommonName
    Exact CommonName to filter the results. If omitted, all CommonNames are returned.

.PARAMETER RequesterName
    Wildcard pattern to match the Request.RequesterName property. e.g. 'RDG\Luke*'.

.PARAMETER TemplateName
    Wildcard pattern to match the friendly CertificateTemplateName. e.g. '*WinRM*'.

.EXAMPLE
    # Retrieve all issued certificates from all rdglonaldppk00* CAs
    Get-RDGCAIssuedCert

.EXAMPLE
    # Filter by Exact CommonName
    Get-RDGCAIssuedCert -CommonName 'RDGLT3230'

.EXAMPLE
    # Filter by RequesterName wildcard
    Get-RDGCAIssuedCert -RequesterName 'RDG\Luke*'

.EXAMPLE
    # Filter by Certificate Template display name
    Get-RDGCAIssuedCert -TemplateName '*WinRM*'

.EXAMPLE
    # Combine filters
    Get-RDGCAIssuedCert -ComputerName 'rdglonaldppk001','rdglonaldppk002' `
                        -CommonName 'RDGLT3230.rdg.co.uk' `
                        -RequesterName 'RDG\RDGLT*' `
                        -TemplateName '*WinRM*'

.NOTES
    Requires the PSPKI module to be installed and network access to the target CAs.
#>
#requires -Version 7.0
#requires -PSEdition Core
function Get-RDGCAIssuedCert {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([PSCustomObject])]
    param(
        [Alias('CA')]
        [Parameter(
            Position = 0,
            HelpMessage = 'One or more CA hostnames (supports wildcard).',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $ComputerName = 'rdglonaldppk00*',

        [Parameter(
            HelpMessage = 'Wildcard CommonName to filter (optional).',
            ParameterSetName = 'Filter')]
        [string] $CommonName,

        [Parameter(
            HelpMessage = 'Wildcard RequesterName to filter (optional).',
            ParameterSetName = 'Filter')]
        [string] $RequesterName,

        [Parameter(
            HelpMessage = 'Wildcard TemplateName to filter (optional).',
            ParameterSetName = 'Filter')]
        [string] $TemplateName
    )

    begin {
        # Load PSPKI and cache all templates in a hashtable for O(1) lookup
        Import-Module PSPKI -ErrorAction Stop
        Write-Verbose "Loading certificate templates..."
        $templateMap = @{}
        Get-CertificateTemplate |
        ForEach-Object { $templateMap[$_.OID.Value] = $_.DisplayName }
    }

    process {
        # Expand and retrieve CA objects
        Write-Verbose "Querying CAs: $($ComputerName -join ', ')"
        $cas = $ComputerName |
        ForEach-Object { Get-CA -ComputerName $_ -ErrorAction Stop }

        # Retrieve all issued requests
        Write-Verbose 'Retrieving issued requests from CAs...'
        $issued = $cas |
        ForEach-Object { Get-IssuedRequest -CertificationAuthority $_ -ErrorAction SilentlyContinue }

        # Early filtering on CommonName (now wildcard)
        if ($PSBoundParameters.ContainsKey('CommonName')) {
            Write-Verbose "Filtering by CommonName -like '$CommonName'"
            $issued = $issued | Where-Object { $_.CommonName -like $CommonName }
        }

        # Early filtering on RequesterName
        if ($PSBoundParameters.ContainsKey('RequesterName')) {
            Write-Verbose "Filtering by RequesterName -like '$RequesterName'"
            $issued = $issued |
            Where-Object { $_.Properties['Request.RequesterName'] -like $RequesterName }
        }

        # Enrich with friendly template name
        $enhanced = $issued |
        Select-Object *,
        @{Name = 'CertificateTemplateName'; Expression = {
                $templateMap[$_.CertificateTemplate] ?? '<Unknown>'
            }
        }

        # Final filtering on TemplateName
        if ($PSBoundParameters.ContainsKey('TemplateName')) {
            Write-Verbose "Filtering by TemplateName -like '$TemplateName'"
            $enhanced = $enhanced |
            Where-Object CertificateTemplateName -like $TemplateName
        }

        # Output the results
        $enhanced
    }

    end {
        Write-Verbose "Completed retrieving issued requests from CAs."
    }
}

