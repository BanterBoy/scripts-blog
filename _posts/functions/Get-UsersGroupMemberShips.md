---
layout: post
title: Get-UsersGroupMemberShips.ps1
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
  Get-UsersGroupMemberShips.ps1
  How Can I Generate a List of All Groups of Which a User Is a Member?
  - http://blogs.technet.com/b/heyscriptingguy/archive/2009/10/08/hey-scripting-guy-october-8-2009.aspx

#>

#-------------------------------------------------------------

Function New-Underline($Text) {
    "`n$Text`n$(`"-`" * $Text.length)"
} #end New-UnderLine

Function Test-DotNetFrameWork35 {
    Test-path -path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5'
} #end Test-DotNetFrameWork35

Function Get-UserPrincipal($cName, $cContainer, $userName) {
    $dsam = "System.DirectoryServices.AccountManagement"
    $rtn = [reflection.assembly]::LoadWithPartialName($dsam)
    $cType = "domain" #context type
    $iType = "SamAccountName"
    $dsamUserPrincipal = "$dsam.userPrincipal" -as [type]
    $principalContext = new-object "$dsam.PrincipalContext"($cType, $cName, $cContainer)
    $dsamUserPrincipal::FindByIdentity($principalContext, $iType, $userName)
} # end Get-UserPrincipal


If (-not(Test-DotNetFrameWork35)) { "Requires .NET Framework 3.5" ; exit }

#-------------------------------------------------------------

[string]$userName = "admintbird"
[string]$cName = "fmg.local"
[string]$cContainer = "DC=FMG,DC=local"

#-------------------------------------------------------------

$userPrincipal = Get-UserPrincipal -userName $userName -cName $cName -cContainer $cContainer

New-UnderLine -Text "Direct Group MemberShip:"
$userPrincipal.getGroups() | ForEach-Object { $_.name }

New-UnderLine -Text "Indirect Group Membership:"
$userPrincipal.GetAuthorizationGroups()  | ForEach-Object { $_.name }
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-UsersGroupMemberShips.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UsersGroupMemberShips.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
