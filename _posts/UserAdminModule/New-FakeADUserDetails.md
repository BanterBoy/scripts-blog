---
layout: post
title: New-FakeADUserDetails.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-FakeADUserDetails/
categories:
  - UserAdminModule
  - ADFunctions
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

Function to

#### Detailed Description

Function to

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-FakeUserDetails
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://blog.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-FakeADUserDetails {
    <#
        .SYNOPSIS
        Function to 

        .DESCRIPTION
        Function to

        .EXAMPLE
        New-FakeUserDetails

        .INPUTS
        
        .OUTPUTS
                
        .NOTES
        Author:     Luke Leigh
        Website:    https://blog.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy

        .LINK
        https://github.com/BanterBoy
    #>

    [CmdletBinding(
        DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please select the user nationality. The default setting Random.")]
        [ValidateSet('AU', 'BR', 'CA', 'CH', 'DE', 'DK', 'ES', 'FI', 'FR', 'GB', 'IE', 'IR', 'NO', 'NL', 'NZ', 'TR', 'US', 'Random') ]
        [string]$Nationality = "Random",

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter or select password length. The default length is 10 characters.")]
        [ValidateSet('8', '10', '12', '14', '16', '18', '20') ]
        [int]$PassLength = "10",

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please select number of results. The default is 1. Min-Max = 1-5000")]
        [ValidateRange(1, 5000)]
        [int]$Quantity = "1",

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the domain name for your Email address.")]
        [string]$Email = "$env:USERDNSDOMAIN",

        [Parameter(Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the domain name for your Email address.")]
        [string]$Path
    )

    BEGIN {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    PROCESS {

        $Uri = "https://randomuser.me/api/?nat=$Nationality&password=upper,lower,special,number,$PassLength&format=json&results=$Quantity"
        $Results = Invoke-RestMethod -Method GET -Uri $Uri -UseBasicParsing
        $mail = ($Email).ToLower()
        
        try {
            foreach ( $item in $Results.results ) {
                $NewFakeUser = [ordered]@{
                    "Name"              = $item.name.first + " " + $item.name.last
                    "Title"             = $item.name.title
                    "GivenName"         = $item.name.first
                    "Surname"           = $item.name.last
                    "DisplayName"       = $item.name.title + " " + $item.name.first + " " + $item.name.last
                    "HouseNumber"       = $item.location.street.number
                    "StreetAddress"     = $item.location.street.name
                    "City"              = $item.location.city
                    "State"             = $item.location.state
                    "Country"           = $item.nat
                    "PostalCode"        = $item.location.postcode
                    "UserPrincipalName" = $item.name.first + "." + $item.name.last + "@" + $mail
                    "SamAccountName"    = $item.name.first + $item.name.last
                    "AccountPassword"   = $item.login.password
                    "Path"              = $Path
                    # "ThumbnailPicture"  = $item.picture.thumbnail
                }
                $obj = New-Object -TypeName PSObject -Property $NewFakeUser
                Write-Output $obj
            }
        }
        catch {
            Write-Verbose -Message "$_"
        }

    }

    END {

    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/New-FakeADUserDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-FakeADUserDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

