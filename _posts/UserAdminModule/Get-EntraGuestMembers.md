---
layout: post
title: Get-EntraGuestMembers.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/azure/get-entraguestmembers/
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

Retrieves all guest user accounts from Microsoft Entra ID.

#### Detailed Description

The Get-EntraGuestMembers function queries Microsoft Entra ID (Azure AD) using the Microsoft Graph PowerShell SDK to return all guest users and their personally identifiable information (PII) attributes. The returned objects can be piped to other commands for further processing.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-EntraGuestMembers
```

Retrieves all guest users from Microsoft Entra ID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves all guest user accounts from Microsoft Entra ID.
.DESCRIPTION
The Get-EntraGuestMembers function queries Microsoft Entra ID (Azure AD)
using the Microsoft Graph PowerShell SDK to return all guest users and
their personally identifiable information (PII) attributes. The
returned objects can be piped to other commands for further processing.
.EXAMPLE
Get-EntraGuestMembers
Retrieves all guest users from Microsoft Entra ID.
.OUTPUTS
System.Management.Automation.PSCustomObject[]
#>

function Get-EntraGuestMembers {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [string] $UserPrincipalName,

        [Parameter(Position=1, ValueFromPipelineByPropertyName=$true)]
        [string] $Id,

        [Parameter(Position=2)]
        [string] $ExternalEmail,

        [Parameter(Position=3)]
        [string] $ExportPath,

        [Parameter(Position=4)]
        [ValidateSet('Csv','Json')]
        [string] $ExportFormat = 'Csv'
    )

    process {
        $properties = @(
            'id',
            'displayName',
            'givenName',
            'surname',
            'userPrincipalName',
            'mail',
            'otherMails',
            'proxyAddresses',
            'mobilePhone',
            'businessPhones',
            'jobTitle',
            'companyName',
            'department',
            'streetAddress',
            'city',
            'state',
            'postalCode',
            'country',
            'accountEnabled',
            'creationType',
            'externalUserState',
            'identities'
        )

        try {
            if ($UserPrincipalName) {
                $filter = "userType eq 'Guest' and userPrincipalName eq '$UserPrincipalName'"
            } elseif ($Id) {
                $filter = "userType eq 'Guest' and id eq '$Id'"
            } else {
                $filter = "userType eq 'Guest'"
            }

            if ($PSCmdlet.ShouldProcess("Entra Guest Members", "Get guest users with filter: $filter")) {
                $guests = Get-MgUser -Filter $filter -All -Property $properties |
                    Select-Object -Property $properties

                # If searching by external email, filter results in memory
                if ($ExternalEmail) {
                    $guests = $guests | Where-Object {
                        $_.mail -eq $ExternalEmail -or ($_.otherMails -contains $ExternalEmail)
                    }
                }

                if ($ExportPath) {
                    switch ($ExportFormat) {
                        'Csv' {
                            $guests | Export-Csv -Path $ExportPath -NoTypeInformation -Force
                            Write-Verbose "Exported guest users to CSV: $ExportPath"
                        }
                        'Json' {
                            $guests | ConvertTo-Json | Set-Content -Path $ExportPath -Force
                            Write-Verbose "Exported guest users to JSON: $ExportPath"
                        }
                    }
                } else {
                    $guests
                }
            }
        } catch {
            Write-Error "Failed to retrieve guest users: $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Get-EntraGuestMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-EntraGuestMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

