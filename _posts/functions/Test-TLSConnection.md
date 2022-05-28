---
layout: post
title: Test-TLSConnection.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Test-TLSConnection {
    <#
    .Synopsis
    Test if a TLS Connection can be established.

    .DESCRIPTION
    This function uses System.Net.Sockets.Tcpclient and System.Net.Security.SslStream to connect to a ComputerName and
    authenticate via TLS. This is useful to check if a TLS connection can be established and if the certificate used on
    the remote computer is trusted on the local machine.
    If the connection can be established, the certificate's properties will be output as custom object.
    Optionally the certificate can be downloaded using the -SaveCert switch.
    The Protocol parameter can be used to specifiy which SslProtocol is used to perform the test. The CheckCertRevocationStatus parameter
    can be used to disable revocation checks for the remote certificate.

    .EXAMPLE
    Test-TlsConnection -ComputerName www.ntsystems.it

    This example connects to www.ntsystems.it on port 443 (default) and outputs the certificate's properties.

    .EXAMPLE
    Test-TlsConnection -ComputerName sipdir.online.lync.com -Port 5061 -Protocol Tls12 -SaveCert

    This example connects to sipdir.online.lync.com on port 5061 using TLS 1.2 and saves the certificate to the temp folder.

    .EXAMPLE
    Test-TlsConnection -IPAddress 1.1.1.1 -ComputerName whatever.cloudflare.com

    This example connects to the IP 1.1.1.1 using a Hostname of whatever.cloudflare.com. This can be useful to test hosts that don't have DNS records configured.

    .EXAMPLE
    "host1.example.com","host2.example.com" | Test-TLSConnection -Protocol Tls11 -Quiet

    This example tests connection to the hostnames passed by pipeline input. It uses the -Quiet parameter and therefore only returns true/false.
    #>

    [CmdletBinding(HelpUri = 'https://ntsystems.it/PowerShell/TAK/Test-TLSConnection/')]
    [Alias('ttls')]
    [OutputType([psobject], [bool])]
    param (
        # Specifies the DNS name of the computer to test
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("Server", "Name", "HostName")]
        $ComputerName,

        # Specifies the IP Address of the computer to test. Can be useful if no DNS record exists.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Net.IPAddress]
        $IPAddress,

        # Specifies the TCP port on which the TLS service is running on the computer to test
        [Parameter(Position = 1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("RemotePort")]
        [ValidateRange(1, 65535)]
        $Port = '443',

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Default', 'None', 'Ssl2', 'Ssl3', 'Tls', 'Tls11', 'Tls12', 'Tls13')]
        [System.Security.Authentication.SslProtocols[]]
        $Protocol = 'Tls12',

        # Specifies a path to a file (.cer) where the certificate should be saved if the SaveCert switch parameter is used
        [Parameter(Position = 3)]
        [System.IO.FileInfo]
        $FilePath = "$computername.cer",

        # Check revocation information for remote certificate. Default is true.
        [Parameter()]
        [bool]$CheckCertRevocationStatus = $true,

        # Saves the remote certificate to a file, the path can be specified using the FilePath parameter
        [switch]
        $SaveCert,

        # Only returns true or false, instead of a custom object with some information.
        [Alias("Silent")]
        [switch]
        $Quiet
    )

    begin {
        function Get-SanAsArray {
            param($io)
            $io.replace("DNS Name=", "").split("`n")
        }
    }

    process {
        if (-not($IPAddress)) {
            # if no IP is specified, use the ComputerName
            [string]$IPAddress = $ComputerName
        }

        try {
            $TCPConnection = New-Object System.Net.Sockets.Tcpclient($($IPAddress.ToString()), $Port)
            Write-Verbose "TCP connection has succeeded"
            $TCPStream = $TCPConnection.GetStream()
            try {
                $SSLStream = New-Object System.Net.Security.SslStream($TCPStream)
                Write-Verbose "SSL connection has succeeded with $($SSLStream.SslProtocol)"
                try {
                    # AuthenticateAsClient (string targetHost, X509CertificateCollection clientCertificates, SslProtocols enabledSslProtocols, bool checkCertificateRevocation)
                    $SSLStream.AuthenticateAsClient($ComputerName, $null, $Protocol, $CheckCertRevocationStatus)
                    Write-Verbose "SSL authentication has succeeded"
                }
                catch {
                    Write-Warning "There's a problem with SSL authentication to $ComputerName `n$_"
                    Write-Warning "Tried to connect using $Protocol protocol. Try another protocol with the -Protocol parameter."
                    return $false
                }
                $certificate = $SSLStream.get_remotecertificate()
                $certificateX509 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificate)
                $SANextensions = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection($certificateX509)
                $SANextensions = $SANextensions.Extensions | Where-Object { $_.Oid.FriendlyName -like "*subject alternative name" }

                $data = [ordered]@{
                    'ComputerName'    = $ComputerName;
                    'Port'            = $Port;
                    'Protocol'        = $SSLStream.SslProtocol;
                    'CheckRevocation' = $SSLStream.CheckCertRevocationStatus;
                    'Issuer'          = $SSLStream.RemoteCertificate.Issuer;
                    'Subject'         = $SSLStream.RemoteCertificate.Subject;
                    'SerialNumber'    = $SSLStream.RemoteCertificate.GetSerialNumberString();
                    'ValidTo'         = $SSLStream.RemoteCertificate.GetExpirationDateString();
                    'SAN'             = (Get-SanAsArray -io $SANextensions.Format(1));
                }

                if ($Quiet) {
                    Write-Output $true
                }
                else {
                    Write-Output (New-Object -TypeName PSObject -Property $Data)
                }
                if ($SaveCert) {
                    Write-Host "Saving cert to $FilePath" -ForegroundColor Yellow
                    [system.io.file]::WriteAllBytes($FilePath, $certificateX509.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
                }
            }
            catch {
                Write-Warning "$ComputerName doesn't support SSL connections at TCP port $Port `n$_"
            }
        }
        catch {
            $exception = New-Object System.Net.Sockets.SocketException
            $errorcode = $exception.ErrorCode
            Write-Warning "TCP connection to $ComputerName failed, error code:$errorcode"
            Write-Warning "Error details: $exception"
        }

    } # process

    end {
        # cleanup
        Write-Verbose "Cleanup sessions"
        if ($SSLStream) {
            $SSLStream.Dispose()
        }
        if ($TCPStream) {
            $TCPStream.Dispose()
        }
        if ($TCPConnection) {
            $TCPConnection.Dispose()
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-TLSConnection.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-TLSConnection.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
