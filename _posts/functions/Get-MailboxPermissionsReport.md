---
layout: post
title: Get-MailboxPermissionsReport.ps1
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
    .SYNOPSIS
    Dump mailbox folder permissions to CSV file

       Thomas Stensitzki

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

    Version 1.1, 2016-08-30

    Ideas, comments and suggestions to support@granikos.eu

    This script is based on Mr Tony Redmonds blog post http://thoughtsofanidlemind.com/2014/09/05/reporting-delegate-access-to-exchange-mailboxes/

    .LINK
    More information can be found at http://www.granikos.eu/en/scripts

    .DESCRIPTION
    This script exports all mailbox folder permissions for mailboxes of type "UserMailbox".

    The permissions are exported to a local CSV file

    The script is inteded to run from within an active Exchange 2013 Management Shell session.

    .NOTES
    Requirements
    - Windows Server 2012 or Windows Server 2012 R2

    Revision History
    --------------------------------------------------------------------------------
    1.0     Initial community release
    1.1     Minor PowerShell fix

    .PARAMETER CsvFileName
    CSV file name

    .EXAMPLE
    Export mailbox permissions to export.csv

    .\Get-MailboxPermissionsReport-ps1 -CsvFileName export.csv

#>
Param(
    [parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = 'CSV file name')]
    [string]$CsvFileName = 'MailboxPermissions.csv'
)

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptName = $MyInvocation.MyCommand.Name

$OutputFile = Join-Path $ScriptDir -ChildPath $CsvFileName

Write-Verbose $OutputFile

# Fetch mailboxes of type UserMailbox only
$Mailboxes = Get-Mailbox -RecipientTypeDetails 'UserMailbox' -ResultSize Unlimited | Sort-Object

$result = @()

# counter for progress bar
$MailboxCount = ($Mailboxes | Measure-Object).Count
$count = 1

ForEach ($Mailbox in $Mailboxes) {
    $Alias = '' + $Mailbox.Name
    $DisplayName = "$($Mailbox.DisplayName) ($($Mailbox.Name))"

    $activity = "Working... [$($count)/$($mailboxCount)]"
    $status = "Getting folders for mailbox: $($DisplayName)"
    Write-Progress -Status $status -Activity $activity -PercentComplete (($count / $MailboxCount) * 100)

    # Fetch fodlers
    $Folders = Get-MailboxFolderStatistics $Alias | % { $_.folderpath } | % { $_.replace('/', '\') }

    ForEach ($Folder in $Folders) {
        $FolderKey = $Alias + ':' + $Folder
        $Permissions = Get-MailboxFolderPermission -identity $FolderKey -ErrorAction SilentlyContinue
        $result += $Permissions | Where-Object { $_.User -notlike 'Default' -and $_.User -notlike 'Anonymous' -and $_.AccessRights -notlike 'None' -and $_.AccessRights -notlike 'Owner' } | Select-Object @{name = 'Mailbox'; expression = { $DisplayName } }, FolderName, @{name = 'User'; expression = { $_.User -join ',' } }, @{name = 'AccessRights'; expression = { $_.AccessRights -join ',' } }
    }
    # Increment counter
    $count++
}

# Export to CSV
$result | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8 -Delimiter ';' -Force
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Get-MailboxPermissionsReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MailboxPermissionsReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
