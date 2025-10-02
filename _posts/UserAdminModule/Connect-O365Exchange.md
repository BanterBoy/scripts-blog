---
layout: post
title: Connect-O365Exchange.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/connect-o365exchange/
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

Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication.

#### Detailed Description

Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication. This function will import the ExchangeOnlineManagement module and connect to Exchange Online using the credentials of the user named in UserName. If UserName is left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Connect-O365Exchange -UserName "lukeleigh.admin"
```

Connects using the account named in UserName

**Example 2**

```powershell
Connect-O365Exchange
```

Connects using the environment variable $Env:USERNAME

**Example 3**

```powershell
ex365 -UserName "lukeleigh"
```

Using the command alias, this command connects using the account named in UserName

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
Function Connect-O365Exchange {

    <#

    .SYNOPSIS
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication.
	
	.DESCRIPTION
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication. This function will import the ExchangeOnlineManagement module and connect to Exchange Online using the credentials of the user named in UserName. If UserName is left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.PARAMETER UserName
    [string]UserName - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.EXAMPLE
    Connect-O365Exchange -UserName "lukeleigh.admin"

    Connects using the account named in UserName
	
	.EXAMPLE
    Connect-O365Exchange

    Connects using the environment variable $Env:USERNAME
    
	.EXAMPLE
    ex365 -UserName "lukeleigh"

    Using the command alias, this command connects using the account named in UserName
	
	.OUTPUTS
    No output returned.
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
    You can pipe objects to these perameters.
		
    - UserName [string] - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.LINK
    https://scripts.lukeleigh.com
    Import-Module
    Connect-ExchangeOnline

    #>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to Office 365 e.g. "lukeleigh.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [string]$UserName = $env:USERNAME
    )
    
    begin {

    }
    
    process {
        if ($PSCmdlet.ShouldProcess($UserName, "Connecting to Exchange Online as")) {

            Import-Module ExchangeOnlineManagement
            Connect-ExchangeOnline -UserPrincipalName (Get-ADUser -Identity $UserName).UserPrincipalName -ShowBanner:$false

        }
    }

    end {

    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Connect-O365Exchange.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-O365Exchange.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

