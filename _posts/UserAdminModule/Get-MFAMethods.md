---
layout: post
title: Get-MFAMethods.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-MFAMethods/
categories:
- UserAdminModule
- Azure
tags:
- PowerShell
- User Admin Module
- MFA Methods
- MFA
description: Get the MFA status of the user
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Get the MFA status of the user

#### Detailed Description

The Get-MFAMethods function retrieves the multi-factor authentication (MFA) status of a user. It queries the MFA details for the specified user and returns an object containing the status and details of each MFA method enabled for the user.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-MFAMethods -userId "john.doe@example.com"
```

This example retrieves the MFA methods for the user with the specified user ID ("john.doe@example.com").

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Get-MFAMethods {
    <#
    .SYNOPSIS
        Get the MFA status of the user
    
    .DESCRIPTION
        The Get-MFAMethods function retrieves the multi-factor authentication (MFA) status of a user. It queries the MFA details for the specified user and returns an object containing the status and details of each MFA method enabled for the user.
    
    .PARAMETER userId
        The user ID for which to retrieve the MFA methods.
    
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    .EXAMPLE
        Get-MFAMethods -userId "john.doe@example.com"
    
        This example retrieves the MFA methods for the user with the specified user ID ("john.doe@example.com").
    
    .NOTES
        Author: Your Name
        Date:   Current Date
    #>
    param(
        [Parameter(Mandatory = $true)] $userId
    )
    process {
        # Get MFA details for each user
        [array]$global:mfaData = Get-MgUserAuthenticationMethod -UserId $userId
  
        # Create MFA details object
        $mfaMethods = [PSCustomObject][Ordered]@{
            status                  = "-"
            authApp                 = "-"
            phoneAuth               = "-"
            fido                    = "-"
            helloForBusiness        = "-"
            emailAuth               = "-"
            tempPass                = "-"
            passwordLess            = "-"
            softwareAuth            = "-"
            authDevice              = "-"
            authPhoneNr             = "-"
            SSPREmail               = "-"
            fidoDetails             = "-"
            helloForBusinessDetails = "-"
            tempPassDetails         = "-"
            passwordLessDetails     = "-"
        }
  
        ForEach ($method in $mfaData) {
            Switch ($method.AdditionalProperties["@odata.type"]) {
                "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" { 
                    # Microsoft Authenticator App
                    $mfaMethods.authApp = $true
                    $mfaMethods.authDevice = $method.AdditionalProperties["displayName"] 
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.phoneAuthenticationMethod" { 
                    # Phone authentication
                    $mfaMethods.phoneAuth = $true
                    $mfaMethods.authPhoneNr = $method.AdditionalProperties["phoneType", "phoneNumber"] -join ' '
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.fido2AuthenticationMethod" { 
                    # FIDO2 key
                    $mfaMethods.fido = $true
                    $fifoDetails = $method.AdditionalProperties["model"]
                    $mfaMethods.fidoDetails = $fifoDetails
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.passwordAuthenticationMethod" { 
                    # Password
                    # When only the password is set, then MFA is disabled.
                    if ($mfaMethods.status -ne "enabled") { $mfaMethods.status = "disabled" }
                }
                "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" { 
                    # Windows Hello
                    $mfaMethods.helloForBusiness = $true
                    $helloForBusinessDetails = $method.AdditionalProperties["displayName"]
                    $mfaMethods.helloForBusinessDetails = $helloForBusinessDetails
                    $mfaMethods.status = "enabled"
                } 
                "#microsoft.graph.emailAuthenticationMethod" { 
                    # Email Authentication
                    $mfaMethods.emailAuth = $true
                    $mfaMethods.SSPREmail = $method.AdditionalProperties["emailAddress"] 
                    $mfaMethods.status = "enabled"
                }               
                "microsoft.graph.temporaryAccessPassAuthenticationMethod" { 
                    # Temporary Access pass
                    $mfaMethods.tempPass = $true
                    $tempPassDetails = $method.AdditionalProperties["lifetimeInMinutes"]
                    $mfaMethods.tempPassDetails = $tempPassDetails
                    $mfaMethods.status = "enabled"
                }
                "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" { 
                    # Passwordless
                    $mfaMethods.passwordLess = $true
                    $passwordLessDetails = $method.AdditionalProperties["displayName"]
                    $mfaMethods.passwordLessDetails = $passwordLessDetails
                    $mfaMethods.status = "enabled"
                }
                "#microsoft.graph.softwareOathAuthenticationMethod" { 
                    # ThirdPartyAuthenticator
                    $mfaMethods.softwareAuth = $true
                    $mfaMethods.status = "enabled"
                }
            }
        }
        Return $mfaMethods
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Get-MFAMethods.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MFAMethods.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

