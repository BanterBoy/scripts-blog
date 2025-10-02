---
layout: post
title: Get-AdCertificateTemplate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-adcertificatetemplate/
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

Retrieve all certificate templates from Active Directory and display their names and OIDs.

#### Detailed Description

This function retrieves all certificate templates from Active Directory and displays their names and OIDs, which can be helpful for troubleshooting certificate enrollment issues. The function uses the Get-ADObject cmdlet to retrieve all objects from the Certificate Templates container in the Configuration partition of Active Directory. It then loops through each object and creates a custom object for each template, storing the template name and OID. The custom objects are then sorted alphabetically by template name and output to the console.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-AdCertificateTemplate
```

This command retrieves all certificate templates from Active Directory and displays their names and OIDs.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.0.1 Creation Date:  February 29, 2024 Last Updated:   May 7, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Retrieve all certificate templates from Active Directory and display their names and OIDs.

.EXAMPLE
    Get-AdCertificateTemplate

    This command retrieves all certificate templates from Active Directory and displays their names and OIDs.

.DESCRIPTION
    This function retrieves all certificate templates from Active Directory and displays their names and OIDs, which can be helpful for troubleshooting certificate enrollment issues. The function uses the Get-ADObject cmdlet to retrieve all objects from the Certificate Templates container in the Configuration partition of Active Directory. It then loops through each object and creates a custom object for each template, storing the template name and OID. The custom objects are then sorted alphabetically by template name and output to the console.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Get-AdCertificateTemplate.ps1

.NOTES
    Version:        1.0.1
    Creation Date:  February 29, 2024
    Last Updated:   May 7, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>
Function Get-AdCertificateTemplate {

    [CmdletBinding()]

    Param (

    )

    # Specify the distinguished name of the Certificate Templates container
    $PkiContainerDN = "CN=Certificate Templates,CN=Public Key Services,CN=Services,$((Get-ADRootDSE).ConfigurationNamingContext)"
    Write-Verbose "Container path is: $PkiContainerDN."

    # Retrieve all objects from the Certificate Templates container
    $TemplateObjects = Get-ADObject -SearchBase $PkiContainerDN -Filter * -Properties msPKI-Cert-Template-OID, Name, DisplayName

    # Create an array to store the objects
    $Templates = @()

    # Loop through each template object and create custom objects
    ForEach ($TemplateObject in $TemplateObjects) {

        # Create a custom object for each template
        $TemplateInfo = [PSCustomObject]@{

            TemplateName = $TemplateObject.Name
            TemplateDisplayName = $TemplateObject.DisplayName
            TemplateOID  = $TemplateObject.'msPKI-Cert-Template-OID'

        }

        # Add the custom object to the array
        $Templates += $TemplateInfo

    }

    # Sort the array of custom objects by TemplateName alphabetically
    $Templates = $Templates | Sort-Object TemplateName

    # Output the sorted array of custom objects
    Return $Templates

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-AdCertificateTemplate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AdCertificateTemplate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

