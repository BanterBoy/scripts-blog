---
layout: post
title: Get-UserAccountControlReport.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
<#
  This script will enumerate all user accounts in a Domain, calculate their UserAccountControl flags
  and create a report of the "interesting" flags in CSV format.

  Interesting flags are those you set in the $arrInterestingFlags array.

  Script Name: Get-UserAccountControlReport.ps1
  Release 1.0
  Written by Jeremy@jhouseconsulting.com 27/12/2013

  References:
  - http://support.microsoft.com/kb/305144
  - http://msdn.microsoft.com/en-us/library/ms680832(VS.85).aspx
  - http://bsonposh.com/archives/288
  - http://gallery.technet.microsoft.com/scriptcenter/Convert-userAccountControl-629eed01
  - http://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/

#>

#-------------------------------------------------------------

# Add the flags you want to report on in the CSV
$arrInterestingFlags = @("TRUSTED_FOR_DELEGATION", "USE_DES_KEY_ONLY", "DONT_REQ_PREAUTH", "TRUSTED_TO_AUTH_FOR_DELEGATION")

# Set this value to true if you want to see the progress bar.
$ProgressBar = $True

# Set this value to true if you want a summary output to the
# console when the script has completed.
$OutputSummary = $True

# Set this to true to process disabled user accounts.
$ProcessDisabledUsers = $False

#-------------------------------------------------------------

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$ReferenceFile = $(&$ScriptPath) + "\UserAccountControlReport.csv"

$array = @()
$TotalUsersProcessed = 0
$UserCount = 0
$SCRIPT = 0
$ACCOUNTDISABLE = 0
$HOMEDIR_REQUIRED = 0
$LOCKOUT = 0
$PASSWD_NOTREQD = 0
$PASSWD_CANT_CHANGE = 0
$ENCRYPTED_TEXT_PWD_ALLOWED = 0
$TEMP_DUPLICATE_ACCOUNT = 0
$NORMAL_ACCOUNT = 0
$INTERDOMAIN_TRUST_ACCOUNT = 0
$WORKSTATION_TRUST_ACCOUNT = 0
$SERVER_TRUST_ACCOUNT = 0
$DONT_EXPIRE_PASSWORD = 0
$MNS_LOGON_ACCOUNT = 0
$SMARTCARD_REQUIRED = 0
$TRUSTED_FOR_DELEGATION = 0
$NOT_DELEGATED = 0
$USE_DES_KEY_ONLY = 0
$DONT_REQ_PREAUTH = 0
$PASSWORD_EXPIRED = 0
$TRUSTED_TO_AUTH_FOR_DELEGATION = 0
$PARTIAL_SECRETS_ACCOUNT = 0

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
$ADPropertyList = @("distinguishedname", "samAccountName", "userAccountControl", "lastlogontimestamp")
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
$Users = $ADSearcher.Findall()
$UserCount = $users.Count

