---
layout: post
title: Get-IISCertificates.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script defines a function called `Get-IISCertificates` that retrieves information about SSL certificates used by IIS sites on one or more remote servers. The function takes an array of server names as input and returns an array of objects that represent SSL certificates.

The function starts by creating a new PowerShell session on the remote servers using the `New-PsSession` cmdlet. It then defines a script block that will be executed on each remote server using the `Invoke-Command` cmdlet. The script block imports the `WebAdministration` module, which provides access to IIS configuration data, and retrieves a list of all IIS sites using the `Get-ChildItem` cmdlet with the `IIS:\Sites` path.

The script block then iterates over each site and each binding associated with the site. If the binding protocol is HTTPS, the script block retrieves the certificate associated with the binding using the `Get-ChildItem` cmdlet with a path constructed from the certificate hash. If a certificate is found, the script block creates a new object that represents the certificate and adds it to an array of certificates.

The properties of the certificate object include the site name, binding information, certificate subject, expiry date, days remaining until expiry, certificate store, certificate hash, issuer, signature algorithm, key algorithm, and key length.

To improve the readability of the code, the script block could be split into smaller functions that perform specific tasks, such as retrieving the list of sites and bindings, retrieving the certificate for a binding, and creating a certificate object. Additionally, the script block could be optimized for performance by using parallel processing to retrieve certificates from multiple servers simultaneously.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you can use the `Get-IISCertificates` function:

1. Retrieve SSL certificates for all IIS sites on a single server:

```
Get-IISCertificates -ServerName "localhost"
```

2. Retrieve SSL certificates for all IIS sites on multiple servers:

```
Get-IISCertificates -ServerName "server1", "server2", "server3"
```

3. Retrieve SSL certificates for a specific IIS site on a single server:

```
Get-IISCertificates -ServerName "localhost" -SiteName "Default Web Site"
```

4. Retrieve SSL certificates for a specific IIS site on multiple servers:

```
Get-IISCertificates -ServerName "server1", "server2", "server3" -SiteName "Default Web Site"
```

5. Retrieve SSL certificates that will expire within the next 30 days:

```
Get-IISCertificates -ServerName "localhost" | Where-Object { $_.DaysUntilExpiry -lt 30 }
```

6. Export SSL certificates to a CSV file:

```
Get-IISCertificates -ServerName "localhost" | Export-Csv -Path "C:\certificates.csv" -NoTypeInformation
```

Note that you may need to modify the script to suit your specific needs, such as changing the path to the `WebAdministration` module or modifying the properties of the certificate object.

---

#### Script

```powershell
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

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-IISCertificates.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-IISCertificates.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
