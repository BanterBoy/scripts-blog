---
layout: post
title: Get-Oid.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-oid/
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

This script retrieves information about a specific custom OID object in Active Directory.

#### Detailed Description

This script retrieves information about a specific custom OID object in Active Directory. The script requires the OID to be specified as a parameter. The script will automatically detect the domain's Configuration partition and search for the OID object in the Public Key Services container.

The script will output the DisplayName, Name, and OID value of the specified custom OID object.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-Oid.ps1 -Oid '1.3.6.1.5.5.7.3.2'
```

This example retrieves information about the OID object with the value '1.3.6.1.5.5.7.3.2' in Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.0.1 Creation Date:  February 20, 2025 Last Updated:   February 20, 2025 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    This script retrieves information about a specific custom OID object in Active Directory.

.DESCRIPTION
    This script retrieves information about a specific custom OID object in Active Directory. The script
    requires the OID to be specified as a parameter. The script will automatically detect the domain's Configuration partition
    and search for the OID object in the Public Key Services container.

    The script will output the DisplayName, Name, and OID value of the specified custom OID object.

.PARAMETER Oid
    The custom OID value to search for in Active Directory.

.INPUTS
    None.

.OUTPUTS
    PSCustomObject

.EXAMPLE
    Get-Oid.ps1 -Oid '1.3.6.1.5.5.7.3.2'

    This example retrieves information about the OID object with the value '1.3.6.1.5.5.7.3.2' in Active Directory.

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.0.1
    Creation Date:  February 20, 2025
    Last Updated:   February 20, 2025
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Get-Oid {

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory)]
        [string]$Oid

    )

    Try {
        
        # Import the Active Directory module
        Import-Module ActiveDirectory -ErrorAction Stop

    }

    Catch {

        Write-Error "The Active Directory module is required to run this script. Please ensure the module is installed and available."

        Return

    }
    
    # Automatically detect the domain's Configuration partition
    $RootDSE = Get-ADRootDSE
    $ConfigPartition = $RootDSE.ConfigurationNamingContext

    # Define the base path for the OID container using the detected Configuration partition
    $OidPath = "CN=OID,CN=Public Key Services,CN=Services,$configPartition"

    # Search for the OID object, retrieving only specific properties
    $OidObject = Get-ADObject -Filter { msPKI-Cert-Template-OID -eq $Oid } -SearchBase $OidPath -Properties DisplayName, Name, msPKI-Cert-Template-OID

    # Check if the OID was found and create an output object
    If ($OidObject) {

        # Create a PSCustomObject with the desired properties
        $Result = [PSCustomObject]@{

            DisplayName = $OidObject.DisplayName
            OID         = $OidObject.'msPKI-Cert-Template-OID'
            Name        = $OidObject.Name

        }

        # Output the object
        $Result | Format-List

    }

    Else {

        Write-Warning "OID $Oid not found in the specified path: $OidPath"

    }

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-Oid.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Oid.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

