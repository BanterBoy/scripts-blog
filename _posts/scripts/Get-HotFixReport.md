---
layout: post
title: Get-HotFixReport.ps1
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
<#

 NAME: Get-HotFixReport.ps1

 AUTHOR: Jan Egil Ring
 EMAIL: jan.egil.ring@powershell.no

 COMMENT: Script to generate an installation-report for specified hotfixes on a set of computers retrieved from Active Directory.

          The script leverages Microsoft`s PowerShell-module for Active Directory to retrieve computers.
          Before running the script, customize the three variables under #Custom variables

          More information: http://blog.powershell.no/2010/10/31/generate-an-installation-report-for-specific-hotfixes-using-windows-powershell

 You have a royalty-free right to use, modify, reproduce, and
 distribute this script file in any way you find useful, provided that
 you agree that the creator, owner above has no warranty, obligations,
 or liability for such use.

 VERSION HISTORY:
 1.0 31.10.2010 - Initial release

#>

#requires -version 2

#Import Active Directory module
Import-Module ActiveDirectory

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

#Custom variables
#$Computers = Get-ADComputer -Filter * -Properties Name,Operatingsystem | Where-Object {$_.Operatingsystem -like "*server*"} | Select-Object Name
$Computers = @()
$HotFix = "KB979744,KB979744,KB983440,KB979099,KB982867,KB977020"
$CsvFilePath = $(&$ScriptPath) + "\Hotfixes.csv"

# Get Computer Name
$ComputerName = (get-content env:COMPUTERNAME)

$Computers += $ComputerName

#Variable for writing progress information
$TotalComputers = ($computers | Measure-Object).Count
$CurrentComputer = 1

#Create array to hold hotfix information
$Export = @()

#Splits the array if more than one hotfix are provided
$Hotfixes = $HotFix.Split(",")

#Loop through every computers
foreach ($computer in $computers) {

    #Loop through every hotfix
    foreach ($hotfix in $hotfixes) {
        #Write progress information
        Write-Progress -Activity "Checking for hotfix $hotfix..." -Status "Current computer: $computer" -Id 1 -PercentComplete (($CurrentComputer / $TotalComputers) * 100)

        #Create a custom object for each hotfix
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -Name Hotfix -Value $hotfix -MemberType NoteProperty
        $obj | Add-Member -Name Computer -Value $computer -MemberType NoteProperty

        #Check if hotfix are installed
        try {
            if (Test-Connection -Count 1 -ComputerName $computer -Quiet) {
                Get-HotFix -Id $hotfix -ComputerName $computer -ea stop | Out-Null
                $obj | Add-Member -Name HotfixInstalled -Value $true -MemberType NoteProperty
                $obj | Add-Member -Name ErrorEncountered -Value "None" -MemberType NoteProperty
            }
            else {
                $obj | Add-Member -Name HotfixInstalled -Value $false -MemberType NoteProperty
                $obj | Add-Member -Name ErrorEncountered -Value $error[0].Exception.Message -MemberType NoteProperty
            }
        }

        catch {
            $obj | Add-Member -Name HotfixInstalled -Value $false -MemberType NoteProperty
            $obj | Add-Member -Name ErrorEncountered -Value $error[0].Exception.Message -MemberType NoteProperty
        }

        #Add the custom object to the array to be exported
        $Export += $obj

    }

    #Increase counter variable
    $CurrentComputer ++

}

#Export the array with hotfix-information to the user-specified path
$Export | Export-Csv -Path $CsvFilePath -NoTypeInformation
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/windowsUpdates/Get-HotFixReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-HotFixReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
