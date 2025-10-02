---
layout: post
title: ExchangeConnector.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/exchangeconnector/
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

Connects to Exchange Online or Exchange On-premises using a script menu.

#### Detailed Description

The ExchangeConnector function uses the PSMenu module to create a script menu for connecting to Exchange Online or Exchange On-premises. It prompts the user to select an option from the menu and performs the corresponding action based on the selection.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
ExchangeConnector
```

Connects to Exchange Online or Exchange On-premises based on the user's selection.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires the PSMenu module to be installed. You can install it from the PowerShell Gallery using the following command: Install-Module -Name PSMenu -Scope CurrentUser

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Connects to Exchange Online or Exchange On-premises using a script menu.

.DESCRIPTION
The ExchangeConnector function uses the PSMenu module to create a script menu for connecting to Exchange Online or Exchange On-premises. It prompts the user to select an option from the menu and performs the corresponding action based on the selection.

.PARAMETER None

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
ExchangeConnector
Connects to Exchange Online or Exchange On-premises based on the user's selection.

.NOTES
Requires the PSMenu module to be installed. You can install it from the PowerShell Gallery using the following command:
Install-Module -Name PSMenu -Scope CurrentUser

#>

function ExchangeConnector {

    # Using the PSMenu module to create a script menu
    # Requires PSMenu module to be installed
    # https://www.powershellgallery.com/packages/PSMenu/1.0.0

    # Import the PSMenu module
    Import-Module PSMenu

    # Create a new menu
    $Menu = Show-Menu @("Connect Exchange Online", "Connect Exchange On-prem", $(Get-MenuSeparator), "Quit")

    # Use the correct comparison operator and check the value of $Menu
    if ($Menu -eq "Connect Exchange Online") { Connect-ExchangeOnline -UserPrincipalName (Read-Host "Enter your O365 Admin Email Address") }
    elseif ($Menu -eq "Connect Exchange On-prem") { Connect-ExchangeOnPrem -ComputerName ($(Get-ExchangeServerInSite)[0].fqdn) }
    else { Write-Output "Nothing Selected" }

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/ExchangeConnector.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ExchangeConnector.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

