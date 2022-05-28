---
layout: post
title: FindDuplicateEmployeeIDs.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
  This script will find duplicate employeeID values and export them
  to a CSV file.

  Syntax examples:
    To process all users:
      UpdatingEmployeeID.ps1

    To process all users from a particular OU structure:
      UpdatingEmployeeID.ps1 -SearchBase "OU=Users,OU=Corp,DC=mydemosthatrock,DC=com" -ReferenceFile "c:\MyOutput.csv"

    You must use quotes around the SearchBase parameter otherwise the
    comma will be replaced with a space. This is because the comma is a
    special symbol in PowerShell.

  Release 1.0
  Written by Jeremy@jhouseconsulting.com 3rd April 2014

#>

#-------------------------------------------------------------
param([String]$SearchBase, [String]$ReferenceFile)

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

if ([String]::IsNullOrEmpty($ReferenceFile)) {
    $ReferenceFile = $(&$ScriptPath) + "\DuplicateEmployeeIDs.csv";
}

$UsedefaultNamingContext = $False
if ([String]::IsNullOrEmpty($SearchBase)) {
    $UsedefaultNamingContext = $True
}

#-------------------------------------------------------------
# Import the Active Directory Module
Import-Module ActiveDirectory -WarningAction SilentlyContinue
if ($Error.Count -eq 0) {
    #Write-Host "Successfully loaded Active Directory Powershell's module" -ForeGroundColor Green
}
else {
    Write-Host "Error while loading Active Directory Powershell's module : $Error" -ForeGroundColor Red
    exit
}

#-------------------------------------------------------------
$defaultNamingContext = (get-adrootdse).defaultnamingcontext
$DistinguishedName = (Get-ADDomain).DistinguishedName
$DomainName = (Get-ADDomain).NetBIOSName
$DNSRoot = (Get-ADDomain).DNSRoot

if ($UsedefaultNamingContext -eq $True) {
    $SearchBase = $defaultNamingContext
}
else {
    $TestSearchBase = Get-ADobject "$SearchBase"
    if ($Null -eq $TestSearchBase) {
        $SearchBase = $defaultNamingContext
    }
}

#-------------------------------------------------------------

function Get-LastLoggedOnDate ([string] $Date) {
    if ($Date -eq $NULL -OR $Date -eq "") {
        $Date = "Never logged on before"
    }
    $Date
}

$LastLoggedOnDate = @{Name = 'LastLoggedOnDate'; Expression = { Get-LastLoggedOnDate $_.LastLogonDate } }

$EmployeeID = @{Name = 'EmployeeID'; Expression = { $_.EmployeeID.Trim() } }

$TotalProcessed = 0
$filter = "(employeeID=*)"
Write-Host -ForegroundColor Green "Finding all users with an employeeID attribute and exporting the duplicates to '$ReferenceFile'`n"
Get-ADUser -LDAPFilter $filter -SearchBase $SearchBase -Properties * | Select-Object $EmployeeID, SamAccountName, Name, Enabled, $LastLoggedOnDate, whenCreated | Group-Object EmployeeID | Where-Object { $_.Count -gt 1 } | Select-Object -Expand Group | Export-Csv -notype "$ReferenceFile"

# Remove the quotes
(Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/FindDuplicateEmployeeIDs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=FindDuplicateEmployeeIDs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
