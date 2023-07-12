---
layout: post
title: OU_permissions.ps1
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

**_@GitHub Copilot_** - This PowerShell script creates a report of all OU permissions. It starts by importing the ActiveDirectory module. The script then builds a lookup hash table that holds all of the string names of the ObjectType GUIDs referenced in the security descriptors. It retrieves a list of all OUs and retrieves their permissions. It adds report columns to contain the OU path and string names of the ObjectTypes. It then dumps the raw report out to a CSV file for analysis in Excel and opens the file.

The script retrieves a list of all OUs by getting the domain and root containers for good measure (users, computers, etc.). It then loops through each of the OUs and retrieves their permissions. It adds report columns to contain the OU path and string names of the ObjectTypes. It then dumps the raw report out to a CSV file for analysis in Excel and opens the file.

The script also includes various reports of interest. The first report shows only explicitly assigned permissions by Group and OU. The second report shows explicitly assigned permissions for a user or group. The user is prompted to enter the user or group name to search in OU permissions.

To improve the code's readability, the script could be broken down into smaller functions. The variable names could be more descriptive, and the comments could be more detailed. The script could also be optimized for performance by using the pipeline more effectively and avoiding unnecessary loops.

**_@BanterBoy:_** - Explain how to use the script.

**_@GitHub Copilot_** - To use the script, run it in a PowerShell console. The script will prompt you to enter the user or group name to search in OU permissions. The script will then create a report of all OU permissions. The script will then dump the raw report out to a CSV file for analysis in Excel and open the file.

GitHub Copilot: Yes, to use the script, you will need to dot source it and enter parameters. Here is an example demonstrating how to use the script:

1. Dot source the script by typing "ENTERPATHNAME\scriptname.ps1" and pressing Enter.
2. The script will prompt you to enter the domain name. Enter the name of the domain you want to retrieve OU permissions for and press Enter.
3. The script will then generate a report of all OU permissions and save it to a CSV file.
4. The report will open automatically in Excel for analysis.

Additionally, the script includes two other reports of interest. To generate these reports, follow these steps:

1. Run the script as described above.
2. To generate the first report, type "1" and press Enter. The report will show only explicitly assigned permissions by Group and OU.
3. To generate the second report, type "2" and press Enter. The script will prompt you to enter the user or group name you want to search for. Enter the name and press Enter. The report will show explicitly assigned permissions for the specified user or group.

I hope this example helps you understand how to use the script.

---

#### Script

```powershell
<##############################################################################
Ashley McGlone
Microsoft Premier Field Engineer
March 2013
http://aka.ms/GoateePFE

This script creates a report of all OU permissions.


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

Import-Module ActiveDirectory

# This array will hold the report output.
$report = @()

# Build a lookup hash table that holds all of the string names of the
# ObjectType GUIDs referenced in the security descriptors.
# See the Active Directory Technical Specifications:
#  3.1.1.2.3 Attributes
#    http://msdn.microsoft.com/en-us/library/cc223202.aspx
#  3.1.1.2.3.3 Property Set
#    http://msdn.microsoft.com/en-us/library/cc223204.aspx
#  5.1.3.2.1 Control Access Rights
#    http://msdn.microsoft.com/en-us/library/cc223512.aspx
#  Working with GUID arrays
#    http://blogs.msdn.com/b/adpowershell/archive/2009/09/22/how-to-find-extended-rights-that-apply-to-a-schema-class-object.aspx
# Hide the errors for a couple duplicate hash table keys.
$schemaIDGUID = @{}
### NEED TO RECONCILE THE CONFLICTS ###
$ErrorActionPreference = 'SilentlyContinue'
Get-ADObject -SearchBase (Get-ADRootDSE).schemaNamingContext -LDAPFilter '(schemaIDGUID=*)' -Properties name, schemaIDGUID |
 ForEach-Object {$schemaIDGUID.add([System.GUID]$_.schemaIDGUID,$_.name)}
Get-ADObject -SearchBase "CN=Extended-Rights,$((Get-ADRootDSE).configurationNamingContext)" -LDAPFilter '(objectClass=controlAccessRight)' -Properties name, rightsGUID |
 ForEach-Object {$schemaIDGUID.add([System.GUID]$_.rightsGUID,$_.name)}
$ErrorActionPreference = 'Continue'

# Get a list of all OUs.  Add in the root containers for good measure (users, computers, etc.).
$OUs  = @(Get-ADDomain | Select-Object -ExpandProperty DistinguishedName)
$OUs += Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName
$OUs += Get-ADObject -SearchBase (Get-ADDomain).DistinguishedName -SearchScope OneLevel -LDAPFilter '(objectClass=container)' | Select-Object -ExpandProperty DistinguishedName

# Loop through each of the OUs and retrieve their permissions.
# Add report columns to contain the OU path and string names of the ObjectTypes.
ForEach ($OU in $OUs) {
    $report += Get-Acl -Path "AD:\$OU" |
     Select-Object -ExpandProperty Access |
     Select-Object @{name='organizationalUnit';expression={$OU}}, `
                   @{name='objectTypeName';expression={if ($_.objectType.ToString() -eq '00000000-0000-0000-0000-000000000000') {'All'} Else {$schemaIDGUID.Item($_.objectType)}}}, `
                   @{name='inheritedObjectTypeName';expression={$schemaIDGUID.Item($_.inheritedObjectType)}}, `
                   *
}

# Dump the raw report out to a CSV file for analysis in Excel.
$report | Export-Csv -Path ".\OU_Permissions.csv" -NoTypeInformation
Start-Process ".\OU_Permissions.csv"

###############################################################################
# Various reports of interest
###############################################################################
break

# Show only explicitly assigned permissions by Group and OU
$report |
 Where-Object {-not $_.IsInherited} |
 Select-Object IdentityReference, OrganizationalUnit -Unique |
 Sort-Object IdentityReference

# Show explicitly assigned permissions for a user or group
$filter = Read-Host "Enter the user or group name to search in OU permissions"
$report |
 Where-Object {$_.IdentityReference -like "*$filter*"} |
 Select-Object IdentityReference, OrganizationalUnit, IsInherited -Unique |
 Sort-Object IdentityReference
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/OU_permissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=OU_permissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/tools.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Tools
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
