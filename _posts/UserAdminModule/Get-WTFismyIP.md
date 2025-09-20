---
layout: post
title: Get-WTFismyIP.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-WTFismyIP/
categories:
  - UserAdminModule
  - Network
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-WTFismyIP {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $false, HelpMessage = "Return the result as an object")]
        [switch] $AsObject,

        [Parameter(Mandatory = $false, HelpMessage = "Be polite")]
        [switch] $Polite,

        [Parameter(Mandatory = $false, HelpMessage = "Timeout in seconds")]
        [int] $TimeoutSeconds = 5
    )
    
    begin { }
    
    process {
        try {
            $WTFismyIP = Invoke-RestMethod -Method Get -Uri "https://wtfismyip.com/json" -TimeoutSec $TimeoutSeconds

            if ($AsObject.IsPresent) {
                return $WTFismyIP
            }

            $fucking = $polite.IsPresent ? "" : "Fucking"

            $properties = [ordered]@{
                "Your$($fucking)IPAddress"   = $WTFismyIP.YourFuckingIPAddress
                "Your$($fucking)Location"     = $WTFismyIP.YourFuckingLocation
                "Your$($fucking)HostName"    = $WTFismyIP.YourFuckingHostname
                "Your$($fucking)ISP"          = $WTFismyIP.YourFuckingISP
                "Your$($fucking)TorExit"     = $WTFismyIP.YourFuckingTorExit
                "Your$($fucking)CountryCode" = $WTFismyIP.YourFuckingCountryCode
            }
            
            $obj = New-Object -TypeName psobject -Property $properties

            Write-Output -InputObject $obj
        }
        catch {
            Write-Error -Message "$_"
        }
    }

    end { }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Network/Public/Get-WTFismyIP.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-WTFismyIP.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

