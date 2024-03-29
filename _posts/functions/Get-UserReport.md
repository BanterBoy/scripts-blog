---
layout: post
title: Get-UserReport.ps1
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
  This script will enumerate all user accounts in a Domain, and report
  on the following attributes:
  - samAccountName
  - givenName
  - sn
  - initials
  - mail
  - telephoneNumber
  - mobile
  - displayName
  - description
  - title
  - company
  - physicalDeliveryOfficeName
  - employeeID
  - employeeType
  - msexchextensioncustomattribute1
  - primaryGroupID
  - userAccountControl
  - objectsid
  - accountExpires
  - lastlogontimestamp
  - whencreated
  - memberOf

  We derive the Enabled and PasswordExpired boolean value from the
  userAccountControl value.

  The IsStale logic is
  - If it was created more than 90 days ago
    - Mark it as a stale account if it's never been logged on before.
    - Mark it as a stale account if it hasn't been logged on in 90 days.
  - If it expired more than 30 days ago, mark it as a stale account.

  We also check to see if the samAccountName is lowercase and the number
  of characters it contains, as the account length can be a maximum of
  12 characters for SAP.

  We also check to see if the Surname (sn) contains a non-alpha character.

  IMPORTANT: I am using the -Append parameter of the Export-Csv cmdlet,
             which is ONLY support from PowerShell v3 and above. If using
             v2, you'll need to download and add the following function to
             your profile to make Export-CSV cmdlet handle -Append parameter
             http://dmitrysotnikov.wordpress.com/2010/01/19/export-csv-append/

  Script Name: Get-UserReport.ps1
  Release 1.4
  Written by Jeremy@jhouseconsulting.com 27/12/2013
  Modified by Jeremy@jhouseconsulting.com 15/04/2014

#>

#-------------------------------------------------------------

# Set this value to true if you want to see the progress bar.
$ProgressBar = $True

# Set this to true to process disabled user accounts.
$ProcessDisabledUsers = $False

# Set this to true to include extra user attributes such as
# displayName, description, telephoneNumber, mobile, title,
# company, physicalDeliveryOfficeName
$ExtendedDetails = $False

# Set this to true to include the user's direct group membership
$IncludeMemberOf = $False
#-------------------------------------------------------------

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$ReferenceFile = $(&$ScriptPath) + "\UserReport.csv"

if (Test-Path -path $ReferenceFile) {
    remove-item $ReferenceFile -force -confirm:$false
}

$TotalUsersProcessed = 0
$UserCount = 0

$ADRoot = ([System.DirectoryServices.DirectoryEntry]"LDAP://RootDSE")
$DefaultNamingContext = $ADRoot.defaultNamingContext

# Derive FQDN Domain Name
$TempDefaultNamingContext = $DefaultNamingContext.ToString().ToUpper()
$DomainName = $TempDefaultNamingContext.Replace(",DC=", ".")
$DomainName = $DomainName.Replace("DC=", "")

if ($ProcessDisabledUsers -eq $False) {
    # Create an LDAP search for all enabled users not marked as criticalsystemobjects to avoid system accounts
    $ADFilter = "(&(objectClass=user)(objectcategory=person)(!userAccountControl:1.2.840.113556.1.4.803:=2)(!(isCriticalSystemObject=TRUE))(!name=IUSR*)(!name=IWAM*)(!name=ASPNET))"
}
else {
    # Create an LDAP search for all users not marked as criticalsystemobjects to avoid system accounts
    $ADFilter = "(&(objectClass=user)(objectcategory=person)(!(isCriticalSystemObject=TRUE))(!name=IUSR*)(!name=IWAM*)(!name=ASPNET))"
}
# There is a known bug in PowerShell requiring the DirectorySearcher
# properties to be in lower case for reliability.
$ADPropertyList = @("distinguishedname", "samaccountname", "givenname", "sn", "initials", "mail", "telephonenumber", "mobile", "displayname", "description", "title", "company", "physicaldeliveryofficename", "employeeid", "employeetype", "useraccountcontrol", "objectsid", "primarygroupid", "lastlogontimestamp", "whencreated", "accountexpires", "msexchextensioncustomattribute1", "memberof")
$ADScope = "SUBTREE"
$ADPageSize = 1000
$ADSearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$($DefaultNamingContext)")
$ADSearcher = New-Object System.DirectoryServices.DirectorySearcher
$ADSearcher.SearchRoot = $ADSearchRoot
$ADSearcher.PageSize = $ADPageSize
$ADSearcher.Filter = $ADFilter
$ADSearcher.SearchScope = $ADScope
if ($ADPropertyList) {
    foreach ($ADProperty in $ADPropertyList) {
        [Void]$ADSearcher.PropertiesToLoad.Add($ADProperty)
    }
}
$colResults = $ADSearcher.Findall()
$UserCount = $colResults.Count

