---
layout: post
title: Get-O365AdminGroupsReport.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script generates a report of all the members in Office 365 admin groups. The script starts by defining a function called `Get-O365AdminGroupsReport` that takes two parameters: `$OutputFileName` and `$Overwrite`. The function then initializes an empty array called `$O365AdminGroupReport` that will hold the report data.

The script then uses the `Get-MsolRole` cmdlet to retrieve all the admin roles in Office 365. It then loops through each role and retrieves all the members of that role using the `Get-MsolRoleMember` cmdlet. For each role member, the script creates a custom object that contains the member's name, email address, and role name. The custom object is then added to the `$O365AdminGroupReport` array.

Once all the role members have been added to the report array, the script checks if a file with the same name as the output file already exists. If it does, and the `-Overwrite` switch is not used, the script appends a random string to the filename to ensure uniqueness. The script then exports the report data to a CSV file using the `Export-CSV` cmdlet.

Overall, this script is well-organized and easy to read. One possible improvement would be to add comments to explain the purpose of each section of the code. Additionally, the script could benefit from more error handling to ensure that it gracefully handles any unexpected errors that may occur.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use this script:

1. Generate a report of all members in Office 365 admin groups and save it to a file called "O365AdminGroupReport.csv":

```
.\Get-O365AdminGroupsReport.ps1 -OutputFileName "O365AdminGroupReport.csv"
```

2. Generate a report of all members in Office 365 admin groups and overwrite any existing file with the same name:

```
.\Get-O365AdminGroupsReport.ps1 -OutputFileName "O365AdminGroupReport.csv" -Overwrite
```

3. Generate a report of all members in Office 365 admin groups and save it to a file called "O365AdminGroupReport.csv", while also displaying verbose output:

```
.\Get-O365AdminGroupsReport.ps1 -OutputFileName "O365AdminGroupReport.csv" -Verbose
```

These are just a few examples of how you could use this script. You can customize the output file name and behavior using the `-OutputFileName` and `-Overwrite` parameters, and you can enable verbose output using the `-Verbose` parameter.

---

#### Script

```powershell
<#
.SYNOPSIS
Get-O365AdminGroupsReport.ps1 - Reports on Office 365 Admin Role/Group Membership.

.DESCRIPTION
This script produces a report of the membership of Office 365 admin role groups.

.OUTPUTS
The report is output to CSV file.

.PARAMETER ReportFile
You can provide a custom output file name. The file name you specify will be
modified with the current date, for example MyReportFileName.csv will become
MyReportFileName-ddMMyyyy.csv. If a file of the same name exists, a unique
character string will also be appended to the file name.

.PARAMETER Overwrite
Overwrites an existing report file of the same name, instead of appending
a unique character string.

.EXAMPLE
.\Get-O365AdminGroupsReport.ps1

.EXAMPLE
.\Get-O365AdminGroupsReport.ps1 -ReportFile MyReportFileName.csv -Overwrite

.EXAMPLE
.\Get-O365AdminGroupsReport.ps1 -Verbose

.LINK
https://practical365.com/security/reporting-office-365-admin-role-group-members

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Version history:
V1.00, 17/04/2017 - Initial version

License:

The MIT License (MIT)

Copyright (c) 2017 Paul Cunningham

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

#>

[CmdletBinding()]
param (
    [Parameter( Mandatory = $false )]
    [ValidatePattern('.csv$')]
    [string]$ReportFile = "Office365AdminGroupMembers.csv",

    [Parameter( Mandatory = $false )]
    [switch]$Overwrite
)

#...................................
# Variables
#...................................

$O365AdminGroupReport = New-Object System.Collections.ArrayList
$now = Get-Date
$ShortDate = $now.ToShortDateString() -replace "/", ""

$ReportFileSplit = $ReportFile.Split(".")
$OutputFileNamePrefix = $ReportFileSplit[0..($ReportFileSplit.length - 2)]
$OutputFileName = "$($OutputFileNamePrefix)-$($ShortDate).$($ReportFileSplit[-1])"

#...................................
# Script
#...................................

#Check if AzureAD PowerShell or AzureADPreview module is available
if (-not(Get-Module -Name AzureAD) -and -not (Get-Module AzureADPreview)) {
    throw "The AzureAD PowerShell module is not installed on this computer."
}

#Get the Azure AD roles for the tenant
$AzureADRoles = @(Get-AzureADDirectoryRole -ErrorAction Stop)

#Loop through the Azure AD roles
foreach ($AzureADRole in $AzureADRoles) {

    Write-Verbose "Processing $($AzureADRole.DisplayName)"

    #Get the list of members for the role
    $RoleMembers = @(Get-AzureADDirectoryRoleMember -ObjectId $AzureADRole.ObjectId)

    #Loop through the list of members
    foreach ($RoleMember in $RoleMembers) {
        $ObjectProperties = [Ordered]@{
            "Role"                = $AzureADRole.DisplayName
            "Display Name"        = $RoleMember.DisplayName
            "Object Type"         = $RoleMember.ObjectType
            "Account Enabled"     = $RoleMember.AccountEnabled
            "User Principal Name" = $RoleMember.UserPrincipalName
            "Password Policies"   = $RoleMember.PasswordPolicies
            "HomePage"            = $RoleMember.HomePage
        }

        $RoleMemberObject = New-Object -TypeName PSObject -Property $ObjectProperties

        #Add the role member's details to the array for the report data
        [void]$O365AdminGroupReport.Add($RoleMemberObject)
    }
}

Write-Verbose "Outputting report"

#Check if a file of the same name already exists
if (Test-Path -Path $OutputFileName) {
    if (-not $Overwrite) {
        #File exists and -Overwrite switch not used, so a random string will be appended to filename for uniqueness
        $RandomString = -join (48..57 + 65..90 + 97..122 | ForEach-Object { [char]$_ } | Get-Random -Count 4)
        $OutputFileNameSplit = $OutputFileName.Split(".")
        $OutputFileNamePrefix = $OutputFileNameSplit[0..($OutputFileNameSplit.length - 2)]
        $OutputFileName = "$($OutputFileNamePrefix)-$($RandomString).$($OutputFileNameSplit[-1])"
        Write-Verbose "A file with the desired name already exists. New file name will be $($OutputFileName)"
    }
}

#Output the report to CSV
if ($Overwrite) {
    $O365AdminGroupReport | Export-CSV -Path $OutputFileName -Force -NoTypeInformation
}
else {
    $O365AdminGroupReport | Export-CSV -Path $OutputFileName -NoClobber -NoTypeInformation
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-O365AdminGroupsReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-O365AdminGroupsReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
