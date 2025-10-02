---
layout: post
title: Get-ComputersWithoutBitLocker.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-computerswithoutbitlocker/
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

Retrieves a list of computers in Active Directory that do not have associated BitLocker recovery information.

#### Detailed Description

The `Get-ComputersWithoutBitLocker` function queries Active Directory for computer objects and checks if they have associated BitLocker recovery information. It can optionally filter out disabled computers using the `-Enabled` switch. The function outputs a list of computers without BitLocker recovery information, including their names, distinguished names, and enabled status.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ComputersWithoutBitLocker
```

Retrieves all computers in the domain that do not have BitLocker recovery information.

**Example 2**

```powershell
Get-ComputersWithoutBitLocker -SearchBase "OU=Computers,DC=example,DC=com"
```

Retrieves all computers in the specified organizational unit (OU) that do not have BitLocker recovery information.

**Example 3**

```powershell
Get-ComputersWithoutBitLocker -Enabled
```

Retrieves only enabled computers in the domain that do not have BitLocker recovery information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: [Your Name] Date: April 17, 2025 Version: 1.0

This function requires the Active Directory module to be installed and imported. It also requires appropriate permissions to query Active Directory and access BitLocker recovery information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Retrieves a list of computers in Active Directory that do not have associated BitLocker recovery information.

.DESCRIPTION
    The `Get-ComputersWithoutBitLocker` function queries Active Directory for computer objects and checks if they have associated BitLocker recovery information. 
    It can optionally filter out disabled computers using the `-Enabled` switch. The function outputs a list of computers without BitLocker recovery information, 
    including their names, distinguished names, and enabled status.

.PARAMETER SearchBase
    Specifies the Active Directory search base for the query. By default, it uses the distinguished name of the current domain.

.PARAMETER Enabled
    Filters the results to include only enabled computers. Disabled computers are skipped when this switch is specified.

.EXAMPLE
    Get-ComputersWithoutBitLocker

    Retrieves all computers in the domain that do not have BitLocker recovery information.

.EXAMPLE
    Get-ComputersWithoutBitLocker -SearchBase "OU=Computers,DC=example,DC=com"

    Retrieves all computers in the specified organizational unit (OU) that do not have BitLocker recovery information.

.EXAMPLE
    Get-ComputersWithoutBitLocker -Enabled

    Retrieves only enabled computers in the domain that do not have BitLocker recovery information.

.NOTES
    Author: [Your Name]
    Date: April 17, 2025
    Version: 1.0

    This function requires the Active Directory module to be installed and imported. 
    It also requires appropriate permissions to query Active Directory and access BitLocker recovery information.

.OUTPUTS
    PSCustomObject
        A custom object with the following properties:
        - ComputerName: The name of the computer.
        - DistinguishedName: The distinguished name of the computer in Active Directory.
        - Enabled: Indicates whether the computer is enabled.
        - Notes: Additional information (e.g., "No BitLocker recovery information found").

#>
#requires -PSEdition Desktop

function Get-ComputersWithoutBitLocker {
    [CmdletBinding()]
    param(
        [string]$SearchBase = (Get-ADDomain).DistinguishedName,
        [switch]$Enabled
    )
    begin {
        Write-Verbose "Starting Get-ComputersWithoutBitLocker function"
        $results = @()
    }
    process {
        try {
            # Retrieve all computer objects in the domain
            Write-Verbose "Querying all computer objects in Active Directory"
            $computers = Get-ADComputer -Filter * -SearchBase $SearchBase -Properties DistinguishedName, Enabled -ErrorAction Stop

            foreach ($computer in $computers) {
                $computerName = $computer.Name
                $distinguishedName = $computer.DistinguishedName
                $isEnabled = $computer.Enabled

                # Skip disabled computers if the Enabled switch is specified
                if ($Enabled -and -not $isEnabled) {
                    Write-Verbose "Skipping disabled computer: $computerName"
                    continue
                }

                Write-Verbose "Checking BitLocker recovery information for computer: $computerName"

                try {
                    # Check if the computer has any associated BitLocker recovery information
                    $bitLockerData = Get-ADObject -Filter 'objectclass -eq "msFVE-RecoveryInformation"' -SearchBase $distinguishedName -ErrorAction Stop

                    if (-not $bitLockerData) {
                        # If no BitLocker recovery information is found, add the computer to the results
                        $results += [PSCustomObject]@{
                            ComputerName      = $computerName
                            DistinguishedName = $distinguishedName
                            Enabled           = $isEnabled
                            Notes             = "No BitLocker recovery information found"
                        }
                    }
                }
                catch {
                    Write-Warning "Failed to check BitLocker recovery information for computer '$computerName': $_"
                }
            }
        }
        catch {
            Write-Warning "Failed to retrieve computer objects from Active Directory: $_"
        }
    }
    end {
        if ($results.Count -eq 0) {
            Write-Warning "No computers without BitLocker recovery information were found."
        }
        else {
            Write-Verbose "Returning results"
            $results | Sort-Object -Property ComputerName | Write-Output
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ComputersWithoutBitLocker.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ComputersWithoutBitLocker.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

