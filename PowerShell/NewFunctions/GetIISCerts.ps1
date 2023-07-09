Function Get-IISCertificates {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string[]] $Servers
    )

    $session = New-PsSession -ComputerName $Servers

    $command = {
        Import-Module WebAdministration
        $sites = Get-ChildItem -Path IIS:\Sites
        $certificates = @()
        foreach ($site in $sites) {
            foreach ($binding in $site.Bindings.Collection) {
                if ($binding.protocol -eq 'https') {
                    $search = "Cert:\LocalMachine\My\$($binding.certificateHash)"
                    $certs = Get-ChildItem -Path $search -Recurse
                    if ($certs.count -gt 0) {
                        $certificate = New-Object -TypeName PSObject
                        $certificate | Add-Member -MemberType NoteProperty -Name "SiteName" -Value $site.Name
                        $certificate | Add-Member -MemberType NoteProperty -Name "BindingInformation" -Value $binding.BindingInformation
                        $certificate | Add-Member -MemberType NoteProperty -Name "CertificateSubject" -Value $certs[0].Subject
                        $certificate | Add-Member -MemberType NoteProperty -Name "ExpiryDate" -Value $certs[0].NotAfter
                        $certificate | Add-Member -MemberType NoteProperty -Name "DaysRemaining" -Value (New-TimeSpan -Start (Get-Date) -End $certs[0].NotAfter).Days
                        $certificate | Add-Member -MemberType NoteProperty -Name "CertificateStore" -Value $certs[0].PSParentPath
                        $certificate | Add-Member -MemberType NoteProperty -Name "CertificateHash" -Value $certs[0].Thumbprint
                        $certificate | Add-Member -MemberType NoteProperty -Name "Issuer" -Value $certs[0].Issuer
                        $certificate | Add-Member -MemberType NoteProperty -Name "SignatureAlgorithm" -Value $certs[0].SignatureAlgorithm.FriendlyName
                        $certificate | Add-Member -MemberType NoteProperty -Name "KeyAlgorithm" -Value $certs[0].PublicKey.Key.KeyAlgorithm
                        $certificate | Add-Member -MemberType NoteProperty -Name "KeyLength" -Value $certs[0].PublicKey.Key.Length
                        $certificate | Add-Member -MemberType NoteProperty -Name "Thumbprint" -Value $certs[0].Thumbprint
                        $certificates += $certificate
                    }
                }
            }
        }
        $certificates
    }

    Invoke-Command -Session $session -ScriptBlock $command
}
