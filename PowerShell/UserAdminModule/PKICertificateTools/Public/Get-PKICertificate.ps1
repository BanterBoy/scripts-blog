<#
.SYNOPSIS
    Retrieves PKI certificates from one or more specified computers.

.DESCRIPTION
    This function retrieves PKI certificates from the local machine’s certificate store on one or more specified computers.
    Optionally, it can filter the certificates by issuer or by certificate status/type (Active, Issued, Dependencies, or Expired).
    In addition, the function outputs extended certificate details for enhanced PKI analysis.

.PARAMETER ComputerName
    The names of the computers from which to retrieve certificates.
    Defaults to the local computer if not specified.

.PARAMETER IssuerFilter
    An optional filter for the issuer name.
    If not specified, all certificates are retrieved regardless of issuer.

.PARAMETER CertificateType
    The type of certificates to retrieve. Valid values are 'Active', 'Issued', 'Dependencies', and 'Expired'.
    Defaults to 'Active'. 'Active' certificates have NotAfter greater than the current date.
    'Expired' certificates have NotAfter less than or equal to the current date.
    'Issued' certificates include additional validity information.
    'Dependencies' can be used to drive additional logic if needed.

.PARAMETER Credential
    The PSCredential to use for remote connections.
    If not specified, the current user's credentials are used.

.EXAMPLE
    # Retrieve all active certificates from the local computer with extended details
    Get-PKICertificate -CertificateType Active | Format-Table

.EXAMPLE
    # Retrieve all issued certificates from a remote computer
    Get-PKICertificate -ComputerName "RemoteMachine01" -CertificateType Issued | Format-Table

.EXAMPLE
    # Retrieve certificates filtered by issuer from multiple computers
    $Certs = Get-PKICertificate -ComputerName "RemoteMachine01", "RemoteMachine02" -IssuerFilter "CN=ExampleIssuer"
    $Certs | Format-Table

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Get-PKICertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "The names of the computers from which to retrieve certificates. Defaults to the local computer.")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, HelpMessage = "The issuer name to filter the certificates. If not specified, all certificates are retrieved.")]
        [string]$IssuerFilter,

        [Parameter(Mandatory = $false, HelpMessage = "The type of certificates to retrieve. Valid values are 'Active', 'Issued', 'Dependencies', and 'Expired'. Defaults to 'Active'.")]
        [ValidateSet("Active", "Issued", "Dependencies", "Expired")]
        [string]$CertificateType = "Active",

        [Parameter(Mandatory = $false, HelpMessage = "The PSCredential to use for remote connections.")]
        [System.Management.Automation.PSCredential]$Credential
    )

    # Define the script block to run on target computer(s).
    $ScriptBlock = {
        param($IssuerFilter, $CertificateType)
        try {
            $CertStore = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to access the certificate store on $env:COMPUTERNAME: $_"
            return @()
        }
        
        $Certificates = @()
        $CurrentDate = Get-Date

        foreach ($Cert in $CertStore) {
            # Apply issuer filter if specified.
            if ($IssuerFilter -and ($Cert.Issuer -notlike "*$IssuerFilter*")) {
                continue
            }

            # Determine whether to include this certificate based on CertificateType.
            $IncludeCert = $true
            
            switch ($CertificateType) {
                "Expired" {
                    if ($Cert.NotAfter -gt $CurrentDate) { $IncludeCert = $false }
                }
                "Active" {
                    if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                }
                "Issued" {
                    # For "Issued", include certificates that are active (and add extra validity details later).
                    if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                }
                "Dependencies" {
                    # Placeholder logic for dependency-related filtering.
                    $IncludeCert = $true
                }
            }

            if (-not $IncludeCert) { continue }

            # Build the certificate object with extended details.
            $CertObject = [PSCustomObject]@{
                ComputerName       = $env:COMPUTERNAME
                Subject            = $Cert.Subject
                Issuer             = $Cert.Issuer
                Thumbprint         = $Cert.Thumbprint
                NotBefore          = $Cert.NotBefore
                NotAfter           = $Cert.NotAfter
                SerialNumber       = $Cert.SerialNumber
                Version            = $Cert.Version
                FriendlyName       = $Cert.FriendlyName
                HasPrivateKey      = $Cert.HasPrivateKey
                SignatureAlgorithm = $Cert.SignatureAlgorithm.FriendlyName
                PublicKeyAlgorithm = $Cert.PublicKey.Oid.FriendlyName
            }

            # For "Issued" type, add extra validity properties.
            if ($CertificateType -eq "Issued") {
                $CertObject | Add-Member -MemberType NoteProperty -Name "ValidFrom" -Value $Cert.NotBefore -Force
                $CertObject | Add-Member -MemberType NoteProperty -Name "ValidTo" -Value $Cert.NotAfter -Force
            }
            $Certificates += $CertObject
        }
        return $Certificates
    }

    $AllResults = @()
    foreach ($Target in $ComputerName) {
        try {
            if ($Target -eq $env:COMPUTERNAME) {
                $Results = & $ScriptBlock -IssuerFilter $IssuerFilter -CertificateType $CertificateType
            }
            else {
                $Results = Invoke-Command -ComputerName $Target -ScriptBlock $ScriptBlock -ArgumentList $IssuerFilter, $CertificateType -Credential $Credential -ErrorAction Stop
            }
            $AllResults += $Results
        }
        catch {
            Write-Warning "Error connecting to $($Target): $_"
        }
    }
    return $AllResults
}

# Example usage:
# $Cred = Get-Credential
# $Certs = Get-PKICertificate -ComputerName "RemoteMachine01", "RemoteMachine02" -IssuerFilter "CN=ExampleIssuer" -CertificateType Issued -Credential $Cred
# $Certs | Format-Table
