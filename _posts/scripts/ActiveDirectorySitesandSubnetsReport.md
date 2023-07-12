---
layout: post
title: ActiveDirectorySitesandSubnetsReport.ps1
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
  Active Directory Sites and Subnets Report

  Release 1.0 Written by Jeremy@jhouseconsulting.com 13th September 2013
#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$SitesReport = $(&$ScriptPath) + "\ActiveDirectorySitesReport.csv"
$SubnetsReport = $(&$ScriptPath) + "\ActiveDirectorySubnetsReport.csv"

#-------------------------Site Report-------------------------
# This module was Written by Brian Seltzer
# List Sites and Subnets in Active Directory using PowerShell
# http://www.itadmintools.com/2011/08/list-sites-and-subnets-in-active.html
$siteDescription = @{}
$siteSubnets = @{}
$sitesDN = "LDAP://CN=Sites," + $([adsi] "LDAP://RootDSE").Get("ConfigurationNamingContext")
$subnetsDN = "LDAP://CN=Subnets,CN=Sites," + $([adsi] "LDAP://RootDSE").Get("ConfigurationNamingContext")
#get the site names and descriptions
foreach ($site in $([adsi] $sitesDN).psbase.children) {
    if ($site.objectClass -eq "site") {
        $siteName = ([string]$site.cn).toUpper()
        $siteDescription[$siteName] = $site.Description
        $siteSubnets[$siteName] = @()
    }
}
#get the subnets and associate them with the sites
foreach ($subnet in $([adsi] $subnetsDN).psbase.children) {
    $site = [adsi] "LDAP://$($subnet.siteObject)"
    if ($null -ne $site.cn) {
        $siteName = ([string]$site.cn).toUpper()
        $siteSubnets[$siteName] += $subnet.cn
    }
    else {
        $siteDescription["Orphaned"] = "Subnets not associated with any site"
        if ($null -eq $siteSubnets["Orphaned"]) { $siteSubnets["Orphaned"] = @() }
        $siteSubnets["Orphaned"] += $subnet.cn
    }
}
#write output to screen
foreach ($siteName in $siteDescription.keys | Sort-Object) {
    "$siteName  $($siteDescription[$siteName])"
    foreach ($subnet in $siteSubnets[$siteName]) {
        "`t$subnet"
    }
}

#-------------------------Site Report-------------------------
$allsites = @()
$sitesDN = "LDAP://CN=Sites," + $([adsi] "LDAP://RootDSE").Get("ConfigurationNamingContext")
#get the site names and descriptions
foreach ($site in $([adsi] $sitesDN).psbase.children) {
    if ($site.objectClass -eq "site") {
        $data = "" | Select-Object Name, Description, Location
        $data.Name = $($site.Name)
        $data.Description = $($site.Description)
        $data.Location = $($site.Location)
        $allsites += $data
    }
}
Write-Host -ForegroundColor Green $allsites.count "sites have been exported to $SitesReport"
$allsites | Sort-Object -Property Name | Export-Csv -NoTypeInformation "$SitesReport"
# Remove the quotes
(Get-Content "$SitesReport") | ForEach-Object { $_ -replace '"', "" } | Out-File "$SitesReport" -Force -Encoding ascii

#-----------------------Subnet Report-------------------------
$allsubnets = @()
$subnetsDN = "LDAP://CN=Subnets,CN=Sites," + $([adsi] "LDAP://RootDSE").Get("ConfigurationNamingContext")
foreach ($subnet in $([adsi] $subnetsDN).psbase.children) {
    $net = [ADSI]"$($subnet.Path)"
    $data = "" | Select-Object Site, Name, Description, Location
    If ($($net.cn).Contains("CNF:") -eq $False) {
        $data.name = $($net.cn)
    }
    else {
        $data.name = [string]::join("\0A", ($($net.cn).Split("`n")))
    }
    $data.Location = $($net.location)
    $data.Description = $($net.description)
    If ($null -ne $net.siteobject) {
        $st = $($net.siteobject).split(",")
        $data.site = $st[0].Replace("CN=", "")
    }
    Else {
        $st = "*Orphaned"
        $data.site = $st
    }
    $allsubnets += $data
}
Write-Host -ForegroundColor Green $allsubnets.count "subnets have been exported to $SubnetsReport"
$allsubnets | Sort-Object Site | Export-Csv -NoTypeInformation "$SubnetsReport"
# Remove the quotes
(Get-Content "$SubnetsReport") | ForEach-Object { $_ -replace '"', "" } | out-file "$SubnetsReport" -Force -Encoding ascii
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/ActiveDirectorySitesandSubnetsReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ActiveDirectorySitesandSubnetsReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
