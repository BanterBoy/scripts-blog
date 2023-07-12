---
layout: post
title: Get-RODCPasswordRPs.ps1
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
  This script will find all Read-Only Domain Controllers (RODCs) and report
  on the Allowed and Denied Password Replication Policies (PRPs) on each one.

  Script Name: Get-RODCPRPs.ps1
  Release 1.0
  Written by Jeremy@jhouseconsulting.com 29/1/2014

  References:
  - http://technet.microsoft.com/en-us/library/cc730883(v=ws.10).aspx
  - http://blogs.technet.com/b/heyscriptingguy/archive/2013/12/17/use-powershell-to-work-with-rodc-accounts.aspx
  - http://gallery.technet.microsoft.com/scriptcenter/Get-ADRodcAuthenticatedNotR-daf51490
  - http://gunnalag.com/2011/12/25/rodc-filtered-attribute-set-credential-caching-and-the-authentication-process-with-an-rodc/
  - http://blogs.dirteam.com/blogs/paulbergson/archive/2010/09/22/rodc-password-replication-group-management.aspx
  - http://technet.microsoft.com/nl-nl/library/cc835090(v=ws.10).aspx
  - http://blogs.metcorpconsulting.com/tech/?p=1096
  - Refer to the section on Password Replication Policies in chapter 9 of the
    O'Reilly Active Directoy 5th Edition book under the Read-Only Domain
    Controllers section.
#>

#-------------------------------------------------------------

# Import the Active Directory Module
Import-Module ActiveDirectory -WarningAction SilentlyContinue
if ($Error.Count -eq 0) {
    #Write-Host "Successfully loaded Active Directory Powershell's module`n" -ForeGroundColor Green
}
else {
    Write-Host "Error while loading Active Directory Powershell's module : $Error`n" -ForeGroundColor Red
    exit
}

#-------------------------------------------------------------

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$ReferenceFile = $(&$ScriptPath) + "\RODCPRPReport.csv"

$array = @()

$RODCs = Get-ADDomainController -Filter { IsReadOnly -eq $true }

foreach ($RODC in $RODCs) {

    $Allowed = Get-ADDomainControllerPasswordReplicationPolicy -Allowed -Identity $RODC

    $Denied = Get-ADDomainControllerPasswordReplicationPolicy -Denied -Identity $RODC

    $AllowArray = @()
    $DeniedArray = @()

    foreach ($Allow in $Allowed) {
        $AllowArray += $Allow.Name
    }
    foreach ($Deny in $Denied) {
        $DeniedArray += $Deny.Name
    }

    $output = New-Object PSObject
    $output | Add-Member NoteProperty -Name "RODC" $RODC.Name
    $output | Add-Member NoteProperty -Name "Allowed" ($AllowArray -join "|")
    $output | Add-Member NoteProperty -Name "Denied" ($DeniedArray -join "|")
    $array += $output

}

# Write-Output $array | Format-Table
$array | Export-Csv -notype -path "$ReferenceFile"

# Remove the quotes
(Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-RODCPasswordRPs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RODCPasswordRPs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
