---
layout: post
title: Test-SSLProtocols.ps1
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
function Test-SSLProtocols {

   	<#
    .SYNOPSIS
		A brief description of the Test-SSLProtocols function. Tests and oututs the website SSL protocols that the client is able to successfully use to connect to a server.

	.DESCRIPTION
		A detailed description of the Test-SSLProtocols function. Tests and oututs the website SSL protocols that the client is able to successfully use to connect to a server.

	.PARAMETER WebAddress
		A description of the WebAddress parameter.

	.PARAMETER Ports
		A description of the Ports parameter.

	.EXAMPLE
		PS C:\> Test-SSLProtocols -WebAddress "www.google.com"
        This will test all computers in the AD search scope to see if port 80, 443, 445, 3389, and 5985 are open.

	.OUTPUTS
		System.String, Default

	.NOTES
		Additional information about the function.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the URL for the web site you wish to check or pipe input to the command.')]
        [Alias('cn')]
        $WebAddress,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the website Port Number you wish to check or pipe input to the command.')]
        [Alias('p')]
        [int]$Port = 443
    )
    BEGIN {
        $ProtocolNames = [System.Security.Authentication.SslProtocols] | Get-Member -Static -MemberType Property | Where-Object { $_.Name -notin @("Default", "None") } | ForEach-Object { $_.Name }
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$($WebAddress)", "Testing SSL Protocols")) {
            foreach ($Address in $WebAddress) {
                $ProtocolStatus = [Ordered]@{}
                $ProtocolStatus.Add("WebAddress", $Address)
                $ProtocolStatus.Add("Port", $Port)
                $ProtocolStatus.Add("KeyLength", $null)
                $ProtocolStatus.Add("SignatureAlgorithm", $null)

                $ProtocolNames | ForEach-Object {
                    $ProtocolName = $_
                    $Socket = New-Object System.Net.Sockets.Socket([System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
                    $Socket.Connect($Address, $Port)
                    try {
                        $NetStream = New-Object System.Net.Sockets.NetworkStream($Socket, $true)
                        $SslStream = New-Object System.Net.Security.SslStream($NetStream, $true)
                        $SslStream.AuthenticateAsClient($Address, $null, $ProtocolName, $false )
                        $RemoteCertificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]$SslStream.RemoteCertificate
                        $ProtocolStatus["KeyLength"] = $RemoteCertificate.PublicKey.Key.KeySize
                        $ProtocolStatus["SignatureAlgorithm"] = $RemoteCertificate.SignatureAlgorithm.FriendlyName
                        $ProtocolStatus["Certificate"] = $RemoteCertificate
                        $ProtocolStatus.Add($ProtocolName, $true)
                    }
                    catch {
                        $ProtocolStatus.Add($ProtocolName, $false)
                    }
                    finally {
                        $SslStream.Close()
                    }
                }
                [PSCustomObject]$ProtocolStatus
            }
        }
    }
    END {

    }
}
# Test-SSLProtocols -WebAddress "blog.lukeleigh.com" -Port 443
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/powershell/functions/myProfile/Test-SSLProtocols.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-SSLProtocols.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
