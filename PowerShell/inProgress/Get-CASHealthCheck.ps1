<#
.SYNOPSIS
Get-CASHealthCheck.ps1 - Exchange Server 2013 Client Access Health Check

.DESCRIPTION 
This PowerShell script checks the health of each Exchange 2013 client
protocol by making a web request for the /healthcheck.htm file in each
virtual directory.

.OUTPUTS
Results are output to console. Future plans include output to
HTML and email.

.EXAMPLE
.\Get-CASHealthCheck.ps1

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Credits:
http://www.bhargavs.com/index.php/2014/03/17/ignoring-ssl-trust-in-powershell-using-system-net-webclient/

Change Log
V1.00, 7/5/2015 - Initial version
V1.01, 29/5/2015 - Bug fixes for Autodiscover SCP checks
#>

#requires -version 3

[CmdletBinding()]
param (

    [Parameter(Mandatory = $false)]
    [switch]$SendEmail

)


#...................................
# Initialize
#...................................

$now = Get-Date
$date = $now.ToShortDateString()

$report = @()

$wc = New-Object System.Net.WebClient

$vdirs = @(
    "owa",
    "ecp",
    "oab",
    "rpc",
    "ews",
    "mapi",
    "Microsoft-Server-ActiveSync",
    "Autodiscover"
)

