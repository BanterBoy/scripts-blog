---
layout: post
title: gPLink_Report.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
<##############################################################################
Ashley McGlone
Microsoft Premier Field Engineer
May 2013
http://aka.ms/GoateePFE

This script creates a report of all group policy links, their locations, and
their configurations in the current domain.  Output is a CSV file.

For more information on gPLink, gPOptions, and gPLinkOptions see:
 [MS-GPOL]: Group Policy: Core Protocol
  http://msdn.microsoft.com/en-us/library/cc232478.aspx
 2.2.2 Domain SOM Search
  http://msdn.microsoft.com/en-us/library/cc232505.aspx
 2.3 Directory Service Schema Elements
  http://msdn.microsoft.com/en-us/library/cc422909.aspx
 3.2.5.1.5 GPO Search
  http://msdn.microsoft.com/en-us/library/cc232537.aspx

SOM is an acronym for Scope of Management, referring to any location where
a group policy could be linked: domain, OU, site.

NOTE: This GPO report does not list GPO filtering by permissions.

Requires:
-PowerShell v2 or above
-RSAT
-AD PowerShell module
-Group Policy module

LEGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code.

This posting is provided "AS IS" with no warranties, and confers no rights. Use
of included script samples are subject to the terms specified
at http://www.microsoft.com/info/cpyright.htm.
##############################################################################>

# Import the module goodness
# Requires RSAT installed and features enabled
Import-Module GroupPolicy
Import-Module ActiveDirectory

# Grab a list of all GPOs
$GPOs = Get-GPO -All | Select-Object ID, Path, DisplayName, GPOStatus, WMIFilter

# Create a hash table for fast GPO lookups later in the report.
# Hash table key is the policy path which will match the gPLink attribute later.
# Hash table value is the GPO object with properties for reporting.
$GPOsHash = @{}
ForEach ($GPO in $GPOs) {
    $GPOsHash.Add($GPO.Path, $GPO)
}

# Empty array to hold all possible GPO link SOMs
$gPLinks = @()

# GPOs linked to the root of the domain
#  !!! Get-ADDomain does not return the gPLink attribute
$gPLinks += `
    Get-ADObject -Identity (Get-ADDomain).distinguishedName -Properties name, distinguishedName, gPLink, gPOptions |
Select-Object name, distinguishedName, gPLink, gPOptions, @{name = 'Depth'; expression = { 0 } }

# GPOs linked to OUs
#  !!! Get-GPO does not return the gPLink attribute
# Calculate OU depth for graphical representation in final report
$gPLinks += `
    Get-ADOrganizationalUnit -Filter * -Properties name, distinguishedName, gPLink, gPOptions |
Select-Object name, distinguishedName, gPLink, gPOptions, @{name = 'Depth'; expression = { ($_.distinguishedName -split 'OU=').count - 1 } }

# GPOs linked to sites
$gPLinks += `
    Get-ADObject -LDAPFilter '(objectClass=site)' -SearchBase "CN=Sites,$((Get-ADRootDSE).configurationNamingContext)" -SearchScope OneLevel -Properties name, distinguishedName, gPLink, gPOptions |
Select-Object name, distinguishedName, gPLink, gPOptions, @{name = 'Depth'; expression = { 0 } }

# Empty report array
$report = @()

# Loop through all possible GPO link SOMs collected
foreach ($SOM in $gPLinks) {
    # Filter out policy SOMs that have a policy linked
    if ($SOM.gPLink) {
        # If an OU has 'Block Inheritance' set (gPOptions=1) and no GPOs linked,
        # then the gPLink attribute is no longer null but a single space.
        # There will be no gPLinks to parse, but we need to list it with BlockInheritance.
        if ($SOM.gPLink.length -gt 1) {
            # Use @() for force an array in case only one object is returned (limitation in PS v2)
            # Example gPLink value:
            #   [LDAP://cn={7BE35F55-E3DF-4D1C-8C3A-38F81F451D86},cn=policies,cn=system,DC=wingtiptoys,DC=local;2][LDAP://cn={046584E4-F1CD-457E-8366-F48B7492FBA2},cn=policies,cn=system,DC=wingtiptoys,DC=local;0][LDAP://cn={12845926-AE1B-49C4-A33A-756FF72DCC6B},cn=policies,cn=system,DC=wingtiptoys,DC=local;1]
            # Split out the links enclosed in square brackets, then filter out
            # the null result between the closing and opening brackets ][
            $links = @($SOM.gPLink -split { $_ -eq '[' -or $_ -eq ']' } | Where-Object { $_ })
            # Use a for loop with a counter so that we can calculate the precedence value
            for ( $i = $links.count - 1 ; $i -ge 0 ; $i-- ) {
                # Example gPLink individual value (note the end of the string):
                #   LDAP://cn={7BE35F55-E3DF-4D1C-8C3A-38F81F451D86},cn=policies,cn=system,DC=wingtiptoys,DC=local;2
                # Splitting on '/' and ';' gives us an array every time like this:
                #   0: LDAP:
                #   1: (null value between the two //)
                #   2: distinguishedName of policy
                #   3: numeric value representing gPLinkOptions (LinkEnabled and Enforced)
                $GPOData = $links[$i] -split { $_ -eq '/' -or $_ -eq ';' }
                # Add a new report row for each GPO link
                $report += New-Object -TypeName PSCustomObject -Property @{
                    Depth             = $SOM.Depth;
                    Name              = $SOM.Name;
                    DistinguishedName = $SOM.distinguishedName;
                    PolicyDN          = $GPOData[2];
                    Precedence        = $links.count - $i
                    GUID              = "{$($GPOsHash[$($GPOData[2])].ID)}";
                    DisplayName       = $GPOsHash[$GPOData[2]].DisplayName;
                    GPOStatus         = $GPOsHash[$GPOData[2]].GPOStatus;
                    WMIFilter         = $GPOsHash[$GPOData[2]].WMIFilter.Name;
                    Config            = $GPOData[3];
                    LinkEnabled       = [bool](!([int]$GPOData[3] -band 1));
                    Enforced          = [bool]([int]$GPOData[3] -band 2);
                    BlockInheritance  = [bool]($SOM.gPOptions -band 1)
                } # End Property hash table
            } # End For
        }
        else {
            # BlockInheritance but no gPLink
            $report += New-Object -TypeName PSCustomObject -Property @{
                Depth             = $SOM.Depth;
                Name              = $SOM.Name;
                DistinguishedName = $SOM.distinguishedName;
                BlockInheritance  = [bool]($SOM.gPOptions -band 1)
            }
        } # End If
    }
    else {
        # No gPLink at this SOM
        $report += New-Object -TypeName PSCustomObject -Property @{
            Depth             = $SOM.Depth;
            Name              = $SOM.Name;
            DistinguishedName = $SOM.distinguishedName;
            BlockInheritance  = [bool]($SOM.gPOptions -band 1)
        }
    } # End If
} # End ForEach

# Output the results to CSV file for viewing in Excel
$report |
Select-Object @{name = 'SOM'; expression = { $_.name.PadLeft($_.name.length + ($_.depth * 5), '_') } }, `
    DistinguishedName, BlockInheritance, LinkEnabled, Enforced, Precedence, `
    DisplayName, GPOStatus, WMIFilter, GUID, PolicyDN |
Export-CSV .\gPLink_Report.csv -NoTypeInformation

<#########################################################################sdg#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/gPLink_Report.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=gPLink_Report.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