if ($UserCount -ne 0) {
    foreach ($user in $users) {
        $lastLogonTimeStamp = ""
        $lastLogon = ""
        $UserDN = $user.Properties.distinguishedname[0]
        $samAccountName = $user.Properties.samaccountname[0]
        If (($user.Properties.lastlogontimestamp | Measure-Object).Count -gt 0) {
            $lastLogonTimeStamp = $user.Properties.lastlogontimestamp[0]
            $lastLogon = [System.DateTime]::FromFileTime($lastLogonTimeStamp)
            if ($lastLogon -match "1/01/1601") { $lastLogon = "Never logged on before" }
        }
        else {
            $lastLogon = "Never logged on before"
        }
        # Get User Account Control & Primary Group by binding to the user account
        $objUser = [ADSI]("LDAP://" + $UserDN)
        $UACValue = $objUser.useraccountcontrol[0]
        $objUser = $null

        $flags = @()
        switch ($UACValue) {
            { ($UACValue -bor 0x0001) -eq $UACValue } {
                $flags += "SCRIPT"
                $SCRIPT ++
            }
            { ($UACValue -bor 0x0002) -eq $UACValue } {
                $flags += "ACCOUNTDISABLE"
                $ACCOUNTDISABLE ++
            }
            { ($UACValue -bor 0x0008) -eq $UACValue } {
                $flags += "HOMEDIR_REQUIRED"
                $HOMEDIR_REQUIRED ++
            }
            { ($UACValue -bor 0x0010) -eq $UACValue } {
                $flags += "LOCKOUT"
                $LOCKOUT ++
            }
            { ($UACValue -bor 0x0020) -eq $UACValue } {
                $flags += "PASSWD_NOTREQD"
                $PASSWD_NOTREQD ++
            }
            { ($UACValue -bor 0x0040) -eq $UACValue } {
                $flags += "PASSWD_CANT_CHANGE"
                $PASSWD_CANT_CHANGE ++
            }
            { ($UACValue -bor 0x0080) -eq $UACValue } {
                $flags += "ENCRYPTED_TEXT_PWD_ALLOWED"
                $ENCRYPTED_TEXT_PWD_ALLOWED ++
            }
            { ($UACValue -bor 0x0100) -eq $UACValue } {
                $flags += "TEMP_DUPLICATE_ACCOUNT"
                $TEMP_DUPLICATE_ACCOUNT ++
            }
            { ($UACValue -bor 0x0200) -eq $UACValue } {
                $flags += "NORMAL_ACCOUNT"
                $NORMAL_ACCOUNT ++
            }
            { ($UACValue -bor 0x0800) -eq $UACValue } {
                $flags += "INTERDOMAIN_TRUST_ACCOUNT"
                $INTERDOMAIN_TRUST_ACCOUNT ++
            }
            { ($UACValue -bor 0x1000) -eq $UACValue } {
                $flags += "WORKSTATION_TRUST_ACCOUNT"
                $WORKSTATION_TRUST_ACCOUNT ++
            }
            { ($UACValue -bor 0x2000) -eq $UACValue } {
                $flags += "SERVER_TRUST_ACCOUNT"
                $SERVER_TRUST_ACCOUNT ++
            }
            { ($UACValue -bor 0x10000) -eq $UACValue } {
                $flags += "DONT_EXPIRE_PASSWORD"
                $DONT_EXPIRE_PASSWORD ++
            }
            { ($UACValue -bor 0x20000) -eq $UACValue } {
                $flags += "MNS_LOGON_ACCOUNT"
                $MNS_LOGON_ACCOUNT ++
            }
            { ($UACValue -bor 0x40000) -eq $UACValue } {
                $flags += "SMARTCARD_REQUIRED"
                $SMARTCARD_REQUIRED ++
            }
            { ($UACValue -bor 0x80000) -eq $UACValue } {
                $flags += "TRUSTED_FOR_DELEGATION"
                $TRUSTED_FOR_DELEGATION ++
            }
            { ($UACValue -bor 0x100000) -eq $UACValue } {
                $flags += "NOT_DELEGATED"
                $NOT_DELEGATED ++
            }
            { ($UACValue -bor 0x200000) -eq $UACValue } {
                $flags += "USE_DES_KEY_ONLY"
                $USE_DES_KEY_ONLY ++
            }
            { ($UACValue -bor 0x400000) -eq $UACValue } {
                $flags += "DONT_REQ_PREAUTH"
                $DONT_REQ_PREAUTH ++
            }
            { ($UACValue -bor 0x800000) -eq $UACValue } {
                $flags += "PASSWORD_EXPIRED"
                $PASSWORD_EXPIRED ++
            }
            { ($UACValue -bor 0x1000000) -eq $UACValue } {
                $flags += "TRUSTED_TO_AUTH_FOR_DELEGATION"
                $TRUSTED_TO_AUTH_FOR_DELEGATION ++
            }
            { ($UACValue -bor 0x04000000) -eq $UACValue } {
                $flags += "PARTIAL_SECRETS_ACCOUNT"
                $PARTIAL_SECRETS_ACCOUNT ++
            }
        }

        $AddToReport = $False
        foreach ($InterestingFlag in $arrInterestingFlags) {
            if ($flags -contains $InterestingFlag) { $AddToReport = $True }
        }

        if ($AddToReport) {
            $obj = New-Object -TypeName PSObject
            $obj | Add-Member -MemberType NoteProperty -Name "Domain" -value $DomainName
            $obj | Add-Member -MemberType NoteProperty -Name "SamAccountName" -value $SamAccountName
            $obj | Add-Member -MemberType NoteProperty -Name "UACValue" -value $UACValue
            $obj | Add-Member -MemberType NoteProperty -Name "Flags" -value ([string]::Join(",", ($flags)))
            $obj | Add-Member -MemberType NoteProperty -Name "LastLogon" -value $lastLogon
            $array += $obj
        }

        $TotalUsersProcessed ++
        if ($ProgressBar) {
            Write-Progress -Activity 'Processing Users' -Status ("Username: {0}" -f $samAccountName) -PercentComplete (($TotalUsersProcessed / $UserCount) * 100)
        }

    }

    if ($OutputSummary) {
        Write-Host -ForegroundColor green "User Account Control Summary:"
        Write-Host -ForegroundColor green "- Processed $UserCount user accounts and calculated the following flags..."
        Write-Host -ForegroundColor green "  - $SCRIPT accounts are set to SCRIPT."
        if ($ProcessDisabledUsers) {
            Write-Host -ForegroundColor green "  - $ACCOUNTDISABLE accounts are set to ACCOUNTDISABLE."
        }
        Write-Host -ForegroundColor green "  - $HOMEDIR_REQUIRED accounts are set to HOMEDIR_REQUIRED."
        Write-Host -ForegroundColor green "  - $LOCKOUT accounts are set to LOCKOUT."
        Write-Host -ForegroundColor red "  - $PASSWD_NOTREQD accounts are set to PASSWD_NOTREQD."
        Write-Host -ForegroundColor yellow "  - $PASSWD_CANT_CHANGE accounts are set to PASSWD_CANT_CHANGE."
        Write-Host -ForegroundColor green "  - $ENCRYPTED_TEXT_PWD_ALLOWED accounts are set to ENCRYPTED_TEXT_PWD_ALLOWED."
        Write-Host -ForegroundColor green "  - $TEMP_DUPLICATE_ACCOUNT accounts are set to TEMP_DUPLICATE_ACCOUNT."
        Write-Host -ForegroundColor green "  - $NORMAL_ACCOUNT accounts are set to NORMAL_ACCOUNT."
        Write-Host -ForegroundColor green "  - $INTERDOMAIN_TRUST_ACCOUNT accounts are set to INTERDOMAIN_TRUST_ACCOUNT."
        Write-Host -ForegroundColor green "  - $WORKSTATION_TRUST_ACCOUNT accounts are set to WORKSTATION_TRUST_ACCOUNT."
        Write-Host -ForegroundColor green "  - $SERVER_TRUST_ACCOUNT accounts are set to SERVER_TRUST_ACCOUNT."
        Write-Host -ForegroundColor yellow "  - $DONT_EXPIRE_PASSWORD accounts are set to DONT_EXPIRE_PASSWORD."
        Write-Host -ForegroundColor green "  - $MNS_LOGON_ACCOUNT accounts are set to MNS_LOGON_ACCOUNT."
        Write-Host -ForegroundColor green "  - $SMARTCARD_REQUIRED accounts are set to SMARTCARD_REQUIRED."
        Write-Host -ForegroundColor yellow "  - $TRUSTED_FOR_DELEGATION accounts are set to TRUSTED_FOR_DELEGATION."
        Write-Host -ForegroundColor green "  - $NOT_DELEGATED accounts are set to NOT_DELEGATED."
        Write-Host -ForegroundColor red "  - $USE_DES_KEY_ONLY accounts are set to USE_DES_KEY_ONLY."
        Write-Host -ForegroundColor red "  - $DONT_REQ_PREAUTH accounts are set to DONT_REQ_PREAUTH."
        Write-Host -ForegroundColor green "  - $PASSWORD_EXPIRED accounts are set to PASSWORD_EXPIRED."
        Write-Host -ForegroundColor red "  - $TRUSTED_TO_AUTH_FOR_DELEGATION accounts are set to TRUSTED_TO_AUTH_FOR_DELEGATION."
        Write-Host -ForegroundColor green "  - $PARTIAL_SECRETS_ACCOUNT accounts are set to PARTIAL_SECRETS_ACCOUNT."
    }

    # Write-Output $array | Format-Table
    $array | Export-Csv -notype -path "$ReferenceFile" -Delimiter ';'

    # Remove the quotes
    (Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-UserAccountControlReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserAccountControlReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
