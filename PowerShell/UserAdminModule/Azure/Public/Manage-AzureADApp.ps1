<#
.SYNOPSIS
    Manages Azure AD application registrations.

.DESCRIPTION
    This script allows you to create, update, list client secrets, and delete Azure AD application registrations.
    It can also update API permissions and create new client secrets for the applications. The script interacts
    with Microsoft Graph API to perform these operations.

.PARAMETER ConfigFilePath
    The path to the JSON configuration file.

.PARAMETER TenantFQDN
    The Fully Qualified Domain Name (FQDN) of the Azure AD tenant. This is typically in the format of "yourdomain.onmicrosoft.com".

.PARAMETER DisplayName
    The display name of the application registration. This name is used to identify the app within Azure AD.

.PARAMETER CustomLifetimeSecretInDays
    The custom lifetime of the client secret in days. The default is 1 day. This specifies how long the client secret is valid.

.PARAMETER CreateOrUpdateApp
    Switch to create or update the application. If the app with the specified DisplayName does not exist, it will be created. If it exists, it will be updated.

.PARAMETER DeleteApp
    Switch to delete the application. The app identified by the DisplayName will be deleted from Azure AD.

.PARAMETER UpdateAPIPerms
    Switch to update API permissions. This will set the required API permissions for the application.

.PARAMETER Permissions
    List of API permissions to assign to the application. This parameter allows specifying a custom list of permissions.

.PARAMETER CreateClientSecret
    Switch to create a new client secret for the application. This will generate a new client secret with the specified lifetime.

.PARAMETER DeleteAllClientSecrets
    Switch to delete all existing client secrets of the application. This removes all secrets associated with the app.

.PARAMETER ListAllClientSecrets
    Switch to list all existing client secrets of the application. This will display details of all secrets for the app.

.PARAMETER Disconnect
    Switch to disconnect from Microsoft Graph. No other parameters are required when this switch is used.

.PARAMETER DisconnectAfter
    Switch to disconnect from Microsoft Graph after the operation is completed.

