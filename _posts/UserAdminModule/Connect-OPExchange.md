---
layout: post
title: Connect-OPExchange.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/connect-opexchange/
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

Connect-OPExchange - A function to connect to Exchange Server on premise.

#### Detailed Description

Connect-OPExchange - A function to connect to Exchange Server on premise. This function will connect to a random server in the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Connect-OPExchange -UserName "username.admin" -ComputerName "exch01.domain.local"
```

Connects using the account named in UserName and connects to the server named in ComputerName

**Example 2**

```powershell
Connect-OPExchange -ComputerName "exch01.domain.local"
```

Connects using the environment variable $Env:USERNAME and connects to the server named in ComputerName

**Example 3**

```powershell
ex365 -UserName "lukeleigh" -ComputerName "exch01.domain.local"
```

Using the command alias, this command connects using the account named in UserName and connects to the server named in ComputerName

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Connect-OPExchange {

    <#

    .SYNOPSIS
    Connect-OPExchange - A function to connect to Exchange Server on premise.
	
	.DESCRIPTION
    Connect-OPExchange - A function to connect to Exchange Server on premise. This function will connect to a random server in the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site.
	
	.PARAMETER UserName
    [string]UserName - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.

    .PARAMETER ComputerName
    [string]ComputerName - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.
	
	.EXAMPLE
    Connect-OPExchange -UserName "username.admin" -ComputerName "exch01.domain.local"

    Connects using the account named in UserName and connects to the server named in ComputerName
	
	.EXAMPLE
    Connect-OPExchange -ComputerName "exch01.domain.local"

    Connects using the environment variable $Env:USERNAME and connects to the server named in ComputerName
    
	.EXAMPLE
    ex365 -UserName "lukeleigh" -ComputerName "exch01.domain.local"

    Using the command alias, this command connects using the account named in UserName and connects to the server named in ComputerName
	
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
    
    - UserName [string] - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.
    - ComputerName [string] - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.
	
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
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [string]$UserName = $env:USERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.')]
        [ArgumentCompleter( {
                $Exchange = Get-ExchangeServerInSite
                $Servers = Get-Random -InputObject $Exchange -Shuffle:$true
                foreach ($Server in $Servers) {
                    $Server.FQDN
                }
            }) ]
        [Alias('cn')]
        [string]$ComputerName
        
    )
    
    begin {

    }

    process {

        if ($PSCmdlet.ShouldProcess($ComputerName, "Creating Session for Exchange access")) {

            if ( (Test-OpenPorts -ComputerName $ComputerName -RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).Status -eq 'Open' ) {
                Import-Module -Name ConnectExchangeOnPrem
                Connect-ExchangeOnPrem -ComputerName $ComputerName -Credential $creds -Authentication Kerberos
                Write-Verbose "Exchange Session connected to : $ComputerName."
            }
            else {
                Write-Warning "Unable to connect to $ComputerName."
            }

        }

    }
    
    end {

    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Connect-OPExchange.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-OPExchange.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

