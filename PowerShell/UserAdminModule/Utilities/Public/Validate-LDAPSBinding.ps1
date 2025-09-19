function Validate-LDAPSBinding {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DomainControllerFQDN,
        
        [Parameter(Mandatory=$true)]
        [string]$CertThumbprint,
        
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential
    )

    $scriptBlock = {
        param (
            [string]$DomainControllerFQDN,
            [string]$CertThumbprint
        )

        $result = [PSCustomObject]@{
            DomainControllerFQDN = $DomainControllerFQDN
            CertThumbprint       = $CertThumbprint
            LDAPSEnabled         = $false
            CertificateBound     = $false
            Message              = ""
        }

        Write-Verbose "Validating LDAPS settings on $DomainControllerFQDN"

        # Check registry settings
        $ldapsAuthentication = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPSAuthentication" -ErrorAction SilentlyContinue
        $ldaps = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPS" -ErrorAction SilentlyContinue

        if ($ldapsAuthentication -and $ldaps) {
            if ($ldapsAuthentication.ClientLDAPSAuthentication -eq 1 -and $ldaps.ClientLDAPS -eq 1) {
                $result.LDAPSEnabled = $true
            }
        }

        # Check if the certificate is bound
        $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("NTDS", "LocalMachine")
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
        $cert = $store.Certificates | Where-Object {
            $_.Thumbprint -eq $CertThumbprint
        }
        if ($cert) {
            $result.CertificateBound = $true
            $result.Message = "LDAPS is correctly configured on $DomainControllerFQDN with certificate $CertThumbprint"
        } else {
            $result.Message = "LDAPS is not correctly configured on $DomainControllerFQDN. Certificate $CertThumbprint is not bound."
        }
        $store.Close()

        return $result
    }

    $validationResult = Invoke-Command -ComputerName $DomainControllerFQDN -ScriptBlock $scriptBlock -ArgumentList $DomainControllerFQDN, $CertThumbprint -Credential $Credential -Verbose
    return $validationResult
}

# Example usage of the function:
# $validationResult = Validate-LDAPSBinding -DomainControllerFQDN "RDGDC01.rdg.co.uk" -CertThumbprint "9f580f463113ea7615847821ad3775d690c640d2" -Credential (Get-Credential) -Verbose
# $validationResult | Format-List
