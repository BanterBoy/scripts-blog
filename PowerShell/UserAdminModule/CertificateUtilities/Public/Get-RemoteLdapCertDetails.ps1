function Get-RemoteLdapCertDetails {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [pscredential]$Credential
    )

    $scriptBlock = {
        # Get all certificates from the LocalMachine\My store
        $certs = Get-ChildItem -Path Cert:\LocalMachine\My

        $certDetailsList = @()

        foreach ($cert in $certs) {
            # Check if the certificate has the Server Authentication EKU
            $eku = $cert.EnhancedKeyUsageList | Where-Object { $_.FriendlyName -eq "Server Authentication" }

            if ($eku) {
                $certDetails = [PSCustomObject]@{
                    Subject         = $cert.Subject
                    Issuer          = $cert.Issuer
                    Thumbprint      = $cert.Thumbprint
                    NotBefore       = $cert.NotBefore
                    NotAfter        = $cert.NotAfter
                    HasServerAuthEKU = $true
                }
                $certDetailsList += $certDetails
            }
        }

        return $certDetailsList
    }

    $certDetailsList = Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -Credential $Credential
    return $certDetailsList
}

# Example usage
# $computerName = "RemoteServerFQDN"
# $credential = Get-Credential
# $certDetailsList = Get-RemoteLdapCertDetails -ComputerName $computerName -Credential $credential

# Display the retrieved certificate details
# $certDetailsList | Format-List
