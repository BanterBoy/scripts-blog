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
