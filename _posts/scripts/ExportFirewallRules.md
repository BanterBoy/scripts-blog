---
layout: post
title: ExportFirewallRules.ps1
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
$Servers = Get-ADComputer -Filter 'Name -like "*"' -Properties * | Where-Object { ( $_.OperatingSystem -like '*server*' ) -and ( $_.Enabled -eq $true ) -and ( $_.IPv4Address -ne "$null" ) }
foreach ( $Server in $Servers ) {
    $filename = $Server.Name
    Invoke-Command -ComputerName $Server.Name -ScriptBlock {
        $FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound
        $FirewallRules | Select-Object -Property DisplayName, Description, Profile, Direction, Action, DisplayGroup
    } -ErrorAction SilentlyContinue | Out-File -FilePath "C:\GitRepos\$filename.FirewallRules.txt"
}


function Test-FirewallAllServer {
    $servers = (Get-ADComputer -Filter * -Properties Operatingsystem | Where-Object { $_.operatingsystem -like "*server*" }).Name
    $check = Invoke-Command -ComputerName $servers { Get-NetFirewallProfile -Profile Domain | Select-Object -ExpandProperty Enabled } -ErrorAction SilentlyContinue
    $line = "__________________________________________________________"
    $line2 = "=========================================================="
    $en = $check | Where-Object value -EQ "true"
    $di = $check | Where-Object value -EQ "false"
    If ($null -ne $en) {
        Write-Host ""; Write-Host "The following Windows Server have their firewall enabled:" -ForegroundColor Green; $line; Write-Output ""$en.PSComputerName""; Write-Host ""
    }
    If ($null -ne $di) {
        Write-Host ""; Write-Host "The following Windows Server have their firewall disabled:" -ForegroundColor Red ; $line; Write-Output ""$di.PSComputerName""; Write-Host ""
    }
    If ($null -eq $di) {
        Write-Host $line2; Write-Host "All Windows Servers have it's firewall enabled" -ForegroundColor Green; Write-Host ""
    }
    If ($null -eq $en) {
        Write-Host $line2; Write-Host "All Windows Servers have it's firewall disabled" -ForegroundColor Red; Write-Host ""
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/information/ExportFirewallRules.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ExportFirewallRules.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
