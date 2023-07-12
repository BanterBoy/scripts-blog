---
layout: post
title: CheckActiveDirectorySites.ps1
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
Check Active Directory Sites
http://blogs.metcorpconsulting.com/tech/?p=366
#>

# Set variables
[array] $SitesWithNoSubnet = @()
[array] $SitesWithNoSiteLinks = @()
[array] $SitesWithNoISTG = @()
[array] $DCsnotGC = @()
[array] $SitesWithNoGC = @()
#Get AD Domain (lightweight & fast method)
$DomainDNS = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
import-module activedirectory
Write-Verbose "Get AD Site List `r"
[array] $ADSites = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
$ADSitesCount = $ADSites.Count
Write-Output "There are $ADSitesCount AD Sites `r"
## Check AD Sites
Write-Verbose "Checking for AD Site issues `r "
ForEach ($Site in $ADSites) {
    ## OPEN ForEach Site in ADSites
    $SiteName = $Site.Name
    [array] $SiteSubnets = $Site.Subnets
    [array] $SiteServers = $Site.Servers
    [array] $SiteAdjacentSites = $Site.AdjacentSites
    [array] $SiteLinks = $Site.SiteLinks
    $SiteInterSiteTopologyGenerator = $Site.InterSiteTopologyGenerator
    # Check for missing subnets
    IF (!$SiteSubnets) {
        ## OPEN IF there are no Site Subnets
        Write-Verbose "The site $SiteName does not have a configured subnet. `r "
        [array] $SitesWithNoSubnet += $SiteName
    }  ## OPEN IF there are no Site Subnets
    # Check for missing site link
    IF (!$SiteLinks) {
        ## OPEN IF there are no Site Links for this site
        Write-Verbose "The site $SiteName does not have an associated site link. `r "
        [array] $SitesWithNoSiteLinks += $SiteName
    }  ## OPEN IF there are no Site Links for this site
    # Check for missing ISTG
    IF (!$SiteInterSiteTopologyGenerator) {
        ## OPEN IF there are no ISTG  for this site
        Write-Verbose "The site $SiteName does not have a configured InterSite Topology Generator server `r "
        [array] $SitesWithNoISTG += $SiteName
    }  ## OPEN IF there are no ISTG for this site
    # Find AD Sites with no GCs
    $SiteDC = Get-ADDomainController -filter { (Site -eq $Site) -and (IsGlobalCatalog -eq $True) }
    IF (!$SiteDC) {
        ## OPEN IF there are no GCs for this site
        Write-Verbose "The site $SiteName does not have a Global Catalog associated with it `r "
        [array] $SitesWithNoGC += $SiteName
    }  ## OPEN IF there are no GCs for this site
}  ## CLOSE ForEach Site in ADSites
$SitesWithNoSubnetCount = $SitesWithNoSubnet.Count
IF ($SitesWithNoSubnetCount -ge 1) {
    ## IF Count is >= 1
    Write-Output "The following $SitesWithNoSubnetCount sites do not have subnets associated with them `r "
    $SitesWithNoSubnet
    Write-Output " `r "
}  ## IF Count is >= 1
$SitesWithNoSiteLinksCount = $SitesWithNoSiteLinks.Count
IF ($SitesWithNoSiteLinksCount -ge 1) {
    ## IF Count is >= 1
    Write-Output "The following $SitesWithNoSiteLinksCount sites do not have Site Links associated with them `r "
    $SitesWithNoSiteLinks
    Write-Output " `r "
}  ## IF Count is >= 1
$SitesWithNoISTGCount = $SitesWithNoISTG.Count
IF ($SitesWithNoISTGCount -ge 1) {
    ## IF Count is >= 1
    Write-Output "The following $SitesWithNoISTGCount sites do not an ISTG associated with them `r "
    $SitesWithNoISTG
    Write-Output " `r "
}  ## IF Count is >= 1
$SitesWithNoGCCount = $SitesWithNoGC.Count
IF ($SitesWithNoGCCount -ge 1) {
    ## IF Count is >= 1
    Write-Output "The following $SitesWithNoGCCount sites do not have a GC associated with them `r "
    $SitesWithNoGC
    Write-Output " `r "
}  ## IF Count is >= 1
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CheckActiveDirectorySites.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CheckActiveDirectorySites.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