.EXAMPLE
    Manage-AzureADApp -ConfigFilePath "C:\path\to\config.json" -Verbose

    This example creates or updates an Azure AD application based on the configuration specified in the JSON file.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Manage-AzureADApp {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            ParameterSetName = "ConfigFile",
            Mandatory = $true,
            HelpMessage = "The path to the JSON configuration file."
        )]
        [string]$ConfigFilePath,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "The Fully Qualified Domain Name (FQDN) of the Azure AD tenant."
        )]
        [string]$TenantFQDN,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "The display name of the application registration."
        )]
        [string]$DisplayName,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "The custom lifetime of the client secret in days. The default is 1 day."
        )]
        [int]$CustomLifetimeSecretInDays = 1,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to create or update the application."
        )]
        [switch]$CreateOrUpdateApp,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to delete the application."
        )]
        [switch]$DeleteApp,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to update API permissions."
        )]
        [switch]$UpdateAPIPerms,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "List of API permissions to assign to the application."
        )]
        [string[]]$Permissions,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to create a new client secret for the application."
        )]
        [switch]$CreateClientSecret,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to delete all existing client secrets of the application."
        )]
        [switch]$DeleteAllClientSecrets,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to list all existing client secrets of the application."
        )]
        [switch]$ListAllClientSecrets,

        [Parameter(
            ParameterSetName = "Disconnect",
            Mandatory = $true,
            HelpMessage = "Switch to disconnect from Microsoft Graph."
        )]
        [switch]$Disconnect,

        [Parameter(
            ParameterSetName = "ManageApp",
            HelpMessage = "Switch to disconnect from Microsoft Graph after the operation is completed."
        )]
        [switch]$DisconnectAfter
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq "ConfigFile") {
            # Load configuration from JSON file
            if (-not (Test-Path -Path $ConfigFilePath -PathType Leaf)) {
                throw "Configuration file not found: $ConfigFilePath"
            }
            $config = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
            $TenantFQDN = $config.TenantFQDN
            $DisplayName = $config.DisplayName
            $Permissions = $config.Permissions
            $CustomLifetimeSecretInDays = $config.CustomLifetimeSecretInDays
            $CreateOrUpdateApp = $config.CreateOrUpdateApp
            $UpdateAPIPerms = $config.UpdateAPIPerms
            $CreateClientSecret = $config.CreateClientSecret
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -ne "Disconnect") {
            # Function to get the Tenant ID from the FQDN
            function Get-TenantIDFromFQDN {
                param (
                    [Parameter(Mandatory = $true)]
                    [string]$TenantFQDN
                )
                # Construct the OpenID configuration discovery URL
                $oidcConfigDiscoveryURL = "https://login.microsoftonline.com/$TenantFQDN/v2.0/.well-known/openid-configuration"
                try {
                    # Make a request to the discovery URL to retrieve the Tenant ID
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

            # Retrieve the Tenant ID using the provided FQDN
            $TenantID = Get-TenantIDFromFQDN -TenantFQDN $TenantFQDN

            # Connect to Microsoft Graph API
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
                if ($PSCmdlet.ShouldProcess("$DisplayName in $TenantFQDN", "Manage-AzureADApp")) {
                    try {
                        Write-Verbose "Creating or updating the application..."
                        # Check if the application already exists
                        $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                        if ($null -eq $app) {
                            # If the application does not exist, create it
                            $app = New-MgApplication -DisplayName $DisplayName -SignInAudience AzureADMyOrg -Web @{ RedirectUris = @("http://localhost") } -ErrorAction Stop
                            Write-Verbose "Application created successfully."
                        }
                        else {
                            # If the application exists, update it
                            Update-MgApplication -ApplicationId $app.Id -Web @{ RedirectUris = @("http://localhost") } -ErrorAction Stop
                            Write-Verbose "Application updated successfully."
                        }

                        $appObjectId = $app.Id
                        $appId = $app.AppId

                        if (-not $appObjectId) {
                            throw "ApplicationId is empty, application update failed."
                        }

                        if ($UpdateAPIPerms -and $Permissions) {
                            Write-Verbose "Updating API permissions..."

                            # Get Microsoft Graph service principal
                            $graphServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

                            # Define the required API permissions
                            $resourceAccess = @()
                            foreach ($permission in $Permissions) {
                                $scope = $graphServicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Value -eq $permission }
                                if ($null -ne $scope) {
                                    $resourceAccess += @{
                                        "id"   = $scope.Id
                                        "type" = "Scope"
                                    }
                                }
                            }

                            $requiredResourceAccess = @(
                                @{
                                    "resourceAppId"  = $graphServicePrincipal.AppId
                                    "resourceAccess" = $resourceAccess
                                }
                            )

                            # Update the application with the required API permissions
                            Update-MgApplication -ApplicationId $appObjectId -RequiredResourceAccess $requiredResourceAccess
                            Write-Verbose "API permissions updated."
                        }

                        if ($CreateClientSecret) {
                            Write-Verbose "Creating client secret..."
                            # Define the start and end dates for the client secret
                            $startDate = Get-Date
                            $endDate = $startDate.AddDays($CustomLifetimeSecretInDays)
                            $passwordCredential = @{
                                displayName   = "Client Secret"
                                startDateTime = $startDate
                                endDateTime   = $endDate
                            }
                            # Create the client secret
                            $clientSecret = Add-MgApplicationPassword -ApplicationId $appObjectId -PasswordCredential $passwordCredential
                            Write-Verbose "Client secret created. Value: $($clientSecret.SecretText)"
                        }

                        # Output the application details
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
            }

            if ($ListAllClientSecrets) {
                try {
                    Write-Verbose "Listing all client secrets..."
                    # Retrieve the application based on the display name
                    $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                    if ($app) {
                        # List all client secrets for the application
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
                    # Retrieve the application based on the display name
                    $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                    if ($app) {
                        # Delete all client secrets for the application
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
                    # Retrieve the application based on the display name
                    $app = Get-MgApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                    if ($app) {
                        # Delete the application
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
            if ($DisconnectAfter) {
                try {
                    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
                    Write-Verbose "Disconnected from Microsoft Graph."
                }
                catch {
                    Write-Verbose "Failed to disconnect from Microsoft Graph."
                }
            }
        }
        elseif ($Disconnect) {
            try {
                Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
                Write-Verbose "Disconnected from Microsoft Graph."
            }
            catch {
                Write-Verbose "Failed to disconnect from Microsoft Graph."
            }
        }
    }
}
