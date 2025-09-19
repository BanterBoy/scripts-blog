<#
.SYNOPSIS
    Retrieves PKI certificates from one or more specified computers and/or user certificate stores.

.DESCRIPTION
    This function retrieves PKI certificates from certificate stores on one or more specified computers.
    You can choose to retrieve certificates from the LocalMachine certificate store, the CurrentUser certificate store, or both.
    Optionally, you can filter the certificates by issuer or by certificate status/type (Active, Issued, Dependencies, or Expired).
    The output includes extended certificate details for enhanced PKI analysis.

.PARAMETER ComputerName
    The names of the computers from which to retrieve certificates.
    Defaults to the local computer if not specified.

.PARAMETER StoreLocation
    The certificate store location to search.
    Valid values are 'LocalMachine', 'CurrentUser', or 'Both'. Defaults to 'LocalMachine'.

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
    # Retrieve all active computer certificates from the local computer
    Get-AllPKICertificates -CertificateType Active -StoreLocation LocalMachine | Format-Table

.EXAMPLE
    # Retrieve all issued certificates (both computer and user) from a remote computer
    Get-AllPKICertificates -ComputerName "RemoteMachine01" -StoreLocation Both -CertificateType Issued | Format-Table

.EXAMPLE
    # Retrieve certificates filtered by issuer from multiple computers, but only from the current user's store
    $Certs = Get-AllPKICertificates -ComputerName "RemoteMachine01", "RemoteMachine02" -StoreLocation CurrentUser -IssuerFilter "CN=ExampleIssuer"
    $Certs | Format-Table

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Get-AllPKICertificates {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "The names of the computers from which to retrieve certificates. Defaults to the local computer.")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, HelpMessage = "The certificate store location to search. Valid values: 'LocalMachine', 'CurrentUser', 'Both'. Defaults to 'LocalMachine'.")]
        [ValidateSet("LocalMachine", "CurrentUser", "Both")]
        [string]$StoreLocation = "LocalMachine",

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
        param($IssuerFilter, $CertificateType, $StoreLocation)

        # Determine which certificate store paths to query based on StoreLocation.
        switch ($StoreLocation) {
            "LocalMachine" { $StorePaths = "Cert:\LocalMachine\My" }
            "CurrentUser" { $StorePaths = "Cert:\CurrentUser\My" }
            "Both" { $StorePaths = @("Cert:\LocalMachine\My", "Cert:\CurrentUser\My") }
        }

        try {
            # If $StorePaths is an array, combine results from each store.
            $Certificates = @()
            $CurrentDate = Get-Date

            foreach ($Store in $StorePaths) {
                try {
                    $CertStore = Get-ChildItem -Path $Store -ErrorAction Stop
                }
                catch {
                    Write-Warning "Failed to access store $Store on $env:COMPUTERNAME: $_"
                    continue
                }

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
                            if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                        }
                        "Dependencies" {
                            # Placeholder for dependency logic.
                            $IncludeCert = $true
                        }
                    }

                    if (-not $IncludeCert) { continue }

                    # Build the certificate object with extended details.
                    $CertObject = [PSCustomObject]@{
                        ComputerName       = $env:COMPUTERNAME
                        StoreLocation      = $Store
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

                    if ($CertificateType -eq "Issued") {
                        # Add extra validity properties for "Issued" certificates.
                        $CertObject | Add-Member -MemberType NoteProperty -Name "ValidFrom" -Value $Cert.NotBefore -Force
                        $CertObject | Add-Member -MemberType NoteProperty -Name "ValidTo" -Value $Cert.NotAfter -Force
                    }
                    $Certificates += $CertObject
                }
            }
            return $Certificates
        }
        catch {
            Write-Error "Failed to retrieve certificates on $env:COMPUTERNAME: $_"
            return @()
        }
    }

    $AllResults = @()
    foreach ($Target in $ComputerName) {
        try {
            if ($Target -eq $env:COMPUTERNAME) {
                $Results = & $ScriptBlock -IssuerFilter $IssuerFilter -CertificateType $CertificateType -StoreLocation $StoreLocation
            }
            else {
                $Results = Invoke-Command -ComputerName $Target -ScriptBlock $ScriptBlock -ArgumentList $IssuerFilter, $CertificateType, $StoreLocation -Credential $Credential -ErrorAction Stop
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
# $Certs = Get-AllPKICertificates -ComputerName "RemoteMachine01", "RemoteMachine02" -StoreLocation Both -IssuerFilter "CN=ExampleIssuer" -CertificateType Issued -Credential $Cred
# $Certs | Format-Table
