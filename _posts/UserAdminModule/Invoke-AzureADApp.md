---
layout: post
title: Invoke-AzureADApp.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Invoke-AzureADApp/
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

Manages Azure AD application registrations.

#### Detailed Description

This script allows you to create, update, list client secrets, and delete Azure AD application registrations.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Manages Azure AD application registrations.

.DESCRIPTION
    This script allows you to create, update, list client secrets, and delete Azure AD application registrations.

.PARAMETER TenantFQDN
    The FQDN of the Azure AD tenant.

.PARAMETER DisplayName
    The display name of the application registration.

.PARAMETER CustomLifetimeSecretInDays
    The custom lifetime of the client secret in days.

.PARAMETER CreateOrUpdateApp
    Switch to create or update the application.

.PARAMETER DeleteApp
    Switch to delete the application.

.PARAMETER UpdateAPIPerms
    Switch to update API permissions.

.PARAMETER CreateClientSecret
    Switch to create a new client secret.

.PARAMETER DeleteAllClientSecrets
    Switch to delete all existing client secrets.

.PARAMETER ListAllClientSecrets
    Switch to list all existing client secrets.

.EXAMPLE
    .\Manage-AzureADApp.ps1 -TenantFQDN "example.onmicrosoft.com" -DisplayName "MyApp" -CreateOrUpdateApp -Verbose

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Invoke-AzureADApp {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TenantFQDN,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter()]
        [int]$CustomLifetimeSecretInDays = 1,

        [Parameter()]
        [switch]$CreateOrUpdateApp,

        [Parameter()]
        [switch]$DeleteApp,

        [Parameter()]
        [switch]$UpdateAPIPerms,

        [Parameter()]
        [switch]$CreateClientSecret,

        [Parameter()]
        [switch]$DeleteAllClientSecrets,

        [Parameter()]
        [switch]$ListAllClientSecrets
    )

    function Get-TenantIDFromFQDN {
        param (
            [Parameter(Mandatory = $true)]
            [string]$TenantFQDN
        )
        $oidcConfigDiscoveryURL = "https://login.microsoftonline.com/$TenantFQDN/v2.0/.well-known/openid-configuration"
        try {
            $oidcConfigDiscoveryResult = Invoke-RestMethod -Uri $oidcConfigDiscoveryURL -ErrorAction Stop
            $tenantId = $oidcConfigDiscoveryResult.authorization_endpoint.Split("/")[3]
            Write-Verbose "Retrieved Tenant ID: $tenantId"
        }
        catch {
            Write-Error "Failed to retrieve the information from the discovery endpoint URL."
            throw $_
        }
        return $tenantId
    }

    # Get Tenant ID
    $TenantID = Get-TenantIDFromFQDN -TenantFQDN $TenantFQDN

    # Connect to Microsoft Graph
    try {
        Write-Verbose "Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes "Application.ReadWrite.All" -TenantId $TenantID -NoWelcome -ErrorAction Stop
        Write-Verbose "Connected to Microsoft Graph."
    }
    catch {
        Write-Error "Failed to connect to Microsoft Graph."
        throw $_
    }

    if ($CreateOrUpdateApp) {
        try {
            Write-Verbose "Creating or updating the application..."
            $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($null -eq $app) {
                $app = New-MgApplication -DisplayName $DisplayName -SignInAudience AzureADMyOrg -Web @{ RedirectUris = @("http://localhost") } -ErrorAction Stop
                Write-Verbose "Application created successfully."
            }
            else {
                Update-MgApplication -ApplicationId $app.Id -Web @{ RedirectUris = @("http://localhost") } -ErrorAction Stop
                Write-Verbose "Application updated successfully."
            }

            $appObjectId = $app.Id
            $appId = $app.AppId

            if (-not $appObjectId) {
                throw "ApplicationId is empty, application update failed."
            }

            if ($UpdateAPIPerms) {
                Write-Verbose "Updating API permissions..."
                $msftGraph = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"
                $requiredResourceAccess = @(
                    [PSCustomObject]@{ id = ($msftGraph.AppRoles | Where-Object { $_.Value -eq "Mail.ReadWrite" }).Id; type = "Role" }
                    [PSCustomObject]@{ id = ($msftGraph.AppRoles | Where-Object { $_.Value -eq "Mail.Send" }).Id; type = "Role" }
                    [PSCustomObject]@{ id = ($msftGraph.AppRoles | Where-Object { $_.Value -eq "User.Read" }).Id; type = "Role" }
                )

                Update-MgApplication -ApplicationId $appObjectId -RequiredResourceAccess @(
                    @{
                        ResourceAppId  = $msftGraph.AppId
                        ResourceAccess = $requiredResourceAccess
                    }
                )
                Write-Verbose "API permissions updated."
            }

            if ($CreateClientSecret) {
                Write-Verbose "Creating client secret..."
                $startDate = Get-Date
                $endDate = $startDate.AddDays($CustomLifetimeSecretInDays)
                $passwordCredential = @{
                    displayName   = "Client Secret"
                    startDateTime = $startDate
                    endDateTime   = $endDate
                }
                $clientSecret = Add-MgApplicationPassword -ApplicationId $appObjectId -PasswordCredential $passwordCredential
                Write-Verbose "Client secret created. Value: $($clientSecret.SecretText)"
            }

            [PSCustomObject]@{
                TenantID     = $TenantID
                AppID        = $appId
                ClientSecret = if ($clientSecret) { $clientSecret.SecretText } else { $null }
            }

        }
        catch {
            Write-Error "Failed to create or update the application."
            throw $_
        }
    }

    if ($ListAllClientSecrets) {
        try {
            Write-Verbose "Listing all client secrets..."
            $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($app) {
                $secrets = Get-MgApplication -ApplicationId $app.Id | Select-Object -ExpandProperty PasswordCredentials
                $secrets | ForEach-Object {
                    [PSCustomObject]@{
                        DisplayName   = $_.DisplayName
                        StartDateTime = $_.StartDateTime
                        EndDateTime   = $_.EndDateTime
                    }
                }
            }
            else {
                Write-Host "Application not found."
            }
        }
        catch {
            Write-Error "Failed to list client secrets."
            throw $_
        }
    }

    if ($DeleteAllClientSecrets) {
        try {
            Write-Verbose "Deleting all client secrets..."
            $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($app) {
                $secrets = $app.PasswordCredentials
                foreach ($secret in $secrets) {
                    Remove-MgApplicationPassword -ApplicationId $app.Id -KeyId $secret.KeyId -ErrorAction Stop
                }
                Write-Verbose "All client secrets deleted."
            }
            else {
                Write-Host "Application not found."
            }
        }
        catch {
            Write-Error "Failed to delete client secrets."
            throw $_
        }
    }

    if ($DeleteApp) {
        try {
            Write-Verbose "Deleting the application..."
            $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($app) {
                Remove-MgApplication -ApplicationId $app.Id -ErrorAction Stop
                Write-Host "Application deleted."
            }
            else {
                Write-Host "Application not found."
            }
        }
        catch {
            Write-Error "Failed to delete the application."
            throw $_
        }
    }

    # Disconnect from Microsoft Graph
    try {
        Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
        Write-Verbose "Disconnected from Microsoft Graph."
    }
    catch {
        Write-Verbose "Failed to disconnect from Microsoft Graph."
    }

    # End of script

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Invoke-AzureADApp.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-AzureADApp.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

