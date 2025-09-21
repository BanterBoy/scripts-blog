---
layout: post
title: Get-AzEnterpriseAppConfig.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/azure/get-azenterpriseappconfig/
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

Retrieves configuration details for an enterprise application (service principal) using the Microsoft.Entra module.

#### Detailed Description

Resolves a service principal by application ID or object ID, fetches the backing application, and gathers related configuration such as redirect URIs, required resource access, owners, credentials, and assigned permissions. The function imports Microsoft.Entra, ensures the necessary scopes are granted, and returns a consolidated object containing both application and service principal properties.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-AzEnterpriseAppConfig -AppIdOrObjectId '00000000-0000-0000-0000-000000000000'
```

Retrieves the enterprise application details for the specified application ID.

**Example 2**

```powershell
PS C:\> '00000000-0000-0000-0000-000000000000' | Get-AzEnterpriseAppConfig -Verbose
```

Uses pipeline input and emits verbose output while collecting the configuration information.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires Microsoft.Entra PowerShell module 1.0.10 or later, Microsoft.Graph.Authentication module, and permissions granting the following scopes: Application.Read.All, Directory.Read.All, AppRoleAssignment.Read.All, DelegatedPermissionGrant.Read.All.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-AzEnterpriseAppConfig {
    <#
    .SYNOPSIS
    Retrieves configuration details for an enterprise application (service principal) using the Microsoft.Entra module.

    .DESCRIPTION
    Resolves a service principal by application ID or object ID, fetches the backing application, and gathers
    related configuration such as redirect URIs, required resource access, owners, credentials, and assigned
    permissions. The function imports Microsoft.Entra, ensures the necessary scopes are granted, and returns a
    consolidated object containing both application and service principal properties.

    .PARAMETER AppIdOrObjectId
    The application (client) ID or the object ID of the enterprise application (service principal) to retrieve.
    Accepts pipeline input.

    .PARAMETER SkipConnect
    Skips calling Connect-Entra when set. Use this if a Microsoft.Entra connection with the required scopes
    already exists.

    .EXAMPLE
    PS C:\> Get-AzEnterpriseAppConfig -AppIdOrObjectId '00000000-0000-0000-0000-000000000000'

    Retrieves the enterprise application details for the specified application ID.

    .EXAMPLE
    PS C:\> '00000000-0000-0000-0000-000000000000' | Get-AzEnterpriseAppConfig -Verbose

    Uses pipeline input and emits verbose output while collecting the configuration information.

    .NOTES
    Requires Microsoft.Entra PowerShell module 1.0.10 or later, Microsoft.Graph.Authentication module, and permissions
    granting the following scopes: Application.Read.All, Directory.Read.All, AppRoleAssignment.Read.All,
    DelegatedPermissionGrant.Read.All.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppIdOrObjectId,

        [Parameter()]
        [switch]$SkipConnect
    )

    begin {
        Write-Verbose 'Importing Microsoft.Entra module.'
        Import-Module -Name Microsoft.Entra -ErrorAction Stop

        $requiredScopes = @(
            'Application.Read.All'
            'Directory.Read.All'
            'AppRoleAssignment.Read.All'
            'DelegatedPermissionGrant.Read.All'
        )

        if (-not $SkipConnect.IsPresent) {
            $context = $null
            $contextCommand = Get-Command -Name Get-EntraContext -ErrorAction SilentlyContinue
            if ($contextCommand) {
                try {
                    $context = Get-EntraContext -ErrorAction Stop
                }
                catch {
                    Write-Verbose ("Unable to retrieve existing Entra context: {0}" -f $_)
                }
            }

            $scopesSatisfied = $false
            if ($context -and $context.Scopes) {
                $scopesSatisfied = $true
                foreach ($scope in $requiredScopes) {
                    if ($context.Scopes -notcontains $scope) {
                        $scopesSatisfied = $false
                        break
                    }
                }
            }

            if (-not $scopesSatisfied) {
                $connectCommand = Get-Command -Name Connect-Entra -ErrorAction SilentlyContinue
                if (-not $connectCommand) {
                    throw 'Connect-Entra cmdlet was not found. Install Microsoft.Entra module version 1.0.10 or later.'
                }

                Write-Verbose 'Connecting to Microsoft Entra with required scopes.'
                try {
                    if (-not (Get-Command -Name Connect-MgGraph -ErrorAction SilentlyContinue)) {
                        $graphAuthModule = Get-Module -Name Microsoft.Graph.Authentication -ListAvailable |
                            Sort-Object -Property Version -Descending |
                            Select-Object -First 1

                        if ($graphAuthModule) {
                            Write-Verbose ("Importing Microsoft.Graph.Authentication module version {0}." -f $graphAuthModule.Version)
                            Import-Module -Name Microsoft.Graph.Authentication -ErrorAction Stop
                        }
                    }

                    if (-not (Get-Command -Name Connect-MgGraph -ErrorAction SilentlyContinue)) {
                        throw "Connect-Entra requires the Microsoft.Graph.Authentication module. Install it using 'Install-Module -Name Microsoft.Graph.Authentication'."
                    }

                    Connect-Entra -Scopes $requiredScopes -ErrorAction Stop | Out-Null
                }
                catch {
                    if ($_.Exception -and ($_.Exception.Message -match 'BadExpression' -or $_.FullyQualifiedErrorId -eq 'BadExpression')) {
                        throw "Connect-Entra failed because Microsoft.Graph.Authentication is not installed. Install it using 'Install-Module -Name Microsoft.Graph.Authentication'."
                    }

                    throw
                }
            }
            else {
                Write-Verbose 'Existing Microsoft Entra connection has the required scopes.'
            }
        }

        $availableCommands = [ordered]@{
            ApplicationOwner                  = [bool](Get-Command -Name Get-EntraApplicationOwner -ErrorAction SilentlyContinue)
            ServicePrincipalOwner             = [bool](Get-Command -Name Get-EntraServicePrincipalOwner -ErrorAction SilentlyContinue)
            ApplicationPasswordCredential     = [bool](Get-Command -Name Get-EntraApplicationPasswordCredential -ErrorAction SilentlyContinue)
            ApplicationKeyCredential          = [bool](Get-Command -Name Get-EntraApplicationKeyCredential -ErrorAction SilentlyContinue)
            ApplicationFederatedCredential    = [bool](Get-Command -Name Get-EntraApplicationFederatedIdentityCredential -ErrorAction SilentlyContinue)
            ServicePrincipalAppRoleAssignedTo = [bool](Get-Command -Name Get-EntraServicePrincipalAppRoleAssignedTo -ErrorAction SilentlyContinue)
            ServicePrincipalOauth2Grant       = [bool](Get-Command -Name Get-EntraServicePrincipalOauth2PermissionGrant -ErrorAction SilentlyContinue)
        }

        $resourceDisplayNameCache = @{}
    }

    process {
        $escapedIdentifier = $AppIdOrObjectId -replace "'", "''"

        # Validate that the input is a valid GUID before using in filter
        $isGuid = $false
        try {
            $null = [guid]::Parse($AppIdOrObjectId)
            $isGuid = $true
        }
        catch {
            $isGuid = $false
        }

        try {
            Write-Verbose ("Resolving service principal for identifier '{0}'." -f $AppIdOrObjectId)
            if ($isGuid) {
                $servicePrincipal = Get-EntraServicePrincipal -Filter "appId eq '$escapedIdentifier'" -ErrorAction SilentlyContinue |
                    Select-Object -First 1
            }
            else {
                $servicePrincipal = $null
            }

            if (-not $servicePrincipal) {
                Write-Verbose 'Service principal not found by AppId. Trying object id lookup.'
                $servicePrincipal = Get-EntraServicePrincipal -ServicePrincipalId $AppIdOrObjectId -ErrorAction Stop
            }

            Write-Verbose ("Service principal resolved: {0} [{1}]." -f $servicePrincipal.DisplayName, $servicePrincipal.Id)

            $application = Get-EntraApplication -Filter "appId eq '$($servicePrincipal.AppId)'" -ErrorAction Stop |
                Select-Object -First 1

            if (-not $application) {
                throw "Application object for AppId '$($servicePrincipal.AppId)' was not found."
            }

            Write-Verbose ("Application object resolved: {0} [{1}]." -f $application.DisplayName, $application.Id)

            $applicationOwners = @()
            if ($availableCommands.ApplicationOwner) {
                try {
                    $ownerResult = Get-EntraApplicationOwner -ApplicationId $application.Id -All -ErrorAction Stop
                    if ($ownerResult) {
                        $applicationOwners = [array]$ownerResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve application owners: {0}" -f $_)
                }
            }

            $servicePrincipalOwners = @()
            if ($availableCommands.ServicePrincipalOwner) {
                try {
                    $spOwnerResult = Get-EntraServicePrincipalOwner -ServicePrincipalId $servicePrincipal.Id -All -ErrorAction Stop
                    if ($spOwnerResult) {
                        $servicePrincipalOwners = [array]$spOwnerResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve service principal owners: {0}" -f $_)
                }
            }

            $passwordCredentials = @()
            if ($availableCommands.ApplicationPasswordCredential) {
                try {
                    $passwordResult = Get-EntraApplicationPasswordCredential -ApplicationId $application.Id -All -ErrorAction Stop
                    if ($passwordResult) {
                        $passwordCredentials = [array]$passwordResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve password credentials: {0}" -f $_)
                }
            }

            $keyCredentials = @()
            if ($availableCommands.ApplicationKeyCredential) {
                try {
                    $keyResult = Get-EntraApplicationKeyCredential -ApplicationId $application.Id -All -ErrorAction Stop
                    if ($keyResult) {
                        $keyCredentials = [array]$keyResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve key credentials: {0}" -f $_)
                }
            }

            $federatedCredentials = @()
            if ($availableCommands.ApplicationFederatedCredential) {
                try {
                    $fedResult = Get-EntraApplicationFederatedIdentityCredential -ApplicationId $application.Id -All -ErrorAction Stop
                    if ($fedResult) {
                        $federatedCredentials = [array]$fedResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve federated identity credentials: {0}" -f $_)
                }
            }

            $appRoleAssignments = @()
            if ($availableCommands.ServicePrincipalAppRoleAssignedTo) {
                try {
                    $assignmentResult = Get-EntraServicePrincipalAppRoleAssignedTo -ServicePrincipalId $servicePrincipal.Id -All -ErrorAction Stop
                    if ($assignmentResult) {
                        $appRoleAssignments = [array]$assignmentResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve app role assignments: {0}" -f $_)
                }
            }

            $oauth2PermissionGrants = @()
            if ($availableCommands.ServicePrincipalOauth2Grant) {
                try {
                    $grantResult = Get-EntraServicePrincipalOauth2PermissionGrant -ServicePrincipalId $servicePrincipal.Id -All -ErrorAction Stop
                    if ($grantResult) {
                        $oauth2PermissionGrants = [array]$grantResult
                    }
                }
                catch {
                    Write-Verbose ("Unable to retrieve OAuth2 permission grants: {0}" -f $_)
                }
            }

            [array]$resourceAccessDetails = @()
            if ($application.RequiredResourceAccess) {
                [array]$resourceAccessDetails = foreach ($resource in $application.RequiredResourceAccess) {
                    $resourceDisplayName = $null
                    if ($resource.ResourceAppId) {
                        if ($resourceDisplayNameCache.ContainsKey($resource.ResourceAppId)) {
                            $resourceDisplayName = $resourceDisplayNameCache[$resource.ResourceAppId]
                        }
                        else {
                            try {
                                $resourceLookup = Get-EntraServicePrincipal -Filter "appId eq '$($resource.ResourceAppId)'" -ErrorAction SilentlyContinue |
                                    Select-Object -First 1

                                if ($resourceLookup) {
                                    $resourceDisplayName = $resourceLookup.DisplayName
                                }
                            }
                            catch {
                                Write-Verbose ("Unable to resolve display name for resource app {0}: {1}" -f $resource.ResourceAppId, $_)
                            }

                            $resourceDisplayNameCache[$resource.ResourceAppId] = $resourceDisplayName
                        }
                    }

                    [array]$delegatedPermissions = foreach ($access in $resource.ResourceAccess) {
                        if ($access.Type -eq 'Scope') {
                            [PSCustomObject]@{
                                Id   = $access.Id
                                Type = $access.Type
                            }
                        }
                    }

                    [array]$applicationPermissions = foreach ($access in $resource.ResourceAccess) {
                        if ($access.Type -eq 'Role') {
                            [PSCustomObject]@{
                                Id   = $access.Id
                                Type = $access.Type
                            }
                        }
                    }

                    [PSCustomObject]@{
                        ResourceAppId          = $resource.ResourceAppId
                        ResourceDisplayName    = $resourceDisplayName
                        DelegatedPermissions   = $delegatedPermissions
                        ApplicationPermissions = $applicationPermissions
                        ResourceAccess         = $resource.ResourceAccess
                    }
                }
            }

            $webConfiguration = $null
            if ($application.Web) {
                [array]$webRedirectUris = if ($application.Web.RedirectUris) { $application.Web.RedirectUris } else { @() }
                $webConfiguration = [PSCustomObject]@{
                    HomePageUrl           = $application.Web.HomePageUrl
                    RedirectUris          = $webRedirectUris
                    LogoutUrl             = $application.Web.LogoutUrl
                    ImplicitGrantSettings = $application.Web.ImplicitGrantSettings
                }
            }

            [array]$spaRedirectUris = if ($application.Spa -and $application.Spa.RedirectUris) { $application.Spa.RedirectUris } else { @() }
            [array]$publicClientRedirectUris = if ($application.PublicClient -and $application.PublicClient.RedirectUris) { $application.PublicClient.RedirectUris } else { @() }

            $apiConfiguration = $null
            if ($application.Api) {
                [array]$oauth2Scopes = if ($application.Api.Oauth2PermissionScopes) { $application.Api.Oauth2PermissionScopes } else { @() }
                [array]$preAuthApps = if ($application.Api.PreAuthorizedApplications) { $application.Api.PreAuthorizedApplications } else { @() }
                $apiConfiguration = [PSCustomObject]@{
                    Oauth2PermissionScopes      = $oauth2Scopes
                    PreAuthorizedApplications   = $preAuthApps
                    RequestedAccessTokenVersion = $application.Api.RequestedAccessTokenVersion
                }
            }

            [array]$appRoles = if ($application.AppRoles) { $application.AppRoles } else { @() }
            [array]$identifierUris = if ($application.IdentifierUris) { $application.IdentifierUris } else { @() }
            [array]$optionalClaims = if ($application.OptionalClaims) { $application.OptionalClaims } else { @() }
            [array]$tags = if ($servicePrincipal.Tags) { $servicePrincipal.Tags } else { @() }
            [array]$servicePrincipalNames = if ($servicePrincipal.ServicePrincipalNames) { $servicePrincipal.ServicePrincipalNames } else { @() }
            [array]$apiPermissions = if ($application.Api -and $application.Api.Oauth2PermissionScopes) { $application.Api.Oauth2PermissionScopes } else { @() }

            [PSCustomObject]@{
                DisplayName                     = $servicePrincipal.DisplayName
                AppId                           = $servicePrincipal.AppId
                ObjectId                        = $servicePrincipal.Id
                ApplicationObjectId             = $application.Id
                Description                     = $application.Description
                SignInAudience                  = $application.SignInAudience
                PublisherDomain                 = $application.PublisherDomain
                VerifiedPublisher               = $application.VerifiedPublisher
                ServicePrincipalNames           = $servicePrincipalNames
                Tags                            = $tags
                Homepage                        = if ($webConfiguration) { $webConfiguration.HomePageUrl } else { $null }
                RedirectUris                    = if ($webConfiguration) { $webConfiguration.RedirectUris } else { @() }
                LogoutUrl                       = if ($webConfiguration) { $webConfiguration.LogoutUrl } else { $null }
                Web                             = $webConfiguration
                SpaRedirectUris                 = $spaRedirectUris
                PublicClientRedirectUris        = $publicClientRedirectUris
                IdentifierUris                  = $identifierUris
                OptionalClaims                  = $optionalClaims
                AppRoles                        = $appRoles
                RequiredResourceAccess          = $resourceAccessDetails
                Api                             = $apiConfiguration
                ApiPermissions                  = $apiPermissions
                PasswordCredentials             = $passwordCredentials
                KeyCredentials                  = $keyCredentials
                FederatedIdentityCredentials    = $federatedCredentials
                Owners                          = [PSCustomObject]@{
                                                    Application      = $applicationOwners
                                                    ServicePrincipal = $servicePrincipalOwners
                                                }
                AppRoleAssignments              = $appRoleAssignments
                OAuth2PermissionGrants          = $oauth2PermissionGrants
                Notes                           = if ($application.Info) { $application.Info.Notes } else { $null }
                CreatedDateTime                 = $application.CreatedDateTime
                ServicePrincipalCreatedDateTime = $servicePrincipal.CreatedDateTime
                TokenEncryptionKeyId            = $application.TokenEncryptionKeyId
            }
        }
        catch {
            throw "Failed to retrieve application configuration: $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Get-AzEnterpriseAppConfig.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AzEnterpriseAppConfig.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

