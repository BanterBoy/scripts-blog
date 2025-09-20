---
layout: post
title: Update-DistributionList.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/update-distributionlist/
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

Updates a distribution group by comparing a CSV file’s email list with the current distribution group members.

#### Detailed Description

The Update-DistributionList function imports email addresses from a CSV file and compares them with the members of a specified distribution group. If an email from the CSV is a valid mail contact and not already a member, it is added. Conversely, if a distribution group member is not found in the CSV file, it is removed. Logs detailing added and removed emails are then exported to CSV files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Update-DistributionList -csvFilePath "C:\Data\members.csv" -distributionGroupName "Sales Team" -logPath "C:\Logs"
```

This example updates the "Sales Team" distribution group using a CSV file located at "C:\Data\members.csv" (which must include an "Email" header) and exports logs to "C:\Logs".

**Example 2**

```powershell
Update-DistributionList -csvFilePath "C:\Data\emails.csv" -distributionGroupName "Marketing"
```

This example updates the "Marketing" distribution group using the CSV file "C:\Data\emails.csv". Logs are saved to the default Documents folder.

**Example 3**

```powershell
Update-DistributionList -csvFilePath "$env:USERPROFILE\Desktop\contacts.csv" -distributionGroupName "IT Support" -logPath "$env:USERPROFILE\Desktop\Logs"
```

This example imports email contacts from a CSV file on the Desktop, updates the "IT Support" distribution group, and exports logs to a "Logs" folder on the Desktop.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: 21/05/2025

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Updates a distribution group by comparing a CSV file’s email list with the current distribution group members.

.DESCRIPTION
The Update-DistributionList function imports email addresses from a CSV file and compares them with the members of a specified distribution group.
If an email from the CSV is a valid mail contact and not already a member, it is added.
Conversely, if a distribution group member is not found in the CSV file, it is removed.
Logs detailing added and removed emails are then exported to CSV files.

.PARAMETER csvFilePath
Specifies the file path to the CSV file containing the list of email addresses.
The CSV file is expected to include a header row with at least one column named "Email" that contains the email address for each contact.

.PARAMETER distributionGroupName
Specifies the name or identity of the distribution group to update.

.PARAMETER logPath
Specifies the directory where the log files (of added and removed emails) will be saved.
Defaults to "$HOME\Documents" if not provided.

.EXAMPLE
Update-DistributionList -csvFilePath "C:\Data\members.csv" -distributionGroupName "Sales Team" -logPath "C:\Logs"
This example updates the "Sales Team" distribution group using a CSV file located at "C:\Data\members.csv" (which must include an "Email" header) and exports logs to "C:\Logs".

.EXAMPLE
Update-DistributionList -csvFilePath "C:\Data\emails.csv" -distributionGroupName "Marketing"
This example updates the "Marketing" distribution group using the CSV file "C:\Data\emails.csv". Logs are saved to the default Documents folder.

.EXAMPLE
Update-DistributionList -csvFilePath "$env:USERPROFILE\Desktop\contacts.csv" -distributionGroupName "IT Support" -logPath "$env:USERPROFILE\Desktop\Logs"
This example imports email contacts from a CSV file on the Desktop, updates the "IT Support" distribution group, and exports logs to a "Logs" folder on the Desktop.

.NOTES
Author: Luke Leigh
Date: 21/05/2025
#>
function Update-DistributionList {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$csvFilePath,
        [string]$distributionGroupName,
        [string]$logPath = "$HOME\Documents"  # Default to the Documents folder if no path is provided
    )

    # Create empty arrays for logging
    $addedEmails = @()
    $removedEmails = @()

    # Import the CSV file
    $csvEmails = Import-Csv -Path $csvFilePath | ForEach-Object { $_.Email }  # Assuming 'Members' is the column name in your CSV

    Write-Verbose "CSV file imported"

    # Get the distribution group members
    $groupMembers = Get-DistributionGroupMember -Identity $distributionGroupName

    Write-Verbose "Distribution group members retrieved"

    # Compare the lists and update the distribution group
    foreach ($email in $csvEmails) {
        # Check if the email is a mail contact in your Exchange
        $contact = Get-MailContact -Filter "EmailAddresses -eq '$email'"

        if ($contact) {
            # If the email is not in the distribution group, add it
            $groupMemberEmails = $groupMembers | ForEach-Object { $_.PrimarySmtpAddress }
            if ($email -notin $groupMemberEmails) {
                if ($PSCmdlet.ShouldProcess("$email", "Add to distribution group")) {
                    Add-DistributionGroupMember -Identity $distributionGroupName -Member $email
                    $addedEmails += New-Object PSObject -Property @{Email = $email }
                    Write-Verbose "$email added to the distribution group"
                }
            }
        }
    }

    foreach ($member in $groupMembers) {
        # If the member is not in the CSV file, remove it from the distribution group
        if ($member.PrimarySmtpAddress -notin $csvEmails) {
            if ($PSCmdlet.ShouldProcess("$member.PrimarySmtpAddress", "Remove from distribution group")) {
                Remove-DistributionGroupMember -Identity $distributionGroupName -Member $member.PrimarySmtpAddress -Confirm:$false
                $removedEmails += New-Object PSObject -Property @{Email = $member.PrimarySmtpAddress }
                Write-Verbose "$member.PrimarySmtpAddress removed from the distribution group"
            }
        }
    }

    # Get the current date and time
    $date = Get-Date -Format "yyyyMMddHHmm"

    # Export the logs to CSV files
    $addedEmails | Export-Csv -Path "$logPath\AddedEmails-$date.csv" -NoTypeInformation
    $removedEmails | Export-Csv -Path "$logPath\RemovedEmails-$date.csv" -NoTypeInformation

    Write-Verbose "Logs exported to CSV files"
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Update-DistributionList.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-DistributionList.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

