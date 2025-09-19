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
