---
layout: post
title: SiteNameConsistencyReport.ps1
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
 This script will compare the

 Shay Levy posted the Get the AD site name of a computer function here:
 http://www.powershellmagazine.com/2013/04/23/pstip-get-the-ad-site-name-of-a-computer/

 Microsoft posted a method for retrieving the DynamicSiteName here:
 Problem retrieving Value for DynamicSiteName from Registry using PS: http://support.microsoft.com/kb/2801452

  https://github.com/joethemongoose/PowerCLI/blob/master/Export-VMs-With-SiteCode.ps1

#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$OnlineFile = $(&$ScriptPath) + "\SiteNameConsistency-online.csv"
$OfflineFile = $(&$ScriptPath) + "\SiteNameConsistency-offline.csv"

#-------------------------------------------------------------

Import-Module ActiveDirectory

# Get Domain Controllers
$Computers = Get-ADDomainController -Filter * | Sort-Object Name

# Get All Servers
#$Computers = Get-ADComputer -Filter * -Properties Name,Operatingsystem | Where-Object {$_.Operatingsystem -like "*server*"} | Sort-Object Name

# Get All Authorized DHCP Servers
$defaultNC = ([ADSI]"LDAP://RootDSE").defaultNamingContext.Value
$configurationNC = "cn=configuration," + $defaultNC
$AuthorizedDHCPServers = Get-ADObject -SearchBase $configurationNC -Filter "objectclass -eq 'dhcpclass' -AND Name -ne 'dhcproot'"

#-------------------------------------------------------------

function Get-ComputerSite($ComputerName) {
    $site = nltest /server:$ComputerName /dsgetsite 2>$null
    if ($LASTEXITCODE -eq 0) { $site[0] }
}

function Get-ComputerSiteValue($ComputerName, $Value) {
    $ValueData = ""
    $key = "System\CurrentControlSet\Services\NetLogon\Parameters"
    $type = [Microsoft.Win32.RegistryHive]::LocalMachine
    Try {
        $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($type, $ComputerName)
        $regKey = $regKey.OpenSubKey($key)
        $ValueData = $regKey.GetValue($($Value)).Split([char]0)[0]
    }
    Catch {
        Write-Host -ForegroundColor Red "- $($Value): Could Not Connect to Remote Registry!"
    }
    $ValueData
}

$onlinearray = @()
$offlinearray = @()

ForEach ($Computer in $Computers) {
    $ComputerError = "$false"
    $ComputerName = $Computer.Name
    if (Test-Connection -Cn $Computer.Name -BufferSize 16 -Count 1 -ea 0 -quiet) {
        Write-Host -ForegroundColor Green "Checking Site for $ComputerName"
        $ComputerSite = Get-ComputerSite $ComputerName
        $ComputerDynamicSiteName = Get-ComputerSiteValue $ComputerName DynamicSiteName
        $ComputerSiteName = Get-ComputerSiteValue $ComputerName SiteName
        $DynamicSiteName = $False
        $SiteName = $False

        If ($ComputerDynamicSiteName -ne "") { $DynamicSiteName = $True }
        If ($ComputerSiteName -ne "") { $SiteName = $True }
        If ($SiteName -eq $True) {
            If ($ComputerSite -eq $ComputerSiteName) {
                Write-Host -ForegroundColor Green "- Sites match"
            }
            Else {
                Write-Host -ForegroundColor Red "- Sites do not match"
            }
        }
        ElseIf ($DynamicSiteName -eq $True) {
            If ($ComputerSite -eq $ComputerDynamicSiteName) {
                Write-Host -ForegroundColor Green "- Sites match"
            }
            Else {
                Write-Host -ForegroundColor Red "- Sites do not match"
            }
        }
        Else {
            Write-Host -ForegroundColor Red "- Both the DynamicSiteName and SiteName registry values are missing."
        }
    }
    Else {
        $ComputerError = "$true"
        $ErrorDescription = "Unable to ping server"
        Write-Host -ForegroundColor Red "$ComputerName is offline"
    }
    if ($ComputerError -eq $true) {
        $outputbad = New-Object PSObject
        $outputbad | Add-Member NoteProperty ComputerName $ComputerName
        $outputbad | Add-Member NoteProperty ErrorDescription $ErrorDescription
        $offlinearray += $outputbad
    }
}
$onlinearray | export-csv -notype "$OnlineFile"
$offlinearray | export-CSV -notype "$OfflineFile"

# Remove the quotes
(Get-Content "$OnlineFile") | ForEach-Object { $_ -replace '"', "" } | out-file "$OnlineFile" -Force -Encoding ascii
(Get-Content "$OfflineFile") | ForEach-Object { $_ -replace '"', "" } | out-file "$OfflineFile" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/SiteNameConsistencyReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=SiteNameConsistencyReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
