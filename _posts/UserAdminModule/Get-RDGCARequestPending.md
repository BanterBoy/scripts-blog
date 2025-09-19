---
layout: post
title: Get-RDGCARequestPending.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RDGCARequestPending/
categories:
  - UserAdminModule
  - PKICertificateTools
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

Retrieves pending certificate requests from one or more CAs with optional filters.

#### Detailed Description

Connects to specified Certification Authorities using PSPKI, retrieves all pending certificate requests, enriches each record with a friendly Certificate Template name, and applies optional filters on CommonName, Request.RequesterName, and CertificateTemplateName.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Retrieve all pending requests from all rdglonaldppk00* CAs
```

Get-RDGCARequestPending

**Example 2**

```powershell
# Filter by subject/common name
```

Get-RDGCARequestPending -CommonName 'RDGLT3230*'

**Example 3**

```powershell
# Filter by requester
```

Get-RDGCARequestPending -RequesterName 'RDG\Luke*'

**Example 4**

```powershell
# Filter by certificate template display name
```

Get-RDGCARequestPending -TemplateName '*WinRM*'

**Example 5**

```powershell
# Combine filters against two specific CAs
```

Get-RDGCARequestPending ` -ComputerName rdglonaldppk001,rdglonaldppk002 ` -CommonName 'RDGLT3230.rdg.co.uk' ` -RequesterName 'RDG\RDGLT*' ` -TemplateName '*WinRM*'

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires the PSPKI module to be installed and network access to the target CAs.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-RDGCARequestPending.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDGCARequestPending.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

