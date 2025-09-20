---
layout: post
title: Disable-InactiveComputer.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Disable-InactiveComputer/
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

Disables inactive computers in Active Directory.

#### Detailed Description

The Disable-InactiveComputer function disables inactive computers in Active Directory based on the specified criteria. It can also move disabled computer accounts to a specified Organizational Unit (OU).

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Disable-InactiveComputer -DaysAgo 60 -DisabledAccountsOU "OU=InactiveComputers,DC=contoso,DC=com" -SearchBase "DC=contoso,DC=com"
```

Disables inactive computers that have not been used for the past 60 days. The disabled computer accounts will be moved to the "OU=InactiveComputers,DC=contoso,DC=com" OU.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Active Directory module to be installed. You can install it by running the following command: Install-WindowsFeature RSAT-AD-PowerShell

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Disables inactive computers in Active Directory.

.DESCRIPTION
    The Disable-InactiveComputer function disables inactive computers in Active Directory based on the specified criteria. It can also move disabled computer accounts to a specified Organizational Unit (OU).

.PARAMETER DaysAgo
    Specifies the number of days ago from the current date to consider a computer as inactive. The default value is 90 days.

.PARAMETER DisabledAccountsOU
    Specifies the Organizational Unit (OU) where disabled computer accounts will be moved. The default value is "OU=DisabledAccounts," followed by the distinguished name of the current domain.

.PARAMETER SearchBase
    Specifies the search base for finding inactive computer accounts. The default value is the distinguished name of the current domain.

.EXAMPLE
    Disable-InactiveComputer -DaysAgo 60 -DisabledAccountsOU "OU=InactiveComputers,DC=contoso,DC=com" -SearchBase "DC=contoso,DC=com"
    Disables inactive computers that have not been used for the past 60 days. The disabled computer accounts will be moved to the "OU=InactiveComputers,DC=contoso,DC=com" OU.

.NOTES
    This function requires the Active Directory module to be installed. You can install it by running the following command:
    Install-WindowsFeature RSAT-AD-PowerShell

    Author: Your Name
    Date: Today's Date
#>

Function Disable-InactiveComputer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = 'Enter the number of days ago to consider a computer as inactive.')]
        [ValidateRange(1, 365)]
        [int]$DaysAgo = 90,

        [Parameter(Mandatory = $false, HelpMessage = 'Specify the OU where disabled computer accounts will be moved.')]
        [ValidateNotNullOrEmpty()]
        [string]$DisabledAccountsOU = "OU=DisabledAccounts," + (Get-ADDomain).DistinguishedName,

        [Parameter(Mandatory = $false, HelpMessage = 'Specify the search base for finding inactive computer accounts.')]
        [ValidateNotNullOrEmpty()]
        [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )

    begin {
        Write-Verbose "Initializing Disable-InactiveComputer function..."
        $CutoffDate = (Get-Date).AddDays(-$DaysAgo)
        Write-Verbose "Computers with PasswordLastSet before $CutoffDate will be considered inactive."
    }

    process {
        if ($PSCmdlet.ShouldProcess("Computers in $SearchBase", "Disable inactive computers")) {
            try {
                Write-Verbose "Searching for inactive computer accounts in $SearchBase..."
                $InactiveComputers = Search-ADAccount -AccountInactive -ComputersOnly -SearchBase $SearchBase -ErrorAction Stop

                foreach ($Computer in $InactiveComputers) {
                    try {
                        if ($Computer.PasswordLastSet -lt $CutoffDate) {
                            Write-Verbose "Disabling computer: $($Computer.Name)"
                            Set-ADComputer -Identity $Computer.DistinguishedName -Enabled:$false -ErrorAction Stop

                            Write-Verbose "Moving computer $($Computer.Name) to OU: $DisabledAccountsOU"
                            Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $DisabledAccountsOU -Confirm:$false -ErrorAction Stop
                        }
                        else {
                            Write-Verbose "Computer $($Computer.Name) is still active."
                        }
                    }
                    catch {
                        Write-Error "Failed to process computer $($Computer.Name): $_"
                    }
                }
            }
            catch {
                Write-Error "Failed to search for inactive computers: $_"
            }
        }
    }

    end {
        Write-Verbose "Disable-InactiveComputer function completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Disable-InactiveComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-InactiveComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

