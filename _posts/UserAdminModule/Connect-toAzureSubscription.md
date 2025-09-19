---
layout: post
title: Connect-toAzureSubscription.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Connect-toAzureSubscription/
categories:
  - UserAdminModule
  - Azure
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

Connects to Azure using a service principal and returns connection details.

#### Detailed Description

The Connect-toAzureSubscription function connects to Azure using a service principal. It requires the tenant ID, subscription ID, client ID, and client secret. The function returns a custom object with details about the connection.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$ClientID = "Client-ID-Here"
```

$tenantID = "Tenant-ID-Here" $ClientSecret = ConvertTo-SecureString -String "Client-Secret-Here" -AsPlainText -Force $SubscriptionID = "Subscription-ID-Here" $connectionInfo = Connect-toAzureSubscription -TenantId $tenantID -SubscriptionId $SubscriptionID -ClientId $ClientID -ClientSecret $ClientSecret if ($connectionInfo.Connected) { Write-Host "Connected to Azure with ClientId: $($connectionInfo.ClientId)" } else { Write-Host "Failed to connect to Azure" }

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

.SYNOPSIS
Connects to Azure using a service principal and returns connection details.

.DESCRIPTION
The Connect-toAzureSubscription function connects to Azure using a service principal. It requires the tenant ID, subscription ID, client ID, and client secret. The function returns a custom object with details about the connection.

.PARAMETER TenantId
The ID of the Azure tenant.

.PARAMETER SubscriptionId
The ID of the Azure subscription.

.PARAMETER ClientId
The ID of the Azure client.

.PARAMETER ClientSecret
The client secret, as a SecureString.

.PARAMETER LogFile
The path to a file where the function will log the connection status. This parameter is optional.

.EXAMPLE
$ClientID = "Client-ID-Here"
$tenantID = "Tenant-ID-Here"
$ClientSecret = ConvertTo-SecureString -String "Client-Secret-Here" -AsPlainText -Force
$SubscriptionID = "Subscription-ID-Here"

$connectionInfo = Connect-toAzureSubscription -TenantId $tenantID -SubscriptionId $SubscriptionID -ClientId $ClientID -ClientSecret $ClientSecret

if ($connectionInfo.Connected) {
    Write-Host "Connected to Azure with ClientId: $($connectionInfo.ClientId)"
} else {
    Write-Host "Failed to connect to Azure"
}

#>

function Connect-toAzureSubscription {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the Azure tenant ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid TenantId format. It should be a GUID." }
            })]
        [string]
        $TenantId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the Azure subscription ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid SubscriptionId format. It should be a GUID." }
            })]
        [string]
        $SubscriptionId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the Azure client ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid ClientId format. It should be a GUID." }
            })]
        [string]
        $ClientId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the Azure client secret as a SecureString.")]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString]
        $ClientSecret,

        # New parameter for logging
        [Parameter(Mandatory = $false)]
        [string]
        $LogFile
    )

    $InformationPreference = "Continue"
    $connected = $false
    
    if ($PSCmdlet.ShouldProcess("Connecting to Azure with Subscription: $SubscriptionId")) {
        try {
            Disable-AzContextAutosave -Scope Process | Out-Null
    
            $creds = [System.Management.Automation.PSCredential]::new($ClientId, $ClientSecret)
            $connection = Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -Credential $creds -ServicePrincipal
    
            if ($null -eq $connection.Account) {
                throw "Failed to connect to Azure with Subscription: $SubscriptionId"
            }
    
            # New logging code
            if ($LogFile) {
                Write-Information "Connected to Azure..." | Out-File -Append -FilePath $LogFile
            }
            else {
                Write-Information "Connected to Azure..."
            }
    
            $connected = $true
        }
        catch {
            Write-Error "Failed to connect to Azure: $_"
        }
    }
    
    # New output code
    return @{
        Connected      = $connected
        TenantId       = $TenantId
        SubscriptionId = $SubscriptionId
        ClientId       = $ClientId
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Connect-toAzureSubscription.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-toAzureSubscription.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

