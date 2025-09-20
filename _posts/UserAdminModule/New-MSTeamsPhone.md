---
layout: post
title: New-MSTeamsPhone.ps1
description: "Assigns a phone number to a Microsoft Teams user using provided credentials."
date: 2025-09-19
permalink: /useradminmodule/teams/new-msteamsphone/
categories:
  - UserAdminModule
  - Teams
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

Install-RequiredModules - Tests to see if scripts/function required modules are available.

#### Detailed Description

Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Install-RequiredModules
```

Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author	: Luke Leigh Website	: https://blog.lukeleigh.com Twitter	: https://twitter.com/luke_leighs GitHub  : https://github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-MSTeamsPhone {

    <#
    .SYNOPSIS
        Install-RequiredModules - Tests to see if scripts/function required modules are available.
    .DESCRIPTION
        Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .EXAMPLE
        PS C:\> Install-RequiredModules
        Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .INPUTS
        None.
    .OUTPUTS
        [String] Outputs details of installation, importing and failure.
    .NOTES
        Author	: Luke Leigh
        Website	: https://blog.lukeleigh.com
        Twitter	: https://twitter.com/luke_leighs
        GitHub  : https://github.com/BanterBoy

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter your credentials or pipe input.'
        )]
        [Alias('creds')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [string]$UserPrincipalName,
        
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2,
            HelpMessage = 'Enter the full telephone number or pipe input. (e.g. +442048418255)'
        )]
        [string]$PhoneNumber
    )
    
    begin {
        Import-Module MicrosoftTeams
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Configuring MSTeams phone assignment")) {

            try {
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -EnterpriseVoiceEnabled:$true
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -PhoneNumber $PhoneNumber -PhoneNumberType DirectRouting
                Grant-CsOnlineVoiceRoutingPolicy -Identity $UserPrincipalName -PolicyName "VRPolicy"
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                Get-CsOnlineUser -Identity $UserPrincipalName | Select-Object -Property DisplayName, DialPlan, EnterpriseVoiceEnabled, FeatureTypes, LineUri, UserPrincipalName
            }
        }
    }

    end {}

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/New-MSTeamsPhone.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-MSTeamsPhone.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

