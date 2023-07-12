---
layout: post
title: Export-CalendarPermissions.ps1
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

**_@GitHub Copilot_** - This PowerShell script exports calendar permissions for Exchange mailboxes. The script is divided into three main sections, each corresponding to a different version of Exchange: 2013-2016, O365, and an unspecified version. The script begins by defining a variable `$Version` that is used to determine which section of the script to execute.

The section of the script that is currently selected by the cursor is the section that is executed when `$Version` is set to "O365". This section requires the user to enter their credentials and creates a new PowerShell session with the Exchange server. It then retrieves the mailbox folder permissions for each mailbox and filters out any permissions for the "Anonymous" or "Default" users. The results are then formatted as an object with properties for the mailbox name, email address, user, and access rights. If `$File` is not specified, the results are output to the console. If `$File` is specified, the results are exported to a CSV file.

The other two sections of the script are similar to the selected section, but they do not require the user to enter their credentials or create a new PowerShell session. Instead, they simply retrieve the mailbox folder permissions for each mailbox and filter out any permissions for the "Anonymous" or "Default" users. The results are then formatted as an object with properties for the mailbox name, email address, user, and access rights. If `$File` is not specified, the results are output to the console. If `$File` is specified, the results are exported to a CSV file.

Overall, this script is well-organized and easy to read. However, there are a few ways that it could be improved. For example, the script could benefit from more comments to explain what each section of the script does. Additionally, the script could be made more efficient by using pipeline commands instead of `foreach` loops. Finally, the script could be made more user-friendly by adding more error handling and input validation.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you might use this script:

1. To export calendar permissions for all mailboxes in an Exchange 2013-2016 environment to a CSV file named "CalendarPermissions.csv", you would run the following command:

   ```
   .\Export-CalendarPermissions.ps1 -Version "2013-2016" -File "CalendarPermissions.csv"
   ```

2. To export calendar permissions for all mailboxes in an Office 365 environment to the console, you would run the following command:

   ```
   .\Export-CalendarPermissions.ps1 -Version "O365"
   ```

3. To export calendar permissions for a specific mailbox in an Office 365 environment to a CSV file named "CalendarPermissions.csv", you would run the following command:

   ```
   .\Export-CalendarPermissions.ps1 -Version "O365" -Mailbox "jdoe@example.com" -File "CalendarPermissions.csv"
   ```

In each of these examples, you would need to replace ".\Export-CalendarPermissions.ps1" with the path to the script on your system. Additionally, if you are running the script in an Exchange 2013-2016 environment, you would need to have the Exchange Management Shell installed on your system. If you are running the script in an Office 365 environment, you would need to have the Exchange Online PowerShell module installed on your system.

---

#### Script

```powershell
<#
.SYNOPSIS
PowerShell script to get Exchange Calendar permissions report.

.DESCRIPTION
The script gets Calendar permissions report within your Exchange organization. It also can get a report from Office 365.

.PARAMETER Version
Mandatory parameter. Select between Exchange Versions. It can be 2010, 2013-2016 or O365.

.PARAMETER File
Optional parameter. Exports the results to file.

.EXAMPLE
.\Get-CalendarPermissionsReport.ps1 -Version 2010 -File FileName.csv
Gets calendar permissions report for Exchange 2010 and exports the results to FileName.csv file.

.EXAMPLE
.\Get-CalendarPermissionsReport.ps1 -Version 2013-2016 -File FileName.csv
Gets calendar permissions report for Exchange 2013 or 2016 and exports the results to FileName.csv file.

.EXAMPLE
 .\Get-CalendarPermissionsReport.ps1 -Version O365 -File FileName.csv
Gets calendar permissions report for Exchange Online and exports the results to FileName.csv file. It will ask an Office 365 admin credentials.

.EXAMPLE
.\Get-CalendarPermissionsReport.ps1 -Version O365
Connects to Exchange Online and prints calendar permissions to console.

.LINK
Script author Slava Fedenko - http://blog.fedenko.info
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True)]
    [ValidateSet('2010', '2013-2016', 'O365')]
    [String]$Version,

    [Parameter(Mandatory = $False)]
    [ValidateNotNull()]
    [String]$File

)

if ($Version -like "2010") {
    $Out = @()
    $mbxs = Get-Mailbox | Where-Object { $_.WindowsEmailAddress -like '*SpecificDomain*' }
    foreach ($mbx in $mbxs) {
        $id = $mbx.alias
        $id = $id + ":\Calendar"
        $perms = Get-MailboxFolderPermission -Identity $id | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" }
        foreach ($perm in $perms) {
            if (!$perm) { break }
            $Properties = @{
                "Mailbox"      = $mbx.DisplayName;
                "Email"        = $mbx.windowsemailaddress;
                "User"         = $perm.User;
                "AccessRights" = $perm.AccessRights -join ','
            }
            $Obj = New-Object -TypeName PSObject -Property $Properties

            if (!$File) {
                Write-Output $Obj | Select-Object Mailbox, Email, User, AccessRights
            }
            $Out += $Obj
        }
    }
    if ($File) {
        $Out | Select-Object Mailbox, Email, User, AccessRights | Export-Csv -NoTypeInformation $File
    }
}

if ($Version -like "2013-2016") {
    if (!$File) {
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } }
    }
    if ($File) {
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } | Export-Csv -NoTypeInformation $File
    }
}

if ($Version -like "O365") {
    $UserCredential = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
    Import-PSSession $Session

    if (!$File) {
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } }
    }
    if ($file) {
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission -Identity "$($_.alias):\Calendar" | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" } } | Select-Object Identity, User, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } } | Export-Csv -NoTypeInformation $File
    }
    Remove-PSSession $Session
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Export-CalendarPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-CalendarPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
