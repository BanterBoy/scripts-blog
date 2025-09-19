function Test-TLSConnection {
    <#
    .SYNOPSIS
        Test if a TLS Connection can be established.
    .DESCRIPTION
        This function uses System.Net.Sockets.TcpClient and System.Net.Security.SslStream to connect to a ComputerName and
        authenticate via TLS. This is useful to check if a TLS connection can be established and if the certificate used on
        the remote computer is trusted on the local machine.
        If the connection can be established, the certificate's properties will be output as a custom object.
        Optionally, the certificate can be downloaded using the -SaveCert switch.
        The Protocol parameter can be used to specify which SslProtocol is used to perform the test. The CheckCertRevocationStatus parameter
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
    [OutputType([psobject], [bool])]
    param (
        # Specifies the DNS name of the computer to test
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("cn")]
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
        [ValidateRange(1, 65535)]
        $Port = 443,

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Default', 'Ssl2', 'Ssl3', 'Tls', 'Tls11', 'Tls12')]
        [System.Security.Authentication.SslProtocols[]]
        $Protocol = 'Tls12',
        
        # Specifies a path to a file (.cer) where the certificate should be saved if the SaveCert switch parameter is used
        [Parameter(Position = 3)]
        [System.IO.FileInfo]
        $FilePath = "$ComputerName.cer",

        # Check revocation information for remote certificate. Default is true.
        [Parameter()]
        [bool]$CheckCertRevocationStatus = $true,

        # Saves the remote certificate to a file, the path can be specified using the FilePath parameter
        [switch]
        $SaveCert,

        # Only returns true or false, instead of a custom object with some information.
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
            # Ensure IPAddress is IPv4
            $IPv4Address = [System.Net.Dns]::GetHostAddresses($IPAddress) | Where-Object { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }
            if (-not $IPv4Address) {
                throw "No IPv4 address found for $IPAddress"
            }

            $TCPConnection = New-Object System.Net.Sockets.TcpClient
            $TCPConnection.Connect($IPv4Address[0], $Port)
            Write-Verbose "TCP connection has succeeded"
            $TCPStream = $TCPConnection.GetStream()
            try {
                $SSLStream = New-Object System.Net.Security.SslStream($TCPStream)
                Write-Verbose "Attempting SSL authentication with $Protocol"
                $SSLStream.AuthenticateAsClient($ComputerName, $null, $Protocol, $CheckCertRevocationStatus)
                Write-Verbose "SSL authentication has succeeded with $($SSLStream.SslProtocol)"
                
                $certificate = $SSLStream.RemoteCertificate
                $certificateX509 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificate)
                $SANextensions = $certificateX509.Extensions | Where-Object { $_.Oid.FriendlyName -like "*subject alternative name" }
                
                $Data = [ordered]@{
                    'ComputerName'    = $ComputerName;
                    'Port'            = $Port;
                    'Protocol'        = $SSLStream.SslProtocol;
                    'CheckRevocation' = $CheckCertRevocationStatus;
                    'Issuer'          = $certificateX509.Issuer;
                    'Subject'         = $certificateX509.Subject;
                    'SerialNumber'    = $certificateX509.GetSerialNumberString();
                    'ValidTo'         = $certificateX509.GetExpirationDateString();
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
                    [System.IO.File]::WriteAllBytes($FilePath, $certificateX509.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
                }
            }
            catch {
                Write-Warning "$ComputerName doesn't support SSL connections at TCP port $Port `n$_"
                return $false
            }
            finally {
                $TCPStream.Dispose()
                $TCPConnection.Dispose()
            }
        }
        catch {
            Write-Warning "TCP connection to $ComputerName failed: $_"
            return $false
        }
    }

    end {
        # cleanup
        Write-Verbose "Cleanup sessions"
        if ($SSLStream) {
            $SSLStream.Dispose()
        }
    }
}
