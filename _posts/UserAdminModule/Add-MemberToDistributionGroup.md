---
layout: post
title: Add-MemberToDistributionGroup.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/add-membertodistributiongroup/
categories:
  - UserAdminModule
  - Exchange
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

Adds a member to a distribution group in Exchange.

#### Detailed Description

The Add-MemberToDistributionGroup function adds a member to a distribution group in Exchange. It checks if the provided email address is a mail contact in your Exchange and if it is not already a member of the distribution group. If the email address is a duplicate, it logs the duplicate email and skips adding it to the group. The function also exports the logs to a CSV file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Add-MemberToDistributionGroup -email "john.doe@example.com" -distributionGroupName "Sales Group" -logPath "C:\Logs"
```

This example adds the email address "john.doe@example.com" to the "Sales Group" distribution group and exports the logs to the "C:\Logs" folder.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Adds a member to a distribution group in Exchange.

.DESCRIPTION
The Add-MemberToDistributionGroup function adds a member to a distribution group in Exchange. It checks if the provided email address is a mail contact in your Exchange and if it is not already a member of the distribution group. If the email address is a duplicate, it logs the duplicate email and skips adding it to the group. The function also exports the logs to a CSV file.

.PARAMETER email
The email address of the member to be added to the distribution group. Supports pipeline input.

.PARAMETER distributionGroupName
The name of the distribution group to which the member will be added.

.PARAMETER logPath
The path where the logs will be exported. If no path is provided, the logs will be exported to the Documents folder.

.EXAMPLE
Add-MemberToDistributionGroup -email "john.doe@example.com" -distributionGroupName "Sales Group" -logPath "C:\Logs"

This example adds the email address "john.doe@example.com" to the "Sales Group" distribution group and exports the logs to the "C:\Logs" folder.

.NOTES
Author: Your Name
Date: Today's Date
#>

function Add-MemberToDistributionGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$email,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$distributionGroupName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$logPath = "$HOME\Documents"  # Default to the Documents folder if no path is provided
    )

    begin {
        # Initialize an empty array for logging duplicate emails
        $duplicateEmails = @()
    }

    process {
        try {
            # Get the distribution group members
            $groupMembers = Get-DistributionGroupMember -Identity $distributionGroupName -ErrorAction Stop

            # Check if the email is a mail contact in your Exchange
            $contacts = Get-Recipient -Filter "EmailAddresses -eq '$email'" -ErrorAction Stop

            if ($contacts.Count -gt 1) {
                # Log the duplicate email and skip adding it to the group
                Write-Verbose "Duplicate email detected: $email"
                $duplicateEmails += [PSCustomObject]@{ Email = $email }
            }
            elseif ($contacts.Count -eq 1) {
                # If the email is not in the distribution group, add it
                $groupMemberEmails = $groupMembers | ForEach-Object { $_.PrimarySmtpAddress }
                if ($email -notin $groupMemberEmails) {
                    if ($PSCmdlet.ShouldProcess("$email", "Add to distribution group $distributionGroupName")) {
                        Add-DistributionGroupMember -Identity $distributionGroupName -Member $email -ErrorAction Stop
                        Write-Verbose "$email added to the distribution group"
                    }
                }
                else {
                    Write-Verbose "$email is already a member of the distribution group"
                }
            }
            else {
                Write-Error "The email address '$email' does not exist as a mail contact in Exchange."
            }
        }
        catch {
            Write-Error "An error occurred while processing the email '$email': $_"
        }
    }

    end {
        # Export the logs to a CSV file if there are duplicate emails
        if ($duplicateEmails.Count -gt 0) {
            try {
                $logFilePath = Join-Path -Path $logPath -ChildPath "DuplicateEmails.csv"
                if ($PSCmdlet.ShouldProcess($logFilePath, "Export duplicate emails log")) {
                    $duplicateEmails | Export-Csv -Path $logFilePath -NoTypeInformation -Force
                    Write-Verbose "Logs exported to $logFilePath"
                }
            }
            catch {
                Write-Error "An error occurred while exporting the logs: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Add-MemberToDistributionGroup.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Add-MemberToDistributionGroup.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

