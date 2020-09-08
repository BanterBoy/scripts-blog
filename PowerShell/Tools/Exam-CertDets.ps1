<#
Examining Certificate Details

All Versions

If you’d like to examine and view the details of a certificate file without the need to import it into your certificate store, here is a simple example:
#>

# replace path with actual path to CER file 

$Path = 'C:\Path\To\CertificateFile\test.cer'

Add-Type -AssemblyName System.Security
[Security.Cryptography.X509Certificates.X509Certificate2]$cert = [Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($Path)

$cert | Select-Object -Property *
