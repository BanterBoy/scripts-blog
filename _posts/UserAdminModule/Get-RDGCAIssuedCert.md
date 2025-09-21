---
layout: post
title: Get-RDGCAIssuedCert.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-rdgcaissuedcert/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Retrieves issued certificates from one or more CAs with optional filters.

#### Detailed Description

Connects to specified Certification Authorities using PSPKI, retrieves all issued certificate requests, enriches each record with a friendly Certificate Template name, and applies optional filters on CommonName, Request.RequesterName, and CertificateTemplateName.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Retrieve all issued certificates from all rdglonaldppk00* CAs
```

Get-RDGCAIssuedCert

**Example 2**

```powershell
# Filter by Exact CommonName
```

Get-RDGCAIssuedCert -CommonName 'RDGLT3230'

**Example 3**

```powershell
# Filter by RequesterName wildcard
```

Get-RDGCAIssuedCert -RequesterName 'RDG\Luke*'

**Example 4**

```powershell
# Filter by Certificate Template display name
```

Get-RDGCAIssuedCert -TemplateName '*WinRM*'

**Example 5**

```powershell
# Combine filters
```

Get-RDGCAIssuedCert -ComputerName 'rdglonaldppk001','rdglonaldppk002' ` -CommonName 'RDGLT3230.rdg.co.uk' ` -RequesterName 'RDG\RDGLT*' ` -TemplateName '*WinRM*'

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires the PSPKI module to be installed and network access to the target CAs.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-RDGCAIssuedCert.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDGCAIssuedCert.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

