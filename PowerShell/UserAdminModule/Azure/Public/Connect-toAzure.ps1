<#
.SYNOPSIS
Connects to Azure using the specified credentials.

.DESCRIPTION
This function connects to Azure using the provided Tenant ID, Subscription ID, Client ID, and Client Secret. It creates a new Azure context and sets it as the current context for the session.

.PARAMETER TenantId
The ID of the Azure Active Directory tenant.

.PARAMETER SubscriptionId
The ID of the Azure subscription.

.PARAMETER ClientId
The ID of the Azure Active Directory application (service principal) used for authentication.

.PARAMETER ClientSecret
The secret key of the Azure Active Directory application (service principal) used for authentication.

.EXAMPLE
Connect-toAzure -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientSecret "xxxxxxxxxxxxxxxxxxxx"

Connects to Azure using the specified credentials.

#>

function Connect-toAzure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [string]
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [string]
        $ClientId,

        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret
    )

    $InformationPreference = "Continue"

    Disable-AzContextAutosave -Scope Process | Out-Null

    $creds = [System.Management.Automation.PSCredential]::new($ClientId, (ConvertTo-SecureString $ClientSecret -AsPlainText -Force))
    Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -Credential $creds -ServicePrincipal | Out-Null
    Write-Information "Connected to Azure..."
}