#Add Exchange 2010/2013 snapin if not already loaded in the PowerShell session
if (!(Get-PSSnapin | where { $_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010" })) {
    . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
    Connect-ExchangeServer -auto -AllowClobber
}

#...................................
# Functions
#...................................

#This function performs the Invoke-WebRequest test against CAS URLs
function Test-CASURL() {

    param($url)

    $testurl = "$url/healthcheck.htm"

    Write-Host -ForegroundColor White "Testing $testurl " -NoNewline
    try {
        #[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
        $web = Invoke-WebRequest -Uri "$testurl" -UseBasicParsing -ErrorAction STOP
        if ($web.StatusCode -eq "200") {
            Write-Host -ForegroundColor Green "OK"
            $result = "OK"
        }
        else {
            Write-Host -ForegroundColor Red $($web.StatusCode)
            $result = $($web.StatusCode)
        }
    }
    catch {
        #Write-Warning $_.Exception.Message
        if ($_.Exception.Message -like "*Could not establish trust relationship for the SSL/TLS secure channel*") {
            $result = "SSL error"
        }
        else {
            $result = "Error"
        }
        Write-Host -ForegroundColor Red $result
    }

    return $result
}


#...................................
# Script
#...................................

# Get the Exchange 2013 CAS servers in the org

$ClientAccessServers = @(Get-ExchangeServer | Where { $_.IsClientAccessServer -and $_.AdminDisplayVersion -like "Version 15.*" })

if (!($ClientAccessServers)) {
    Write-Warning "No Exchange Server 2013 Client Access servers found"
    EXIT
}

# Get the list of AD Sites that CAS servers are located in

$sites = @($ClientAccessServers | Group-Object -Property:Site | Select Name)

# Get the URLs for each site

foreach ($site in $sites) {
    $SiteName = ($Site.Name).Split("/")[-1]
    
    Write-Host ""
    Write-Host -ForegroundColor White "-------------- Processing $SiteName"

    $SiteOWAInternalUrls = @()
    $SiteOWAExternalUrls = @()

    $SiteECPInternalUrls = @()
    $SiteECPExternalUrls = @()

    $SiteOABInternalUrls = @()
    $SiteOABExternalUrls = @()
    
    $SiteRPCInternalUrls = @()
    $SiteRPCExternalUrls = @()

    $SiteEWSInternalUrls = @()
    $SiteEWSExternalUrls = @()

    $SIteMAPIInternalUrls = @()
    $SiteMAPIExternalUrls = @()

    $SiteActiveSyncInternalUrls = @()
    $SiteActiveSyncExternalUrls = @()

    $SiteAutodiscoverUrls = @()

    $CASinSite = @($ClientAccessServers | Where { $_.Site -eq $site.Name })

    Write-Host "Getting OWA Urls"

    foreach ($CAS in $CASinSite) {
        $CASOWAUrls = @(Get-OWAVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASOWAUrl in $CASOWAUrls) {
            if (!($SiteOWAInternalUrls -Contains $CASOWAUrl.InternalURL.AbsoluteUri) -and ($CASOWAUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteOWAInternalUrls += $CASOWAUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteOWAExternalUrls -Contains $CASOWAUrl.ExternalURL.AbsoluteUri) -and ($CASOWAUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteOWAExternalUrls += $CASOWAUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteOWAInternalUrls.Count -gt 1) { Write-Warning "More than 1 OWA internal URL found in site" }
    if ($SiteOWAExternalUrls.Count -gt 1) { Write-Warning "More than 1 OWA external URL found in site" }

    Write-Host "Getting ECP Urls"

    foreach ($CAS in $CASinSite) {
        $CASECPUrls = @(Get-ECPVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASECPUrl in $CASECPUrls) {
            if (!($SiteECPInternalUrls -Contains $CASECPUrl.InternalURL.AbsoluteUri) -and ($CASECPUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteECPInternalUrls += $CASECPUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteECPExternalUrls -Contains $CASECPUrl.ExternalURL.AbsoluteUri) -and ($CASECPUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteECPExternalUrls += $CASECPUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteECPInternalUrls.Count -gt 1) { Write-Warning "More than 1 ECP internal URL found in site" }
    if ($SiteECPExternalUrls.Count -gt 1) { Write-Warning "More than 1 ECP external URL found in site" }

    Write-Host "Getting OAB Urls"

    foreach ($CAS in $CASinSite) {
        $CASOABUrls = @(Get-OABVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASOABUrl in $CASOABUrls) {
            if (!($SiteOABInternalUrls -Contains $CASOABUrl.InternalURL.AbsoluteUri) -and ($CASOABUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteOABInternalUrls += $CASOABUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteOABExternalUrls -Contains $CASOABUrl.ExternalURL.AbsoluteUri) -and ($CASOABUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteOABExternalUrls += $CASOABUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteOABInternalUrls.Count -gt 1) { Write-Warning "More than 1 OAB internal URL found in site" }
    if ($SiteOABExternalUrls.Count -gt 1) { Write-Warning "More than 1 OAB external URL found in site" }

    Write-Host "Getting RPC Urls"

    foreach ($CAS in $CASinSite) {
        $OA = Get-OutlookAnywhere -Server $CAS -AdPropertiesOnly | Select InternalHostName, ExternalHostName
        [string]$OAInternalHostName = $OA.InternalHostName
        [string]$OAExternalHostName = $OA.ExternalHostName

        [string]$OAInternalUrl = "https://$OAInternalHostName/rpc"
        [string]$OAExternalUrl = "https://$OAExternalHostName/rpc"

        if (!($SiteRPCInternalUrls -Contains $OAInternalUrl) -and ($OAInternalHostName -ne $null)) {
            $SiteRPCInternalUrls += $OAInternalUrl
        }
        if (!($SiteRPCExternalUrls -Contains $OAExternalUrl) -and ($OAExternalHostName -ne $null) -and ($OAExternalHostName -ne "")) {
            $SiteRPCExternalUrls += $OAExternalUrl
        }
    }

    if ($SiteRPCInternalUrls.Count -gt 1) { Write-Warning "More than 1 Outlook Anywhere internal URL found in site" }
    if ($SiteRPCExternalUrls.Count -gt 1) { Write-Warning "More than 1 Outlook Anywhere external URL found in site" }

    Write-Host "Getting EWS Urls"

    foreach ($CAS in $CASinSite) {
        $CASEWSUrls = @(Get-WebServicesVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASEWSUrl in $CASEWSUrls) {
            if (!($SiteEWSInternalUrls -Contains $CASEWSUrl.InternalURL.AbsoluteUri) -and ($CASEWSUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteEWSInternalUrls += $CASEWSUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteEWSExternalUrls -Contains $CASEWSUrl.ExternalURL.AbsoluteUri) -and ($CASEWSUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteEWSExternalUrls += $CASEWSUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteEWSInternalUrls.Count -gt 1) { Write-Warning "More than 1 EWS internal URL found in site" }
    if ($SiteEWSExternalUrls.Count -gt 1) { Write-Warning "More than 1 EWS external URL found in site" }

    Write-Host "Getting MAPI Urls"

    foreach ($CAS in $CASinSite) {
        $CASMAPIUrls = @(Get-MAPIVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASMAPIUrl in $CASMAPIUrls) {
            if (!($SiteMAPIInternalUrls -Contains $CASMAPIUrl.InternalURL.AbsoluteUri) -and ($CASMAPIUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteMAPIInternalUrls += $CASMAPIUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteMAPIExternalUrls -Contains $CASMAPIUrl.ExternalURL.AbsoluteUri) -and ($CASMAPIUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteMAPIExternalUrls += $CASMAPIUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteMAPIInternalUrls.Count -gt 1) { Write-Warning "More than 1 MAPI internal URL found in site" }
    if ($SiteMAPIExternalUrls.Count -gt 1) { Write-Warning "More than 1 MAPI external URL found in site" }

    Write-Host "Getting ActiveSync Urls"

    foreach ($CAS in $CASinSite) {
        $CASActiveSyncUrls = @(Get-ActiveSyncVirtualDirectory -Server $CAS -AdPropertiesOnly | Select InternalURL, ExternalURL)
        foreach ($CASActiveSyncUrl in $CASActiveSyncUrls) {
            if (!($SiteActiveSyncInternalUrls -Contains $CASActiveSyncUrl.InternalURL.AbsoluteUri) -and ($CASActiveSyncUrl.InternalURL.AbsoluteUri -ne $null)) {
                $SiteActiveSyncInternalUrls += $CASActiveSyncUrl.InternalURL.AbsoluteUri
            }
            if (!($SiteActiveSyncExternalUrls -Contains $CASActiveSyncUrl.ExternalURL.AbsoluteUri) -and ($CASActiveSyncUrl.ExternalURL.AbsoluteUri -ne $null)) {
                $SiteActiveSyncExternalUrls += $CASActiveSyncUrl.ExternalUrl.AbsoluteUri
            }
        }
    }

    if ($SiteActiveSyncInternalUrls.Count -gt 1) { Write-Warning "More than 1 ActiveSync internal URL found in site" }
    if ($SiteActiveSyncExternalUrls.Count -gt 1) { Write-Warning "More than 1 ActiveSync external URL found in site" }

    Write-Host "Getting AutoDiscover Urls"

    foreach ($CAS in $CASinSite) {
        $CASServer = Get-ClientAccessServer $CAS.Name
        [string]$AutodiscoverSCP = ($CASServer).AutoDiscoverServiceInternalUri
        $CASAutodiscoverUrl = $AutodiscoverSCP.Replace("/Autodiscover.xml", "")
        if (!($SiteAutodiscoverUrls -Contains $CASAutodiscoverUrl)) { $SiteAutodiscoverUrls += $CASAutodiscoverUrl }
    }

    if ($SiteAutodiscoverUrls.Count -gt 1) { Write-Warning "More than 1 Autodiscover internal URL found in site" }
    
    Write-Host ""
    Write-Host "----- Internal URL Health Checks:"

    foreach ($url in $SiteOWAInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteECPInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteOABInternalUrls) {
        $result = Test-CASURL $url
    }
    
    foreach ($url in $SiteRPCInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteEWSInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SIteMAPIInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteActiveSyncInternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteAutodiscoverUrls) {
        $result = Test-CASURL $url
    }

    Write-Host ""
    Write-Host "----- External URL Health Checks:"

    foreach ($url in $SiteOWAExternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteECPExternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteOABExternalUrls) {
        $result = Test-CASURL $url
    }
    
    foreach ($url in $SiteRPCExternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteEWSExternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteMAPIExternalUrls) {
        $result = Test-CASURL $url
    }

    foreach ($url in $SiteActiveSyncExternalUrls) {
        $result = Test-CASURL $url
    }

    Write-Host ""
    Write-Host "----- Per-Server Health Checks:"

    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

    $ServerFQDNs = @($CASinSite.FQDN)

    foreach ($ServerFQDN in $ServerFQDNs) {
        Write-Host ""
        Write-Host "Server: $ServerFQDN"

        foreach ($vdir in $vdirs) {
            $src = $null
            $testurl = "https://$ServerFQDN/$vdir/healthcheck.htm"

            Write-Host "Testing $testurl " -NoNewline
            try {
                $src = $wc.DownloadString($testurl)
            }
            catch {
                # Suppress exceptions
            }

            if ($src -like "200 OK*") {
                Write-Host -Foregroundcolor Green "OK"
            }
            else {
                Write-Host -ForegroundColor Red "Error"
            }
        }
    }

}


[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null

#...................................
# Finished
#...................................
