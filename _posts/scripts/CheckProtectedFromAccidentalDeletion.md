---
layout: post
title: CheckProtectedFromAccidentalDeletion.ps1
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
# This script will check if all OU's and default top level Containers
# have been protected from accidental deletion.

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

$ReferenceFile = $(&$ScriptPath) + "\CheckProtectedFromAccidentalDeletion.csv"

# Import the Modules
Import-Module -Name ActiveDirectory
$defaultNamingContext = (Get-ADRootDSE).defaultnamingcontext

$array = @()

# Check protection on all OU's
$OUs = Get-ADOrganizationalUnit -Filter * -Properties ProtectedFromAccidentalDeletion | Where-Object { $_.ProtectedFromAccidentalDeletion -match "False" }
Write-Host -ForegroundColor Red "The following"$OUs.Count"OUs have not been protected from accidental deletion..."
ForEach ($OU in $OUs) {
    $output = New-Object PSObject
    $output | Add-Member NoteProperty objectClass ($OU.objectClass)
    $output | Add-Member NoteProperty DistinguishedName ($OU.DistinguishedName)
    $output | Add-Member NoteProperty Description ($OU.Description)
    $array += $output
}

# Check protection on all default top level Containers
$Containers = Get-ADObject -Filter 'objectClass -eq "container"' -SearchBase $defaultNamingContext -SearchScope OneLevel -Properties ProtectedFromAccidentalDeletion | Where-Object { $_.ProtectedFromAccidentalDeletion -match "False" }
Write-Host -ForegroundColor Green "The following"$Containers.Count"top level containers have not been protected from accidental deletion..."
ForEach ($Container in $Containers) {
    $output = New-Object PSObject
    $output | Add-Member NoteProperty objectClass ($Container.objectClass)
    $output | Add-Member NoteProperty DistinguishedName ($Container.DistinguishedName)
    $output | Add-Member NoteProperty Description ($Container.Description)
    $array += $output
}

$array | Export-Csv -NoTypeInformation "$ReferenceFile" -Delimiter ";"

# Remove the quotes
(Get-Content "$ReferenceFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$ReferenceFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CheckProtectedFromAccidentalDeletion.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CheckProtectedFromAccidentalDeletion.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
