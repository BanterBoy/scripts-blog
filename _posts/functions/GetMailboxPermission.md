---
layout: post
title: GetMailboxPermission.ps1
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
#Accept input paramenters
param(
    [switch]$FullAccess,
    [switch]$SendAs,
    [switch]$SendOnBehalf,
    [switch]$UserMailboxOnly,
    [switch]$AdminsOnly,
    [string]$MBNamesFile,
    [string]$UserName,
    [string]$Password,
    [switch]$MFA
)


function Print_Output {
    #Get admin roles assigned to user
    if ($RolesAssigned -eq "") {
        $Roles = (Get-MsolUserRole -UserPrincipalName $upn).Name
        if ($Roles.count -eq 0) {
            $RolesAssigned = "No roles"
        }
        else {
            foreach ($Role in $Roles) {
                $RolesAssigned = $RolesAssigned + $Role
                if ($Roles.indexof($role) -lt (($Roles.count) - 1)) {
                    $RolesAssigned = $RolesAssigned + ","
                }
            }
        }
    }
    #Mailbox type based filter
    if (($UserMailboxOnly.IsPresent) -and ($MBType -ne "UserMailbox")) {
        $Print = 0
    }

    #Admin Role based filter
    if (($AdminsOnly.IsPresent) -and ($RolesAssigned -eq "No roles")) {
        $Print = 0
    }

    #Print Output
    if ($Print -eq 1) {
        $Result = @{'DisplayName' = $_.Displayname; 'UserPrinciPalName' = $upn; 'MailboxType' = $MBType; 'AccessType' = $AccessType; 'UserWithAccess' = $userwithAccess; 'Roles' = $RolesAssigned }
        $Results = New-Object PSObject -Property $Result
        $Results | select-object DisplayName, UserPrinciPalName, MailboxType, AccessType, UserWithAccess, Roles | Export-Csv -Path $ExportCSV -Notype -Append
    }
}

