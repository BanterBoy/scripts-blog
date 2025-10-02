---
layout: post
title: Show-CertificateTemplateInformation.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/show-certificatetemplateinformation/
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

Display information about certificates in the local computer or current user certificate store.

#### Detailed Description

This script enumerates certificates from the local computer or current user certificate store and displays information about the certificate template used to issue the certificate. Certificates from the local computer certificate store are dispalyed by default. Use the -User switch to enumerate certificates from the current user certificate store instead.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Show-CertificateTemplateInformation
```

Enumerates certificates from the local computer certificate store and displays template information.

**Example 2**

```powershell
Show-CertificateTemplateInformation -User
```

Enumerates certificates from the current user certificate store and displays template information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.0 Creation Date:  March 29, 2024 Last Updated:   March 29, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Display information about certificates in the local computer or current user certificate store.

.PARAMETER User
    Indicates that the search should be performed in the current user certificate store. By default, the search is performed in the local computer certificate store.

.EXAMPLE
    Show-CertificateTemplateInformation

    Enumerates certificates from the local computer certificate store and displays template information.

.EXAMPLE
    Show-CertificateTemplateInformation -User

    Enumerates certificates from the current user certificate store and displays template information.

.DESCRIPTION
    This script enumerates certificates from the local computer or current user certificate store and displays information about the certificate template used to issue the certificate. Certificates from the local computer certificate store are dispalyed by default. Use the -User switch to enumerate certificates from the current user certificate store instead.

.LINK
    https://github.com/richardhicks/adcstools/functions/Show-CertificateTemplateInformation.ps1

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.0
    Creation Date:  March 29, 2024
    Last Updated:   March 29, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Show-CertificateTemplateInformation {

    [CmdletBinding()]

    Param (

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

    # Get all certificates from the specified certificate store and display their template information
    Write-Verbose 'Searching for certificate template information...'
    $Certificates | ForEach-Object {

        $Certificate = $_
        $TemplateInfo = $Certificate.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Certificate Template Information" } |

        ForEach-Object { $_.Format(0) }

        [PSCustomObject]@{

            Subject             = $Certificate.Subject
            Issuer              = $Certificate.Issuer -Replace '(CN=[^,]+).*$', '$1'
            Thumbprint          = $Certificate.Thumbprint
            TemplateInformation = $TemplateInfo -Replace '^Template=', ''

        }

    } | Format-List

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Show-CertificateTemplateInformation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Show-CertificateTemplateInformation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

