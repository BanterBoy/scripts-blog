---
layout: post
title: Remove-MailboxFolderPermissions.ps1
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
.SYNOPSIS
Remove-MailboxFolderPermissions.ps1

.DESCRIPTION
A proof of concept script for removing mailbox folder
permissions to all folders in a mailbox.

.OUTPUTS
Console output for progress.

.PARAMETER Mailbox
The mailbox that the folder permissions will be removed from.

.PARAMETER User
The user you are removing mailbox folder permissions for.

.EXAMPLE
.\Remove-MailboxFolderPermissions.ps1 -Mailbox alex.heyne -User alan.reid

This will remove Alan Reid's permissions to all folders in Alex Heyne's mailbox.

.LINK
http://exchangeserverpro.com/powershell-script-remove-permissions-exchange-mailbox/

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Change Log:
V1.00, 12/01/2014 - Initial version
#>

#requires -version 2

[CmdletBinding()]
param (
    [Parameter( Mandatory = $true)]
    [string]$Mailbox,

    [Parameter( Mandatory = $true)]
    [string]$User
)


#...................................
# Variables
#...................................

$exclusions = @("/Sync Issues",
    "/Sync Issues/Conflicts",
    "/Sync Issues/Local Failures",
    "/Sync Issues/Server Failures",
    "/Recoverable Items",
    "/Deletions",
    "/Purges",
    "/Versions"
)


#...................................
# Initialize
#...................................

#Add Exchange 2010 snapin if not already loaded in the PowerShell session
if (!(Get-PSSnapin | Where-Object { $_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010" })) {
    try {
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction STOP
    }
    catch {
        #Snapin was not loaded
        Write-Warning $_.Exception.Message
        EXIT
    }
    . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
    Connect-ExchangeServer -auto -AllowClobber
}


#Set scope to include entire forest
if (!(Get-ADServerSettings).ViewEntireForest) {
    Set-ADServerSettings -ViewEntireForest $true -WarningAction SilentlyContinue
}


#...................................
# Script
#...................................

$mailboxfolders = @(Get-MailboxFolderStatistics $Mailbox | Where-Object { !($exclusions -icontains $_.FolderPath) } | Select-Object FolderPath)

foreach ($mailboxfolder in $mailboxfolders) {
    $folder = $mailboxfolder.FolderPath.Replace("/", "\")
    if ($folder -match "Top of Information Store") {
        $folder = $folder.Replace(“\Top of Information Store”, ”\”)
    }
    $identity = "$($mailbox):$folder"
    Write-Host "Checking $identity for permissions for user $user"
    if (Get-MailboxFolderPermission -Identity $identity -User $user -ErrorAction SilentlyContinue) {
        try {
            Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
            Write-Host -ForegroundColor Green "Removed!"
        }
        catch {
            Write-Warning $_.Exception.Message
        }
    }
}


#...................................
# End
#...................................
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Remove-MailboxFolderPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-MailboxFolderPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
