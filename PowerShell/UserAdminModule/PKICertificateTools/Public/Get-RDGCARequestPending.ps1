<#
.SYNOPSIS
    Retrieves pending certificate requests from one or more CAs with optional filters.

.DESCRIPTION
    Connects to specified Certification Authorities using PSPKI, retrieves all pending
    certificate requests, enriches each record with a friendly Certificate Template
    name, and applies optional filters on CommonName, Request.RequesterName, and
    CertificateTemplateName.

.PARAMETER ComputerName
    One or more CA hostnames (supports wildcard) to query. Defaults to 'rdglonaldppk00*'.

.PARAMETER CommonName
    Wildcard pattern to match the Subject (CommonName) property. e.g. '*Luke*'.

.PARAMETER RequesterName
    Wildcard pattern to match the Request.RequesterName property. e.g. 'RDG\Luke*'.

.PARAMETER TemplateName
    Wildcard pattern to match the friendly CertificateTemplateName. e.g. '*WinRM*'.

.EXAMPLE
    # Retrieve all pending requests from all rdglonaldppk00* CAs
    Get-RDGCARequestPending

.EXAMPLE
    # Filter by subject/common name
    Get-RDGCARequestPending -CommonName 'RDGLT3230*'

.EXAMPLE
    # Filter by requester
    Get-RDGCARequestPending -RequesterName 'RDG\Luke*'

.EXAMPLE
    # Filter by certificate template display name
    Get-RDGCARequestPending -TemplateName '*WinRM*'

.EXAMPLE
    # Combine filters against two specific CAs
    Get-RDGCARequestPending `
      -ComputerName rdglonaldppk001,rdglonaldppk002 `
      -CommonName 'RDGLT3230.rdg.co.uk' `
      -RequesterName 'RDG\RDGLT*' `
      -TemplateName '*WinRM*'

.NOTES
    Requires the PSPKI module to be installed and network access to the target CAs.
#>
function Get-RDGCARequestPending {
    [CmdletBinding()]
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

        [Parameter(HelpMessage = 'Wildcard CommonName (Subject) to filter (optional).')]
        [string] $CommonName,

        [Parameter(HelpMessage = 'Wildcard RequesterName to filter (optional).')]
        [string] $RequesterName,

        [Parameter(HelpMessage = 'Wildcard TemplateName to filter (optional).')]
        [string] $TemplateName
    )

    begin {
        Import-Module PSPKI -ErrorAction Stop
        Write-Verbose "Loading certificate templates..."
        $templateMap = @{ }
        Get-CertificateTemplate |
        ForEach-Object { $templateMap[$_.OID.Value] = $_.DisplayName }
    }

    process {
        Write-Verbose "Querying CAs: $($ComputerName -join ', ')"
        $cas = $ComputerName |
        ForEach-Object { Get-CA -ComputerName $_ -ErrorAction Stop }

        Write-Verbose 'Retrieving pending requests from CAs...'
        $pending = $cas |
        ForEach-Object { Get-PendingRequest -CertificationAuthority $_ -ErrorAction SilentlyContinue }

        if ($PSBoundParameters.ContainsKey('CommonName')) {
            Write-Verbose "Filtering by CommonName -like '$CommonName'"
            $pending = $pending | Where-Object { $_.CommonName -like $CommonName }
        }
        if ($PSBoundParameters.ContainsKey('RequesterName')) {
            Write-Verbose "Filtering by RequesterName -like '$RequesterName'"
            $pending = $pending |
            Where-Object { $_.Properties['Request.RequesterName'] -like $RequesterName }
        }

        $enhanced = $pending | Select-Object *,
        @{Name = 'CertificateTemplateName'; Expression = {
                $templateMap[$_.CertificateTemplate] ?? '<Unknown>'
            }
        }

        if ($PSBoundParameters.ContainsKey('TemplateName')) {
            Write-Verbose "Filtering by TemplateName -like '$TemplateName'"
            $enhanced = $enhanced | Where-Object CertificateTemplateName -like $TemplateName
        }

        $enhanced
    }
    end {
        Write-Verbose "Completed retrieving pending requests from CAs."
    }
}