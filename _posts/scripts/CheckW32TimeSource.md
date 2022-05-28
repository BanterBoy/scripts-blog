---
layout: post
title: CheckW32TimeSource.ps1
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
  Check W32 Time Source and Configuration Report

  This script will test the connection to each servers and allows for
  the following errors:
  - Access is denied
  - The procedure number is out of range
  - The RPC server is unavailable

  Release 1.0 Written by Jeremy@jhouseconsulting.com 20th November 2013
#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$OnlineFile = $(&$ScriptPath) + "\W32TimeSource-online.csv"
$OfflineFile = $(&$ScriptPath) + "\W32TimeSource-offline.csv"

#-------------------------------------------------------------

Import-Module ActiveDirectory

# Get Domain Controllers
#$Computers = Get-ADDomainController -Filter * | Sort-Object Name

# Get All Servers
$Computers = Get-ADComputer -Filter * -Properties Name, Operatingsystem | Where-Object { $_.Operatingsystem -like "*server*" } | Sort-Object Name

#-------------------------------------------------------------

$onlinearray = @()
$offlinearray = @()

ForEach ($Computer in $Computers) {
    $ComputerError = "$false"
    if (Test-Connection -Cn $Computer.Name -BufferSize 16 -Count 1 -ea 0 -quiet) {
        Write-Host -ForegroundColor Green "Checking time source and configuration of"($Computer.Name)

        $TimeSource = w32tm /query /computer:$($Computer.Name) /source
        If ($TimeSource -notmatch "The following error occurred") {
            $TimeSource = $TimeSource.Trim()
        }
        Else {
            $ComputerError = "$true"
            $ErrorDescription = $TimeSource
            Write-Host -ForegroundColor Red "There was an error contacting"($Computer.Name)
        }
        $TimeConfiguration = w32tm /query /computer:$($Computer.Name) /configuration /verbose
        If ($TimeConfiguration -notmatch "The following error occurred") {
            $AnnounceFlags = $TimeConfiguration | Select-String -pattern "AnnounceFlags:"
            $AnnounceFlags = $AnnounceFlags.ToString().Split("(")
            $AnnounceFlags = $AnnounceFlags[0].ToString().Split(":")
            $AnnounceFlags = $AnnounceFlags[1].Trim()
            $Type = $TimeConfiguration | Select-String -pattern "Type:"
            $Type = $Type.ToString().Split("(")
            $Type = $Type[0].ToString().Split(":")
            $Type = $Type[1].Trim()
            $NtpServer = $TimeConfiguration | Select-String -pattern "NtpServer:"
            $NtpServer = $NtpServer.ToString().Split("(")
            $NtpServer = $NtpServer[0].ToString().Split(":")
            $NtpServer = $NtpServer[1].Trim()
            If ($NtpServer -eq "") { $NtpServer = "Undefined or NotUsed" }

            $output = New-Object PSObject
            $output | Add-Member NoteProperty -Name "ComputerName" $Computer.Name
            $output | Add-Member NoteProperty -Name "TimeSource" $TimeSource
            $output | Add-Member NoteProperty -Name "Type" $Type
            $output | Add-Member NoteProperty -Name "AnnounceFlags" $AnnounceFlags
            $output | Add-Member NoteProperty -Name "NtpServer" $NtpServer
            $onlinearray += $output
        }
        Else {
            $ComputerError = "$true"
            $ErrorDescription = $TimeConfiguration
            Write-Host -ForegroundColor Red "There was an error contacting"($Computer.Name)
        }
    }
    Else {
        $ComputerError = "$true"
        $ErrorDescription = "Unable to ping server"
        Write-Host -ForegroundColor Red ($Computer.Name)"is offline"
    }
    if ($ComputerError -eq $true) {
        $outputbad = New-Object PSObject
        $outputbad | Add-Member NoteProperty ComputerName $Computer.Name
        $outputbad | Add-Member NoteProperty ErrorDescription $ErrorDescription
        $offlinearray += $outputbad
    }
}
$onlinearray | Export-Csv -notype "$OnlineFile" -Delimiter ';'
$offlinearray | Export-Csv -notype "$OfflineFile"

# Remove the quotes
(Get-Content "$OnlineFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OnlineFile" -Force -Encoding ascii
(Get-Content "$OfflineFile") | ForEach-Object { $_ -replace '"', "" } | out-file "$OfflineFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CheckW32TimeSource.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CheckW32TimeSource.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
