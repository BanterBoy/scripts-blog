<#
.SYNOPSIS
    Updates SSL certificates on specified remote servers and IIS bindings.

.DESCRIPTION
    This function imports a PFX certificate to the local machine's personal certificate store, copies the certificate to specified remote servers,
    imports it to their personal certificate stores, and updates IIS bindings to use the new certificate.

.PARAMETER CertPath
    The file path of the PFX certificate.

.PARAMETER CertPassword
    The password for the PFX certificate.

.PARAMETER CertName
    The common name (CN) of the certificate.

.PARAMETER Servers
    A list of remote servers to update with the new certificate.

.EXAMPLE
    PS C:\> Update-SSLCertificate -CertPath "C:\certs\mycert.pfx" -CertPassword "password123" -CertName "www.example.com" -Servers "Server1", "Server2" -Verbose
    Imports the specified certificate and updates the SSL bindings on the specified servers.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Update-SSLCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CertPath,
        
        [Parameter(Mandatory = $true)]
        [string]$CertPassword,
        
        [Parameter(Mandatory = $true)]
        [string]$CertName,
        
        [Parameter(Mandatory = $true)]
        [string[]]$Servers
    )

    try {
        Write-Verbose "Importing the PFX certificate to the local machine's personal certificate store."
        
        # Import the PFX certificate to the local machine's personal certificate store
        $newCert = Import-PfxCertificate -FilePath $CertPath -CertStoreLocation Cert:\LocalMachine\My -Password $CertPassword
        
        Write-Verbose "Copying the PFX certificate to the specified list of remote servers."
        
        # Copy the PFX certificate to the specified list of remote servers
        $Servers | ForEach-Object {
            Copy-Item -Path $CertPath -Destination "\\$_\c$"
            Write-Verbose "Copied PFX certificate to \\$_\c$."
        }
        
        Write-Verbose "Establishing a connection to all of the specified remote servers."
        
        # Establish a connection to all of the specified remote servers
        $session = New-PSSession -ComputerName $Servers
        
        Write-Verbose "Importing the PFX certificate to the personal certificate store on the remote servers."
        
        # Import the PFX certificate to the personal certificate store on the remote servers
        Invoke-Command -Session $session -ScriptBlock {
            Import-PfxCertificate -FilePath "c:\$using:CertName" -CertStoreLocation Cert:\LocalMachine\My -Password $using:CertPassword
            Remove-Item -Path "c:\$using:CertName"
            Write-Verbose "Imported and cleaned up the PFX certificate on remote server."
        }
        
        Write-Verbose "Updating SSL bindings in IIS to use the new certificate on the local machine and remote servers."
        
        # Update SSL bindings in IIS to use the new certificate on the local machine and remote servers
        Import-Module WebAdministration
        
        $sites = Get-ChildItem -Path IIS:\Sites
        
        foreach ($site in $sites) {
            foreach ($binding in $site.Bindings.Collection) {
                if ($binding.protocol -eq 'https') {
                    $search = "Cert:\LocalMachine\My\$($binding.certificateHash)"
                    $certs = Get-ChildItem -Path $search -Recurse
                    $hostname = hostname
                    
                    if (($certs.count -gt 0) -and ($certs[0].Subject.StartsWith("CN=$using:CertName"))) {
                        Write-Output "Updating $hostname, site: `"$($site.name)`", binding: `"$($binding.bindingInformation)`", current cert: `"$($certs[0].Subject)`", Expiry Date: `"$($certs[0].NotAfter)`""
                        $binding.AddSslCertificate($newCert.Thumbprint, "my")
                    }
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        Write-Verbose "Cleaning up the PFX certificate file on the local machine."
        # Clean up the PFX certificate file on the local machine
        Remove-Item -Path $CertPath -ErrorAction SilentlyContinue
        Write-Verbose "Cleanup completed."
    }
}

# Example call to the function with verbose output
# Update-SSLCertificate -CertPath "C:\certs\mycert.pfx" -CertPassword "password123" -CertName "www.example.com" -Servers "Server1", "Server2" -Verbose
