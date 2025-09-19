<#
.SYNOPSIS
Connects to Microsoft Graph API using an application with a certificate.

.DESCRIPTION
This function connects to Microsoft Graph API using an application with a certificate. It requires the tenant ID, client ID, and certificate name as input parameters. The function retrieves the certificate thumbprint based on the provided certificate name and connects to Microsoft Graph API using the Connect-MgGraph cmdlet.

.PARAMETER TenantId
The tenant ID of the Microsoft Graph API.

.PARAMETER ClientId
The client ID of the Microsoft Graph API application.

.PARAMETER CertName
The name of the certificate to be used for authentication.

.EXAMPLE
Connect-toMSGraphApplicationWithCertificate -TenantId "12345678-1234-1234-1234-1234567890ab" -ClientId "12345678-1234-1234-1234-1234567890ab" -CertName "MyCertificate"

Connects to Microsoft Graph API using the specified tenant ID, client ID, and certificate name.

.INPUTS
None.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0

.LINK
https://docs.microsoft.com/en-us/graph/overview

#>

function Connect-toMSGraphApplicationWithCertificate {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (

        [Parameter(Mandatory = $true, HelpMessage = "Enter the MSGraph tenant ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid TenantId format. It should be a GUID." }
            })]
        [string]
        $TenantId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the MSGraph client ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid ClientId format. It should be a GUID." }
            })]
        [string]
        $ClientId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the certificate name.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[a-zA-Z0-9 *?]+$') { $true } else { throw "Invalid CertName format. It should be an alphanumeric string with optional spaces and wildcard characters." }
            })]
        [string]
        $CertName
    )

    $InformationPreference = "Continue"
    
    if ($PSCmdlet.ShouldProcess("Connecting to MSGraph with Application: $ClientId")) {
        try {
            $CertificateThumbprint = (Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Subject -match $CertName }).Thumbprint
            if (!$CertificateThumbprint) {
                throw "Certificate with name $CertName not found in the CurrentUser\My store."
            }
            Connect-MgGraph -ClientId $ClientID -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
            Write-Verbose "Connected to MSGraph with ClientId: $ClientId and CertificateThumbprint: $CertificateThumbprint at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }
        catch {
            Write-Error "Failed to connect to MSGraph: $_"
        }
    }
}
