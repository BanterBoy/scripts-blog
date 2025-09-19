<#
.SYNOPSIS
  Retrieves an access token for a specified resource using Azure Active Directory App-Only authentication.

.DESCRIPTION
  The Get-AccessToken function retrieves an access token for a specified resource using Azure Active Directory App-Only authentication. 
  It requires the TenantId, ClientId, CertificatePath, CertificatePassword, and ResourceUri parameters to be provided.

.PARAMETER TenantId
  Specifies the Azure Active Directory tenant ID. This parameter is mandatory.

.PARAMETER ClientId
  Specifies the Azure Active Directory application client ID. This parameter is mandatory.

.PARAMETER CertificatePath
  Specifies the path to the certificate file used for authentication. This parameter is mandatory.

.PARAMETER CertificatePassword
  Specifies the password for the certificate file used for authentication. This parameter is mandatory.

.PARAMETER ResourceUri
  Specifies the URI of the resource for which the access token is requested. This parameter is mandatory.

.EXAMPLE
  Get-AccessToken -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -CertificatePath "C:\Certificates\MyCertificate.pfx" -CertificatePassword "MyPassword" -ResourceUri "https://api.example.com"

.NOTES
  This function requires the Microsoft.IdentityModel.Clients.ActiveDirectory assembly to be loaded.
  The certificate used for authentication must be stored in the LocalMachine certificate store.
#>
function Get-AccessToken() {
  Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantId,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientId,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePath,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePassword,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceUri
  )
  
  # Rest of the code...
}
<#
.DESCRIPTION 
.PARAMETER
.EXAMPLE
#>
function Get-AccessToken() {
  Param(
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantId = $global:AzureADApplicationTenantId,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientId = $global:AzureADApplicationClientId,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePath = $global:AzureADApplicationCertificatePath,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePassword = $global:AzureADApplicationCertificatePassword,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceUri
  )
  
  #region Validations
  #-----------------------------------------------------------------------
  # Validating the TenantId
  #-----------------------------------------------------------------------
  if (!(Is-Guid -Value $TenantId)) {
    throw [Exception] "TenantId '$TenantId' is not a valid Guid"
  }
  
  #-----------------------------------------------------------------------
  # Validating the ClientId
  #-----------------------------------------------------------------------
  if (!(Is-Guid -Value $ClientId)) {
    throw [Exception] "ClientId '$ClientId' is not a valid Guid"
  }
  
  #-----------------------------------------------------------------------
  # Validating the Certificate Path
  #-----------------------------------------------------------------------
  if (!(Test-Path -Path $CertificatePath)) {
    throw [Exception] "CertificatePath '$CertificatePath' does not exist"
  }
  #endregion
  
  #region Initialization
  #-----------------------------------------------------------------------
  # Loads the Azure Active Directory Assemblies 
  #-----------------------------------------------------------------------
  Add-Type -Path "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll" | Out-Null
  
  #-----------------------------------------------------------------------
  # Constants 
  #-----------------------------------------------------------------------
  $keyStorageFlags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet
  
  #-----------------------------------------------------------------------
  # Building required values
  #-----------------------------------------------------------------------
  $authorizationUriFormat = "https://login.windows.net/{0}/oauth2/authorize"
  $authorizationUri = [String]::Format($authorizationUriFormat, $TenantId)
  #endregion
  
  #region Process
  #-----------------------------------------------------------------------
  # Building the necessary context to acquire the Access Token
  #-----------------------------------------------------------------------
  $authenticationContext = New-Object -TypeName "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authorizationUri, $false
  $certificate = New-Object -TypeName "System.Security.Cryptography.X509Certificates.X509Certificate2" -ArgumentList $CertificatePath, $CertificatePassword, $keyStorageFlags
  $assertionCertificate = New-Object -TypeName "Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate" -ArgumentList $ClientId, $certificate

  #-----------------------------------------------------------------------
  # Ask for the AccessToken based on the App-Only configuration
  #-----------------------------------------------------------------------
  $authenticationResult = $authenticationContext.AcquireToken($ResourceUri, $assertionCertificate)
  
  #-----------------------------------------------------------------------
  # Returns the an AccessToken valid for an hour
  #-----------------------------------------------------------------------
  return $authenticationResult.AccessToken
  #endregion
}