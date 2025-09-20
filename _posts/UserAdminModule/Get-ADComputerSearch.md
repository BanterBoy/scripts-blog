---
layout: post
title: Get-ADComputerSearch.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/get-adcomputersearch/
categories:
  - UserAdminModule
  - ADFunctions
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-ADComputerSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Filter = '*',

        [Parameter(Mandatory = $false)]
        [string]$OperatingSystem,

        [Parameter(Mandatory = $false)]
        [string]$SearchBase, # Optional SearchBase

        [Parameter(Mandatory = $false)]
        [switch]$IncludeDisabled, # Include disabled computers

        [Parameter(Mandatory = $false)]
        [switch]$IncludeAdditionalProperties, # Retrieve all AD properties

        [Parameter(Mandatory = $false)]
        [ValidateSet("Name", "OperatingSystem", "LastLogonDate", "PasswordLastSet")]
        [string]$SortBy = "Name" # Sorting option
    )

    PROCESS {
        try {
            # Define properties to retrieve
            $properties = @(
                "Name", "Description", "SamAccountName", "OperatingSystem", "OperatingSystemVersion", "PasswordLastSet",
                "LastLogonDate", "ManagedBy", "DNSHostName", "IPv4Address", 
                "IPv6Address", "ServicePrincipalName", "Enabled"
            )

            if ($IncludeAdditionalProperties) {
                $properties += "*"
            }

            # Construct proper AD query filter
            $filterCondition = "(Name -like '$Filter')"

            if (-not $IncludeDisabled) {
                $filterCondition += " -and (Enabled -eq '$true')"
            }

            # Add Operating System filtering if specified
            if ($OperatingSystem) {
                $filterCondition += " -and (OperatingSystem -like '*$OperatingSystem*')"
            }

            Write-Verbose "Using AD filter: $filterCondition"

            # Perform AD query with or without SearchBase
            if ($SearchBase) {
                $computers = Get-ADComputer -Filter $filterCondition -SearchBase $SearchBase -Properties $properties
            }
            else {
                $computers = Get-ADComputer -Filter $filterCondition -Properties $properties
            }

            if (!$computers) {
                Throw "No computers found matching the criteria."
            }

            # Process results
            $output = foreach ($computerInfo in $computers) {
                [PSCustomObject]@{
                    Name                   = $computerInfo.Name
                    Description            = $computerInfo.Description
                    DNSHostName            = $computerInfo.DNSHostName
                    SamAccountName         = $computerInfo.SamAccountName
                    IPv4Address            = $computerInfo.IPv4Address
                    IPv6Address            = $computerInfo.IPv6Address
                    OperatingSystem        = $computerInfo.OperatingSystem
                    OperatingSystemVersion = $computerInfo.OperatingSystemVersion
                    PasswordLastSet        = $computerInfo.PasswordLastSet
                    LastLogonDate          = $computerInfo.LastLogonDate
                    ManagedBy              = $computerInfo.ManagedBy
                    ServicePrincipalName   = $computerInfo.ServicePrincipalName -join ", " # Join SPNs into a single string
                    Enabled                = $computerInfo.Enabled
                }
            }

            # Sort results
            if ($SortBy) {
                $output = $output | Sort-Object -Property $SortBy
            }

            # Output final results
            return $output

        }
        catch {
            Write-Error "Error retrieving computer information: $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADComputerSearch.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADComputerSearch.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