#Getting Mailbox permission
function Get_MBPermission {
    $upn = $_.UserPrincipalName
    $DisplayName = $_.Displayname
    $MBType = $_.RecipientTypeDetails
    $Print = 0
    Write-Progress -Activity "`n     Processed mailbox count: $MBUserCount "`n"  Currently Processing: $DisplayName"

    #Getting delegated Fullaccess permission for mailbox
    if (($FilterPresent -eq 'False') -or ($FullAccess.IsPresent)) {
        $FullAccessPermissions = (Get-MailboxPermission -Identity $upn | Where-Object { ($_.AccessRights -contains "FullAccess") -and ($_.IsInherited -eq $false) -and -not ($_.User -match "NT AUTHORITY" -or $_.User -match "S-1-5-21") }).User
        if ([string]$FullAccessPermissions -ne "") {
            $Print = 1
            $UserWithAccess = ""
            $AccessType = "FullAccess"
            foreach ($FullAccessPermission in $FullAccessPermissions) {
                $UserWithAccess = $UserWithAccess + $FullAccessPermission
                if ($FullAccessPermissions.indexof($FullAccessPermission) -lt (($FullAccessPermissions.count) - 1)) {
                    $UserWithAccess = $UserWithAccess + ","
                }
            }
            Print_Output
        }
    }

    #Getting delegated SendAs permission for mailbox
    if (($FilterPresent -eq 'False') -or ($SendAs.IsPresent)) {
        $SendAsPermissions = (Get-RecipientPermission -Identity $upn | Where-Object { -not (($_.Trustee -match "NT AUTHORITY") -or ($_.Trustee -match "S-1-5-21")) }).Trustee
        if ([string]$SendAsPermissions -ne "") {
            $Print = 1
            $UserWithAccess = ""
            $AccessType = "SendAs"
            foreach ($SendAsPermission in $SendAsPermissions) {
                $UserWithAccess = $UserWithAccess + $SendAsPermission
                if ($SendAsPermissions.indexof($SendAsPermission) -lt (($SendAsPermissions.count) - 1)) {
                    $UserWithAccess = $UserWithAccess + ","
                }
            }
            Print_Output
        }
    }

    #Getting delegated SendOnBehalf permission for mailbox
    if (($FilterPresent -eq 'False') -or ($SendOnBehalf.IsPresent)) {
        $SendOnBehalfPermissions = $_.GrantSendOnBehalfTo
        if ([string]$SendOnBehalfPermissions -ne "") {
            $Print = 1
            $UserWithAccess = ""
            $AccessType = "SendOnBehalf"
            foreach ($SendOnBehalfPermissionDN in $SendOnBehalfPermissions) {
                $SendOnBehalfPermission = (Get-Mailbox -Identity $SendOnBehalfPermissionDN).UserPrincipalName
                $UserWithAccess = $UserWithAccess + $SendOnBehalfPermission
                if ($SendOnBehalfPermissions.indexof($SendOnBehalfPermission) -lt (($SendOnBehalfPermissions.count) - 1)) {
                    $UserWithAccess = $UserWithAccess + ","
                }
            }
            Print_Output
        }
    }
}



function main {
    #Connect AzureAD and Exchange Online from PowerShell
    Get-PSSession | Remove-PSSession

    #Check for MSOnline module
    $Modules = Get-Module -Name MSOnline -ListAvailable
    if ($Modules.count -eq 0) {
        Write-Host  Please install MSOnline module using below command: -ForegroundColor yellow
        Write-Host Install-Module MSOnline
        Exit
    }

    #Authentication using MFA
    if ($MFA.IsPresent) {
        $MFAExchangeModule = ((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter CreateExoPSSession.ps1 -Recurse ).FullName | Select-Object -Last 1)
        If ($MFAExchangeModule -eq $null) {
            Write-Host  `nPlease install Exchange Online MFA Module.  -ForegroundColor yellow

            Write-Host You can install module using below blog : `nLink `nOR you can install module directly by entering "Y"`n
            $Confirm = Read-Host Are you sure you want to install module directly? [Y] Yes [N] No
            if ($Confirm -match "[yY]") {
                Write-Host Yes
                Start-Process "iexplore.exe" "https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application"
            }
            else {
                Start-Process 'https://http://o365reports.com/2019/04/17/connect-exchange-online-using-mfa/'
                Exit
            }
            $Confirmation = Read-Host Have you installed Exchange Online MFA Module? [Y] Yes [N] No

            if ($Confirmation -match "[yY]") {
                $MFAExchangeModule = ((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter CreateExoPSSession.ps1 -Recurse ).FullName | Select-Object -Last 1)
                If ($MFAExchangeModule -eq $null) {
                    Write-Host Exchange Online MFA module is not available -ForegroundColor red
                    Exit
                }
            }
            else {
                Write-Host Exchange Online PowerShell Module is required
                Start-Process 'https://http://o365reports.com/2019/04/17/connect-exchange-online-using-mfa/'
                Exit
            }
        }

        #Importing Exchange MFA Module
        . "$MFAExchangeModule"
        Write-Host Enter credential in prompt to connect to Exchange Online
        Connect-EXOPSSession -WarningAction SilentlyContinue
        Write-Host Connected to Exchange Online
        Write-Host `nEnter credential in prompt to connect to MSOnline
        #Importing MSOnline Module
        Connect-MsolService | Out-Null
        Write-Host Connected to MSOnline `n`nReport generation in progress...
    }
    #Authentication using non-MFA
    else {
        #Storing credential in script for scheduling purpose/ Passing credential as parameter
        if (($UserName -ne "") -and ($Password -ne "")) {
            $SecuredPassword = ConvertTo-SecureString -AsPlainText $Password -Force
            $Credential = New-Object System.Management.Automation.PSCredential $UserName, $SecuredPassword
        }
        else {
            $Credential = Get-Credential -Credential $null
        }
        Connect-MsolService -Credential $credential
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection
        Import-PSSession $Session -CommandName Get-Mailbox, Get-MailboxPermission, Get-RecipientPermission -FormatTypeName * -AllowClobber | Out-Null
    }

    #Set output file
    $ExportCSV = ".\MBPermission_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm` tt).ToString()).csv"
    $Result = ""
    $Results = @()
    $MBUserCount = 0
    $RolesAssigned = ""

    #Check for AccessType filter
    if (($FullAccess.IsPresent) -or ($SendAs.IsPresent) -or ($SendOnBehalf.IsPresent))
    { }
    else {
        $FilterPresent = 'False'
    }

    #Check for input file
    if ($MBNamesFile -ne "") {
        #We have an input file, read it into memory
        $MBs = @()
        $MBs = Import-Csv -Header "DisplayName" $MBNamesFile
        foreach ($item in $MBs) {
            Get-Mailbox -Identity $item.displayname | ForEach-Object {
                $MBUserCount++
                Get_MBPermission
            }
        }
    }
    #Getting all User mailbox
    else {
        Get-mailbox -ResultSize Unlimited | Where-Object { $_.DisplayName -notlike "Discovery Search Mailbox" } | ForEach-Object {
            $MBUserCount++
            Get_MBPermission }
    }


    #Open output file after execution
    Write-Host `nScript executed successfully
    if ((Test-Path -Path $ExportCSV) -eq "True") {
        Write-Host "Detailed report available in: $ExportCSV"
        $Prompt = New-Object -ComObject wscript.shell
        $UserInput = $Prompt.popup("Do you want to open output file?",`
            0, "Open Output File", 4)
        If ($UserInput -eq 6) {
            Invoke-Item "$ExportCSV"
        }
    }
    Else {
        Write-Host No mailbox found that matches your criteria.
    }
    #Clean up session
    Get-PSSession | Remove-PSSession
}
. main
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/GetMailboxPermission.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=GetMailboxPermission.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
