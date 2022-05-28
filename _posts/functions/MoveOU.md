---
layout: post
title: MoveOU.ps1
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
#Created by Felipe Binotto
#On the 1st of September of 2010
#Move computer to required OU based on it's type

#Gets computer, model and type
$computer = (Get-WmiObject -Class Win32_ComputerSystem).name
$type = Get-WmiObject -Class Win32_SystemEnclosure | Select-Object -ExpandProperty ChassisTypes
#$model = Get-WmiObject -Class Win32_ComputerSystem | select -expandproperty model
$serial = (Get-WmiObject -Class Win32_SystemEnclosure | ForEach-Object {$_.serialnumber}).length

#Search the AD for the computer
$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$root = $dom.GetDirectoryEntry()

$search = [System.DirectoryServices.DirectorySearcher]$root
$search.Filter = "(cn=$computer)"
$result = $search.FindOne()
#Converts the result to the required format
$computerToMove = [ADSI]$result.path

#Move computer to required OU
Try{
if($type -eq 9 -or $type -eq 10){

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=Laptops,DC=domain,DC=com")}

elseif($type -eq 1 -or ($type -eq 3 -and $serial -gt 20)){

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=VDIs,DC=domain,DC=com")}

else{

$computerToMove.psbase.Moveto([ADSI]"LDAP://OU=Desktops,DC=domain,DC=com")}}
Catch{$error > C:\power.txt}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/MoveOU.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=MoveOU.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
