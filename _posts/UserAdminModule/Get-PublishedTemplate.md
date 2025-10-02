---
layout: post
title: Get-PublishedTemplate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-publishedtemplate/
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

Retrieve a list of certificate templates published in Active Directory Certificate Services (AD CS).

#### Detailed Description

This function retrieves a list of certificate templates published in Active Directory Certificate Services. The output is a table that lists each certificate template and the enrollment servers that have published it.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-PublishedTemplate
```

This command retrieves a list of certificate templates published in Active Directory Certificate Services.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.1 Creation Date:  February 21, 2024 Last Updated:   February 29, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Retrieve a list of certificate templates published in Active Directory Certificate Services (AD CS).

.EXAMPLE
    Get-PublishedTemplate

    This command retrieves a list of certificate templates published in Active Directory Certificate Services.

.DESCRIPTION
    This function retrieves a list of certificate templates published in Active Directory Certificate Services. The output is a table that lists each certificate template and the enrollment servers that have published it.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Get-PublishedTemplate.ps1

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.1
    Creation Date:  February 21, 2024
    Last Updated:   February 29, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Get-PublishedTemplate {

    [CmdletBinding()]

    Param (

    )

    # Retrieve the PKI container DN
    Write-Verbose 'Retrieving PKI container DN...'
    $PkiContainerDN = "CN=Public Key Services,CN=Services,$((Get-ADRootDSE).ConfigurationNamingContext)"
    Write-Verbose "PKI container DN is $PkiContainerDN."

    # Retrieve the enrollment servers and the certificate templates they have published
    Write-Verbose 'Retrieving enrollment servers and published certificate templates...'
    $EnrollmentServers = Get-ADObject -Filter { ObjectClass -eq "PkiEnrollmentService" } -SearchBase $PkiContainerDN -Properties * | Sort-Object DnsHostName

    # Retrieve the list of published certificate templates
    Write-Verbose 'Retrieving published certificate templates...'
    $PublishedTemplates = $EnrollmentServers | ForEach-Object { $_.CertificateTemplates } | Sort-Object -Unique

    # Create a custom object to store the results
    $PublishedTemplates  | ForEach-Object {

        $Obj = [PSCustomObject] @{

            Template = $_

        }

        ForEach ($CA in $EnrollmentServers) {

            $Obj | Add-Member NoteProperty $CA.DnsHostName -Value ($CA.CertificateTemplates -Contains $Obj.Template)

        }

        # Output the results to the console
        $Obj

    }

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-PublishedTemplate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PublishedTemplate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

