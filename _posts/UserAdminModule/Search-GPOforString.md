---
layout: post
title: Search-GPOforString.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/search-gpoforstring/
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

Searches all Group Policy Objects (GPOs) in the current user's domain for a specified string.

#### Detailed Description

This function searches all GPOs in the current user's domain for a specified string. It uses the Get-GPOReport cmdlet to retrieve the XML report for each GPO, and then searches the report for the specified string using regular expressions. If a match is found, the function outputs a custom object with the name of the matching GPO and the search string.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Search-GPOsForString -SearchText "password"
```

This example searches all GPOs in the current user's domain for the string "password".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Import-Module GroupPolicy -SkipEditionCheck

function Search-GPOsForString {
    <#
    .SYNOPSIS
        Searches all Group Policy Objects (GPOs) in the current user's domain for a specified string.

    .DESCRIPTION
        This function searches all GPOs in the current user's domain for a specified string. It uses the Get-GPOReport cmdlet to retrieve the XML report for each GPO, and then searches the report for the specified string using regular expressions. If a match is found, the function outputs a custom object with the name of the matching GPO and the search string.

    .PARAMETER SearchText
        The string to search for in the GPOs.

    .EXAMPLE
        Search-GPOsForString -SearchText "password"
        This example searches all GPOs in the current user's domain for the string "password".

    .NOTES
        Author: Luke Leigh
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the string to search for in the GPOs')]
        [string]$SearchText
    )

    # Get the domain name from the environment variable
    $DomainName = $env:USERDNSDOMAIN
    Write-Verbose "Domain Name: $DomainName"

    # Get all GPOs in the domain
    Write-Verbose "Retrieving all GPOs in the domain..."
    $allGposInDomain = Get-GPO -All -Domain $DomainName
    $totalGpos = $allGposInDomain.Count
    Write-Verbose "Total GPOs retrieved: $totalGpos"

    # Initialize the current GPO counter
    $currentGpo = 0

    # Loop through each GPO
    foreach ($gpo in $allGposInDomain) {
        # Increment the current GPO counter
        $currentGpo++

        # Check if the GPO ID is not null
        if ($null -ne $gpo.Id) {
            Write-Verbose "Processing GPO: $($gpo.DisplayName) (ID: $($gpo.Id))"

            # Get the GPO report in XML format
            try {
                $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml -ErrorAction Stop
                Write-Verbose "GPO report retrieved successfully."
            }
            catch {
                Write-Warning "Failed to retrieve report for GPO: $($gpo.DisplayName). Skipping this GPO."
                continue
            }

            # Check if the report matches the search text
            if ($report -match ([regex]::Escape("$SearchText"))) {
                Write-Verbose "Match found in GPO: $($gpo.DisplayName)"

                # Create a custom object with the GPO name and the match
                $result = [PSCustomObject]@{
                    'GPOName' = $gpo.DisplayName
                    'Match'   = $SearchText
                }

                # Output the result
                Write-Output $result
            }
        }

        # Update the progress bar
        Write-Progress -Activity "Searching GPOs" -Status "$currentGpo of $totalGpos GPOs searched" -PercentComplete (($currentGpo / $totalGpos) * 100)
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Search-GPOforString.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Search-GPOforString.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

