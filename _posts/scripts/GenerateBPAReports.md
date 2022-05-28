---
layout: post
title: GenerateBPAReports.ps1
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
  This script will invoke the Best Practices Analyzer (BPA) on all valid server roles.

  Notes:
    The BPA scan will fail if the PowerShell Execution Policy has been enabled via a GPO as per Microsoft TechNet article KB2028818.
    The BPA for the File Services role is only available after the installation of hotfix KB981111.


  It is based on the following script:
    - Invoke Best Practices Analyzer on remote servers using PowerShell by Jan Egil Ring:
      http://blog.powershell.no/2010/08/17/invoke-best-practices-analyzer-on-remote-servers-using-powershell

  Release 1.1
  Modified by Jeremy@jhouseconsulting.com 12th December 2011
#>

#-------------------------------------------------------------

# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }

#Initial variables, these must be customized
$servers = @()
$CSVReport = $true
$CSVReportPath = $(&$ScriptPath) + "\BPAReports"
$HTMLReport = $true
$HTMLReportPath = $(&$ScriptPath) + "\BPAReports"
$ReportAllSevereties = $false

# Change the value $oldTime in order to set a limit for files to be deleted.
$oldTime = [int]7 # 7 days

# Import the Modules
Import-Module ActiveDirectory
Import-Module ServerManager
Import-Module BestPractices

# Get Domain Info
$ADInfo = Get-ADDomain
$ADDomainDNSRoot = $ADInfo.DNSRoot


# Get Domain Controllers
$Servers = Get-ADDomainController -Filter *

# Get All Servers
#$Servers = Get-ADComputer -Filter * -Properties Name,Operatingsystem | Where-Object {$_.Operatingsystem -like "*server*"}

ForEach ($Server in $Servers) {

    $ModelsToRun = @()

    if ((Get-WindowsFeature Application-Server).Installed) {
        $ModelsToRun += "Microsoft/Windows/ApplicationServer"
    }

    if ((Get-WindowsFeature AD-Certificate).Installed) {
        $ModelsToRun += "Microsoft/Windows/CertificateServices"
    }

    if ((Get-WindowsFeature DHCP).Installed) {
        $ModelsToRun += "Microsoft/Windows/DHCP"
    }

    if ((Get-WindowsFeature AD-Domain-Services).Installed) {
        $ModelsToRun += "Microsoft/Windows/DirectoryServices"
    }

    if ((Get-WindowsFeature DNS).Installed) {
        $ModelsToRun += "Microsoft/Windows/DNSServer"
    }

    if ((Get-WindowsFeature File-Services).Installed) {
        $ModelsToRun += "Microsoft/Windows/FileServices"
    }

    if ((Get-WindowsFeature Hyper-V).Installed) {
        $ModelsToRun += "Microsoft/Windows/Hyper-V"
    }

    if ((Get-WindowsFeature NPAS).Installed) {
        $ModelsToRun += "Microsoft/Windows/NPAS"
    }

    if ((Get-WindowsFeature Remote-Desktop-Services).Installed) {
        $ModelsToRun += "Microsoft/Windows/TerminalServices"
    }

    if ((Get-WindowsFeature Web-Server).Installed) {
        $ModelsToRun += "Microsoft/Windows/WebServer"
    }

    if ((Get-WindowsFeature OOB-WSUS).Installed) {
        $ModelsToRun += "Microsoft/Windows/WSUS"
    }

    if ($ModelsToRun.Count -ne 0) {

        foreach ($BestPracticesModelId in $ModelsToRun) {

            #Path-variables
            $date = Get-Date -Format "dd-MM-yy_HH-mm"
            $BPAName = $BestPracticesModelId.Replace("Microsoft/Windows/", "")
            $CSVPath = $CSVReportPath + "\" + $server.Name + "-" + $BPAName + "-" + $date + ".csv"
            $HTMLPath = $HTMLReportPath + "\" + $server.Name + "-" + $BPAName + "-" + $date + ".html"

            #HTML-header
            $Head = "
      <title>BPA Report for $BestPracticesModelId on $server.Name</title>
      <style type='text/css'>
        table  { border-collapse: collapse; width: 700px }
        body   { font-family: Arial }
        td, th { border-width: 2px; border-style: solid; text-align: left; padding: 2px 4px; border-color: black }
        th     { background-color: grey }
        td.Red { color: Red }
      </style>"

            #Invoke BPA Model
            write-host "Invoking the $BPAName model..."
            Invoke-BpaModel -BestPracticesModelId $BestPracticesModelId | Out-Null

            #Include all severeties in BPA Report if enabled. If not, only errors and warnings are reported.
            if ($ReportAllSevereties) {
                $BPAResults = Get-BpaResult -BestPracticesModelId $BestPracticesModelId
            }
            else {
                $BPAResults = Get-BpaResult -BestPracticesModelId $BestPracticesModelId | Where-Object { $_.Severity -eq "Error" -or $_.Severity -eq "Warning" }
                #$BPAResults = Get-BpaResult -BestPracticesModelId $BestPracticesModelId | Where-Object {$_.Severity -ne "Information"}
            }

            #Send BPA Results to CSV-file if enabled
            if ($BPAResults -and $CSVReport) {
                if (!(Test-Path -path $CSVReportPath)) {
                    New-Item $CSVReportPath -type directory | out-Null
                }
                else {
                    # Deleting the old files
                    Get-ChildItem -Path "$CSVReportPath" -Recurse -Include "*.csv" | Where-Object { ($_.CreationTime -le $(Get-Date).AddDays(-$oldTime)) } | Remove-Item -Force
                }
                $BPAResults | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $CSVPath
            }

            #Send BPA Results to HTML-file if enabled
            if ($BPAResults -and $HTMLReport) {
                if (!(Test-Path -path $HTMLReportPath)) {
                    New-Item $HTMLReportPath -type directory | out-Null
                }
                else {
                    # Deleting the old files
                    Get-ChildItem -Path "$HTMLReportPath" -Recurse -Include "*.html" | Where-Object { ($_.CreationTime -le $(Get-Date).AddDays(-$oldTime)) } | Remove-Item -Force
                }
                $BPAResults | ConvertTo-Html -Property Severity, Category, Title, Problem, Impact, Resolution, Help -Title "BPA Report for $BestPracticesModelId on $($server.Name)" -Body "BPA Report for $BestPracticesModelId on server $($server.Name) <HR>" -Head $head | Out-File -FilePath $HTMLPath
            }
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/GenerateBPAReports.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=GenerateBPAReports.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
