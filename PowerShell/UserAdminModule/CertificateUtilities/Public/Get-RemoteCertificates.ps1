function Get-RemoteCertificates {
param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [pscredential]$Credential
    )

    $scriptBlock = {
        # Retrieve all certificates from the Local Machine's Personal store
        $certificates = Get-ChildItem -Path Cert:\LocalMachine\My

        if ($certificates.Count -eq 0) {
            Write-Output "No certificates found in the Local Machine's Personal store."
            return $null
        }

        # Prepare a list of certificate details
        $certDetailsList = $certificates | ForEach-Object {
            $cert = $_
            $eku = $cert.EnhancedKeyUsageList | Where-Object { $_.FriendlyName -eq "Server Authentication" }

            [PSCustomObject]@{
                Subject          = $cert.Subject
                Issuer           = $cert.Issuer
                Thumbprint       = $cert.Thumbprint
                NotBefore        = $cert.NotBefore
                NotAfter         = $cert.NotAfter
                HasServerAuthEKU = ($eku -ne $null)
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

# $certificates = Get-RemoteCertificates -ComputerName $computerName -Credential $credential
# $certificates | Format-Table -AutoSize
