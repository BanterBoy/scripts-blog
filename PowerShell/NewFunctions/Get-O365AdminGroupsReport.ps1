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