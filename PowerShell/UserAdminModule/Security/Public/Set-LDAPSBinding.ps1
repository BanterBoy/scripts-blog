function Set-LDAPSBinding {
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

        Write-Verbose "Searching for certificate with thumbprint $CertThumbprint on $DomainControllerFQDN"
        
        $cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {
            $_.Thumbprint -eq $CertThumbprint
        }

        if ($null -ne $cert) {
            Write-Verbose "Certificate found. Binding certificate with thumbprint $CertThumbprint to LDAP service on $DomainControllerFQDN"

            # Bind the certificate to the NTDS service
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPSAuthentication" -Value 1 -PropertyType DWORD -Force | Out-Null
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPS" -Value 1 -PropertyType DWORD -Force | Out-Null

            # Bind the certificate to the LDAP service
            $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("NTDS", "LocalMachine")
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            $store.Add($cert)
            $store.Close()

            Write-Verbose "Certificate with thumbprint $CertThumbprint successfully bound to LDAP service on $DomainControllerFQDN"
        } else {
            Write-Warning "No valid certificate found with thumbprint $CertThumbprint for LDAPS on $DomainControllerFQDN"
        }
    }

    Invoke-Command -ComputerName $DomainControllerFQDN -ScriptBlock $scriptBlock -ArgumentList $DomainControllerFQDN, $CertThumbprint -Credential $Credential -Verbose
}

# Example usage of the function:
# Set-LDAPSBinding -DomainControllerFQDN "RDGDC01.rdg.co.uk" -CertThumbprint "9f580f463113ea7615847821ad3775d690c640d2" -Credential (Get-Credential) -Verbose
