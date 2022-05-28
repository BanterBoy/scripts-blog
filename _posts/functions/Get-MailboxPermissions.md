---
layout: post
title: Get-MailboxPermissions.ps1
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
[CmdletBinding()]

param(
    [Parameter(Mandatory = $false,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Username or pipe from another command.")]
    [Alias('id')]
    [string[]]
    $Identity

)

BEGIN {}

PROCESS {

    $userMailboxes = Get-Mailbox -Identity $identity
    foreach ($user in $userMailboxes) {
        $Settings = Get-MailboxPermission -Identity $user.Identity
        try {
            $Properties = @{
                RunspaceId      = $Settings.RunspaceId
                AccessRights    = $Settings.AccessRights
                Deny            = $Settings.Deny
                InheritanceType = $Settings.InheritanceType
                User            = $Settings.User
                Identity        = $Settings.Identity
                IsInherited     = $Settings.IsInherited
                IsValid         = $Settings.IsValid
                ObjectState     = $Settings.ObjectState
            }
        }
        catch {
            $Properties = @{
                RunspaceId      = $Settings.RunspaceId
                AccessRights    = $Settings.AccessRights
                Deny            = $Settings.Deny
                InheritanceType = $Settings.InheritanceType
                User            = $Settings.User
                Identity        = $Settings.Identity
                IsInherited     = $Settings.IsInherited
                IsValid         = $Settings.IsValid
                ObjectState     = $Settings.ObjectState
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
    }

}

END {}


<#

.SYNOPSIS
PowerShell script to export Exchange Mailbox permissions.

.DESCRIPTION
The script exports the Mailbox permissions within your Exchange organization.

.PARAMETER File
Optional parameter. Exports the results to file.

.EXAMPLE
.\Get-MailboxPermissionsExport.ps1
Gets Mailbox permissions report for Exchange outputs the results to the screen

.EXAMPLE
.\Get-MailboxPermissionsExport.ps1 -File FileName.csv
Gets Mailbox permissions report for Exchange and exports the results to FileName.csv file.

.LINK
Script author Luke Leigh - http://blog.lukeleigh.com


[CmdletBinding()]

param(
    [Parameter(Mandatory = $False)]
    [ValidateNotNull()]
    [String]$File
)

BEGIN {

}

PROCESS {
    $outPut = @()
    $mailBoxes = Get-Mailbox # | Where-Object { $_.WindowsEmailAddress -like '*specific-domain*' }
    foreach ($mailBox in $mailBoxes) {
        $perms = Get-MailboxPermission $mailBox.Identity | Where-Object { $_.User -notlike "Anonymous" -and $_.User -notlike "Default" }
        foreach ($perm in $perms) {
            if (!$perm) { break }
            $properties = @{
                "Identity"     = $mailbox.Name;
                "User"         = $perm.User;
                "AccessRights" = $perm.AccessRights -join ','
            }
                $Obj = New-Object -TypeName PSObject -Property $Properties

            if (!$File) {
                Write-Output $Obj
            }
            $outPut += $Obj
        }
    }
    if ($File) {
        $outPut | Export-Csv -NoTypeInformation $File
    }
}

END {

}

#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Get-MailboxPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MailboxPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