if ($UserCount -ne 0) {
    foreach ($objResult in $colResults) {
        $lastLogonTimeStamp = ""
        $lastLogon = ""
        $IsStale = $False
        $UserDN = $objResult.Properties.distinguishedname[0]
        $samAccountName = $objResult.Properties.samaccountname[0]
        if ($samAccountName -cmatch "^[^A-Z]*$") {
            $IssamAccountNameLowerCase = $True
        }
        else {
            $IssamAccountNameLowerCase = $False
        }
        $samAccountNameLength = ($samAccountName | Measure-Object -Character).Characters
        if (($objResult.Properties.givenname | Measure-Object).Count -gt 0) {
            $Firstname = $objResult.Properties.givenname[0]
        }
        else {
            $Firstname = ""
        }
        if (($objResult.Properties.sn | Measure-Object).Count -gt 0) {
            $Surname = $objResult.Properties.sn[0]
            $nonalphacharsinsurname = $Surname -match '[^a-zA-Z]'
        }
        else {
            $Surname = ""
            $nonalphacharsinsurname = $False
        }
        # Get user SID
        $arruserSID = New-Object System.Security.Principal.SecurityIdentifier($objResult.Properties.objectsid[0], 0)
        $userSID = $arruserSID.Value
        if (($objResult.Properties.initials | Measure-Object).Count -gt 0) {
            $Initials = $objResult.Properties.initials[0]
        }
        else {
            $Initials = ""
        }
        if (($objResult.Properties.employeeid | Measure-Object).Count -gt 0) {
            $EmployeeID = $objResult.Properties.employeeid[0]
        }
        else {
            $EmployeeID = ""
        }
        if (($objResult.Properties.employeetype | Measure-Object).Count -gt 0) {
            $EmployeeType = $objResult.Properties.employeetype[0]
        }
        else {
            $EmployeeType = ""
        }
        if (($objResult.Properties.mail | Measure-Object).Count -gt 0) {
            $EMail = $objResult.Properties.mail[0]
        }
        else {
            $EMail = ""
        }
        if ($ExtendedDetails) {
            if (($objResult.Properties.displayname | Measure-Object).Count -gt 0) {
                $DisplayName = $objResult.Properties.displayname[0]
            }
            else {
                $DisplayName = ""
            }
            if (($objResult.Properties.description | Measure-Object).Count -gt 0) {
                $Description = $objResult.Properties.description[0]
            }
            else {
                $Description = ""
            }
            if (($objResult.Properties.telephonenumber | Measure-Object).Count -gt 0) {
                $TelephoneNumber = $objResult.Properties.telephonenumber[0]
            }
            else {
                $TelephoneNumber = ""
            }
            if (($objResult.Properties.mobile | Measure-Object).Count -gt 0) {
                $Mobile = $objResult.Properties.mobile[0]
            }
            else {
                $Mobile = ""
            }
            if (($objResult.Properties.title | Measure-Object).Count -gt 0) {
                $Title = $objResult.Properties.title[0]
            }
            else {
                $Title = ""
            }
            if (($objResult.Properties.company | Measure-Object).Count -gt 0) {
                $Company = $objResult.Properties.company[0]
            }
            else {
                $Company = ""
            }
            if (($objResult.Properties.physicaldeliveryofficename | Measure-Object).Count -gt 0) {
                $Office = $objResult.Properties.physicaldeliveryofficename[0]
            }
            else {
                $Office = ""
            }
        }
        if (($objResult.Properties.msexchextensioncustomattribute1 | Measure-Object).Count -gt 0) {
            $msExchExtensionCustomAttribute1 = $objResult.Properties.msexchextensioncustomattribute1[0]
        }
        else {
            $msExchExtensionCustomAttribute1 = ""
        }
        if (($objResult.Properties.lastlogontimestamp | Measure-Object).Count -gt 0) {
            $lastLogonTimeStamp = $objResult.Properties.lastlogontimestamp[0]
            $lastLogon = [System.DateTime]::FromFileTime($lastLogonTimeStamp)
            if ($lastLogon -match "1/01/1601") { $lastLogon = "Never logged on before" }
        }
        else {
            $lastLogon = "Never logged on before"
        }

        $whencreated = $objResult.Properties.whencreated[0]

        # If it was created more than 90 days ago...
        # - Mark it as a stale account if it's never been logged on before.
        # - Mark it as a stale account if it hasn't been logged on in 90 days.
        if ($whencreated -le (Get-Date).AddDays(-90)) {
            if ($lastLogon -eq "Never logged on before") {
                $IsStale = $True
            }
            elseif ($lastLogon -le (Get-Date).AddDays(-90)) {
                $IsStale = $True
            }
        }

        $AE = $objResult.Properties.accountexpires
        if (($AE.Item(0) -eq 0) -or ($AE.Item(0) -gt [DateTime]::MaxValue.Ticks)) {
            $accountExpires = "Never"
        }
        else {
            $AEDate = [DateTime]$AE.Item(0)
            $accountExpires = $AEDate.AddYears(1600).ToLocalTime()
            # Mark it as a stale account if it expired more than 30 days ago.
            if ($accountExpires -le (Get-Date).AddDays(-30)) {
                $IsStale = $True
            }
        }

        # Get user SID
        $arruserSID = New-Object System.Security.Principal.SecurityIdentifier($objResult.Properties.objectsid[0], 0)
        $userSID = $arruserSID.Value

        # Get the SID of the Domain the account is in
        $AccountDomainSid = $arruserSID.AccountDomainSid.Value

        # Get User Account Control & Primary Group by binding to the user account
        $objUser = [ADSI]("LDAP://" + $UserDN)
        if (($objUser.useraccountcontrol | Measure-Object).Count -gt 0) {
            $UACValue = $objUser.useraccountcontrol[0]
        }
        else {
            $UACValue = ""
        }
        $primarygroupID = $objUser.primarygroupid
        if ($NULL -ne $primarygroupID) {
            # Primary group can be calculated by merging the account domain SID and primary group ID
            $primarygroupSID = $AccountDomainSid + "-" + $primarygroupID.ToString()
            $primarygroup = [adsi]("LDAP://<SID=$primarygroupSID>")
            $primarygroupname = $primarygroup.name[0]
            $objUser = $null
        }
        else {
            $primarygroupname = "NULL"
        }

        $Enabled = $True
        $PasswordExpired = $False
        switch ($UACValue) {
            { ($UACValue -bor 0x0002) -eq $UACValue } {
                $Enabled = $False
            }
            { ($UACValue -bor 0x800000) -eq $UACValue } {
                $PasswordExpired = $True
            }
        }

        if ($IncludeMemberOf) {
            $Members = ""
            $groups = $objResult.Properties.memberof | ForEach-Object {
                $groupDN = $_
                $objGroup = [ADSI]("LDAP://" + $groupDN)
                $Member = $objGroup.samaccountname
                if ($Members -ne "" ) {
                    $Members += "|" + $Member
                }
                else {
                    $Members += $Member
                }
                $objGroup = $null
            }
        }

        $obj = New-Object -TypeName PSObject
        $obj | Add-Member -MemberType NoteProperty -Name "Username" -value $SamAccountName
        $obj | Add-Member -MemberType NoteProperty -Name "IsNameLowerCase" -value $IssamAccountNameLowerCase
        $obj | Add-Member -MemberType NoteProperty -Name "LengthOfName" -value $samAccountNameLength
        $obj | Add-Member -MemberType NoteProperty -Name "Firstname" -value $Firstname
        $obj | Add-Member -MemberType NoteProperty -Name "Surname" -value $Surname
        $obj | Add-Member -MemberType NoteProperty -Name "NonAlphaCharsInSurname" -value $nonalphacharsinsurname
        $obj | Add-Member -MemberType NoteProperty -Name "Initials" -value $Initials
        $obj | Add-Member -MemberType NoteProperty -Name "EmployeeID" -value $EmployeeID
        $obj | Add-Member -MemberType NoteProperty -Name "EmployeeType" -value $EmployeeType
        $obj | Add-Member -MemberType NoteProperty -Name "EMail" -value $EMail
        if ($ExtendedDetails) {
            $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $DisplayName
            $obj | Add-Member -MemberType NoteProperty -Name "Description" -value $Description
            $obj | Add-Member -MemberType NoteProperty -Name "TelephoneNumber" -value $TelephoneNumber
            $obj | Add-Member -MemberType NoteProperty -Name "Mobile" -value $Mobile
            $obj | Add-Member -MemberType NoteProperty -Name "Title" -value $Title
            $obj | Add-Member -MemberType NoteProperty -Name "Company" -value $Company
            $obj | Add-Member -MemberType NoteProperty -Name "Office" -value $Office
        }
        $obj | Add-Member -MemberType NoteProperty -Name "msExchExtensionCustomAttribute1" -value $msExchExtensionCustomAttribute1
        $obj | Add-Member -MemberType NoteProperty -Name "PrimaryGroup" -value $primarygroupname
        $obj | Add-Member -MemberType NoteProperty -Name "Enabled" -value $Enabled
        $obj | Add-Member -MemberType NoteProperty -Name "PasswordExpired" -value $PasswordExpired
        $obj | Add-Member -MemberType NoteProperty -Name "IsStale" -value $IsStale
        $obj | Add-Member -MemberType NoteProperty -Name "Expires" -value $accountExpires
        $obj | Add-Member -MemberType NoteProperty -Name "LastLogon" -value $lastLogon
        $obj | Add-Member -MemberType NoteProperty -Name "Created" -value $whencreated
        $obj | Add-Member -MemberType NoteProperty -Name "ObjectSID" -value $userSID
        if ($IncludeMemberOf) {
            $obj | Add-Member -MemberType NoteProperty -Name "MemberOf" -value $Members
        }

        # Write-Output $array | Format-Table
        $obj | Export-Csv -Path "$ReferenceFile" -Append -Delimiter ';' -NoTypeInformation -Encoding ASCII

        $TotalUsersProcessed ++
        if ($ProgressBar) {
            Write-Progress -Activity 'Processing Users' -Status ("Username: {0}" -f $samAccountName) -PercentComplete (($TotalUsersProcessed / $UserCount) * 100)
        }

    }

    # Remove the quotes from the output file.
    (Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-UserReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
