<#
.SYNOPSIS
Creates a new code signing certificate.

.DESCRIPTION
The New-CodeSigningCert function creates a new code signing certificate using the New-SelfSignedCertificate cmdlet. 
It allows you to specify the friendly name, name, password, file path, and whether the certificate should be trusted.

.PARAMETER FriendlyName
Specifies the friendly name for the certificate.

.PARAMETER Name
Specifies the name for the certificate.

.PARAMETER Password
Specifies the password for the exported certificate. This parameter is mandatory when using the "Export" parameter set.

.PARAMETER FilePath
Specifies the file path where the exported certificate should be saved. This parameter is mandatory when using the "Export" parameter set.

.PARAMETER Trusted
Indicates whether the certificate should be added to the trusted root store. By default, the certificate is not added to the trusted root store.

.EXAMPLE
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Trusted
Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is added to the trusted root store.

.EXAMPLE
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Password $securePassword -FilePath "C:\Certificates\MyCert.pfx"
Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is exported to the specified file path with the provided password.

#>
function New-CodeSigningCert {
	[CmdletBinding(
		DefaultParametersetName = "__AllParameterSets",
		SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory)]
		[String]
		$FriendlyName,

		[Parameter(Mandatory)]
		[String]
		$Name,

		[Parameter(Mandatory, ParameterSetName = "Export")]
		[SecureString]
		$Password,

		[Parameter(Mandatory, ParameterSetName = "Export")]
		[String]
		$FilePath,

		[Switch]
		$Trusted
	)

	# create new cert
	$cert = New-SelfSignedCertificate -KeyUsage DigitalSignature -KeySpec Signature -FriendlyName $FriendlyName -Subject "CN=$Name" -KeyExportPolicy ExportableEncrypted -CertStoreLocation Cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(5) -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3')


	if ($PSCmdlet.ShouldProcess("Create", "New certificate $FriendlyName")) {
		if ($Trusted) {
			$Store = New-Object system.security.cryptography.X509Certificates.x509Store("Root", "CurrentUser")
			$Store.Open("ReadWrite")
			$Store.Add($cert)
			$Store.Close()
		}
	}

	$parameterSet = $PSCmdlet.ParameterSetName.ToLower()

	if ($PSCmdlet.ShouldProcess("Export", "$FilePath")) {
		if ($parameterSet -eq "export") {
			# export to file
			$cert | Export-PfxCertificate -Password $Password -FilePath $FilePath

			$cert | Remove-Item
			explorer.exe /select, $FilePath
		}
		else {
			$cert
		}
	}

}
