---
layout: post
title: Find-CertificateByTemplate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/find-certificatebytemplate/
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

Search for certificates in the local computer or current user certificate store that were issued using a specific certificate template.

#### Detailed Description

This script searches the local computer or current user certificate store for certificates that were issued using a specific certificate template. The script enumerates all certificates in the specified certificate store and extracts the certificate template information from each matching certificate.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Find-CertificateByTemplate -Template 'WebServer'
```

This command searches the local computer certificate store for certificates that were issued using the 'WebServer' certificate template.

**Example 2**

```powershell
Find-CertificateByTemplate -Template 'User Authentication' -User
```

This command searches the current user certificate store for certificates that were issued using the 'User Authentication' certificate template.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.0.1 Creation Date:  March 29, 2024 Last Updated:   March 29, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Search for certificates in the local computer or current user certificate store that were issued using a specific certificate template.

.PARAMETER Template
    The name of the certificate template to search for.

.PARAMETER User
    Indicates that the search should be performed in the current user certificate store. By default, the search is performed in the local computer certificate store.

.EXAMPLE
    Find-CertificateByTemplate -Template 'WebServer'

    This command searches the local computer certificate store for certificates that were issued using the 'WebServer' certificate template.

.EXAMPLE
    Find-CertificateByTemplate -Template 'User Authentication' -User

    This command searches the current user certificate store for certificates that were issued using the 'User Authentication' certificate template.

.DESCRIPTION
    This script searches the local computer or current user certificate store for certificates that were issued using a specific certificate template. The script enumerates all certificates in the specified certificate store and extracts the certificate template information from each matching certificate.

.LINK
    https://github.com/richardhicks/adcstools/functions/Find-CertificateByTemplate.ps1

.NOTES
    Version:        1.0.1
    Creation Date:  March 29, 2024
    Last Updated:   March 29, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Find-CertificateByTemplate {

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory, HelpMessage = 'Enter the name of the certificate template or a keyword to search for.')]
        [ValidateNotNullOrEmpty()]
        # Ensure string does not contain a wild card
        [ValidatePattern('^[^*?]+$')]
        [string]$Template,
        [switch]$User

    )

    If ($User) {

        Write-Verbose 'Enumerating certificates from the current user certificate store...'
        $Certificates = Get-ChildItem -Path Cert:\CurrentUser\My

    }

    Else {

        Write-Verbose 'Enumerating certificates from the local computer certificate store...'
        $Certificates = Get-ChildItem -Path Cert:\LocalMachine\My

    }

    $Certificates | ForEach-Object {

        $Certificate = $_
        $TemplateInfo = $Certificate.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Certificate Template Information" } | ForEach-Object { $_.Format(0) }

        # Check if the template information matches the desired template name
        If ($TemplateInfo -match $Template) {

            [PSCustomObject]@{

                Subject             = $Certificate.Subject
                Issuer              = $Certificate.Issuer -Replace '(CN=[^,]+).*$', '$1'
                Thumbprint          = $Certificate.Thumbprint
                TemplateInformation = $TemplateInfo -Replace '^Template=', ''

            }

        }

    } | Format-List

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Find-CertificateByTemplate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Find-CertificateByTemplate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

