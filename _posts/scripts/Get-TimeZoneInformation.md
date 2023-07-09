---
layout: post
title: Get-TimeZoneInformation.ps1
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
  This script will get the TimeZone information for all servers in the
  domain and create a CSV file.

  Script Name: Get-TimeZoneInformation.ps1
  Release 1.1
  Modified by Jeremy@jhouseconsulting.com 24th February 2014
  Written by Jeremy@jhouseconsulting.com 20th November 2013

  To retrieve the timezone information can use one of four methods.

  1) The tzutil.exe utility
     tzutil does not have an option to connect to a remote computer, so we use the invoke-command cmdlet
     to connect via WinRM and execute the command.
       invoke-command -ComputerName PTHMSADDS02 {tzutil /g}
     Some have reported that this is not reliable and you should use a Windows PowerShell session
     (PSSession)
       $session = New-PSSession -ComputerName PTHMSADDS02
       $result = Invoke-Command -Session $session {tzutil /g}
       $result
       Remove-PSSession -Session $session

  2) The Win32_TimeZone WMI Class
  The DaylightBias property is a 32-bit integer that specifies the bias in minutes. It is a property of
  the SPTimeZoneInformation structure gets the bias in the number of minutes that daylight time for the
  time zone differs from Coordinated Universal Time (UTC).
  ie. the DaylightBias property gets the difference, in minutes, between UTC and local time (in daylight
  savings time). UTC = local time + bias.

  3) The System.TimeZone .Net Framework class
     This method can only retrieve local timezone information.

  4) The Registry
     HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation

  There is a better chance that the WMI (RPC) ports are open to remote computers than WinRM, and sometimes
  WinRM isn't event enabled, so I choose to use the WMI method. We could also use the remote registry method.

  Note that setting the timezone information from a command line or script can only be done via tzutil.
  Therefore, if you were to script it using PowerShell it would need to be wrapped with the invoke-command
  cmdlet.

#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$OnlineFile = $(&$ScriptPath) + "\TimeZone-online.csv"
$OfflineFile = $(&$ScriptPath) + "\TimeZone-offline.csv"

# Set this value to true if you want to see the progress bar.
$ProgressBar = $True

#-------------------------------------------------------------

Import-Module ActiveDirectory

# Get Domain Controllers
#$Computers = Get-ADDomainController -Filter * | Sort-Object Name

# Get All Servers filtering out Cluster Name Objects (CNOs) and Virtual computer Objects (VCOs)
$Computers = Get-ADComputer -Filter * -Properties Name, Operatingsystem | Where-Object { ($_.Operatingsystem -like '*server*') -AND !($_.serviceprincipalname -like '*MSClusterVirtualServer*') } | Sort-Object Name

#-------------------------------------------------------------

$Count = $Computers.Count
$TotalProcessed = 0
$onlinearray = @()
$offlinearray = @()

foreach ($Computer in $Computers) {
    $ComputerError = "$false"
    if (Test-Connection -Cn $Computer.Name -BufferSize 16 -Count 1 -ea 0 -quiet) {
        Write-Host -ForegroundColor Green "Checking time source and configuration of"($Computer.Name)
        try {
            # Make all errors terminating
            $ErrorActionPreference = "Stop"
            $TimeZone = Get-WmiObject -Class Win32_TimeZone -ComputerName $($Computer.Name) | select DaylightBias, Caption, Bias, StandardBias, Description, DaylightName, StandardName
            $Caption = $TimeZone.Caption
            $Bias = $TimeZone.Bias
            $DaylightBias = $TimeZone.DaylightBias
            $output = New-Object PSObject
            $output | Add-Member NoteProperty -Name "ComputerName" $Computer.Name
            $output | Add-Member NoteProperty -Name "TimeZone" $Caption
            $output | Add-Member NoteProperty -Name "Bias" $Bias
            $output | Add-Member NoteProperty -Name "DaylightBias" $DaylightBias
            $onlinearray += $output
        }
        catch {
            $ErrorDescription = $_.Exception.Message
            Write-Host -ForegroundColor Red "Failed to access"$Computer.Name": "$_.Exception.Message
            $ComputerError = "$true"
        }
        finally {
            # Reset the error action pref to default
            $ErrorActionPreference = "Continue"
        }
    }
    else {
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
    $TotalProcessed ++
    if ($ProgressBar) {
        Write-Progress -Activity 'Processing Users' -Status ("Username: {0}" -f $($Computer.Name)) -PercentComplete (($TotalProcessed / $Count) * 100)
    }
}
$onlinearray | Export-Csv -notype "$OnlineFile" -Delimiter ';'
$offlinearray | Export-Csv -notype "$OfflineFile"

# Remove the quotes
(Get-Content "$OnlineFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OnlineFile" -Fo -En ascii
(Get-Content "$OfflineFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OfflineFile" -Fo -En ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/time/Get-TimeZoneInformation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TimeZoneInformation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
