---
layout: post
title: Cleanup-AdminSDHolder.ps1
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

**_@GitHub Copilot_** -

---

#### Script

```powershell
<#
  This script will reset the inheritance flag and clear the
  AdminCount attribute for objects no longer protected by the
  AdminSDHolder.

  Output will be written to a csv file that can be imported
  into Excel for reporting.

  The script can run in "report only" mode, so that you are first
  able to understand the current state before taking any action.
  You then have two options:
  1) Manually set each account.
  2) Run this script to take action and reset the inheritance flag
     and clear the AdminCount attribute for all existing accounts
     that have the AdminCount attribute set to 1.
     Any objects that should genuinely be protected will be
     re-protected when the AdminSDHolder next cycles (within 1 hour
     by default).

  Script Name: Cleanup-AdminSDHolder.ps1
  Author: Tony Murray
  Version: 1.0
  Date: 28/08/2013

  Requires PowerShell 2.0 and above.

  Syntax:

    To Report ONLY:
      Cleanup-AdminSDHolder.ps1 -action ReportOnly

    To take action:
      Cleanup-AdminSDHolder.ps1
#>

#-------------------------------------------------------------
param([String]$Action)

if ([String]::IsNullOrEmpty($Action)) {
    $ReportOnly = $False
}
else {
    If ($Action -eq "ReportOnly") {
        $ReportOnly = $True
    }
    else {
        $ReportOnly = $False
    }
}

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$ReferenceFile = $(&$ScriptPath) + "\AdminSDHolderReport.csv"

$array = @()
$objectclasses = @{}

$ProtectedGroups = @("Schema Admins", "Enterprise Admins", "Cert Publishers", "Domain Admins", "Account Operators", "Print Operators", "Administrators", "Server Operators", "Backup Operators")

# Import the AD module
Import-Module ActiveDirectory

# Find objects that appear to be protected in AD
$probjs = Get-ADObject -LDAPFilter "(admincount=1)" | sort-object ObjectClass, Name
$bcount = $probjs.count
if ($bcount) {
    If ($ReportOnly -eq $False) {
        Write-Host -ForegroundColor Green "Protected object count before change is $bcount"
    }
    else {
        Write-Host -ForegroundColor Green "Protected object count is $bcount"
    } # end if
}
else {
    Write-Host -ForegroundColor Green "No objects are currently protected - nothing to do"
    exit
} # end if
Write-Host " "

# Change to the AD drive
Set-Location AD:

# Loop through protected objets to set inheritance flag
# and clear the adminCount value
foreach ($probj in $probjs) {
    $dn = $probj.distinguishedname
    If ($($probj.name).Contains("CNF:") -eq $False) {
        $name = $($probj.name)
    }
    else {
        $name = [string]::join("\0A", ($($probj.name).Split("`n")))
    } # end if
    $class = $probj.ObjectClass

    # Create a hashtable to capture a count of each objectclass
    If (!($objectclasses.ContainsKey($class))) {
        $objectclasses = $objectclasses + @{$class = 1 }
    }
    else {
        $value = $objectclasses.Get_Item($class)
        $value ++
        $objectclasses.Set_Item($class, $value)
    } # end if

    If ($dn.Contains("CNF:") -eq $False) {
        If ($ProtectedGroups -notcontains $name) {
            $acl = Get-Acl $dn
            if ($acl.AreAccessRulesProtected) {
                If ($ReportOnly -eq $False) {
                    Write-Host -ForegroundColor Yellow "$class`t$dn has inheritance blocked - we will remove the block"
                    $acl.SetAccessRuleProtection($false, $false);
                    #set-acl -aclobject $acl $dn
                    # We need to clear the adminCount attribute too
                    #Set-ADObject -Identity $dn -Clear adminCount
                }
                else {
                    Write-Host -ForegroundColor Yellow "$class`t$dn has inheritance blocked"
                } # end if
            } # end if
        }
        else {
            Write-Host -ForegroundColor Yellow "$class`t$dn is a default protected group"
        } # end if
    }
    else {
        Write-Host -ForegroundColor Red "$class`t$dn cannot be processed"
    }# end if

    $obj = New-Object -TypeName PSObject
    $obj | Add-Member -MemberType NoteProperty -Name "Class" -Value $class
    $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $name
    $obj | Add-Member -MemberType NoteProperty -Name "DN" -Value $dn
    $array += $obj

} # end foreach

Write-Host -ForegroundColor Green "`nA break down of the $bcount objects processed:"
$objectclasses.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Host -ForegroundColor Green "- $($_.key): $($_.value)"
}

# Write-Output $array | Format-Table
$array | Export-Csv -notype -path "$ReferenceFile" -Delimiter ';'

# Remove the quotes
(Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii

If ($ReportOnly -eq $False) {
    # Count the number of protected objects
    $acount = (Get-ADObject -LDAPFilter "(admincount=1)").count
    Write-Host " "
    if ($acount) {
        Write-Host -ForegroundColor Green "Protected object count after change is $acount"
    }
    else {
        Write-Host -ForegroundColor Green "No objects are currently protected"
    } # end if
} # end if
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Cleanup-AdminSDHolder.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Cleanup-AdminSDHolder.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
