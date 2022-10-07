---
layout: post
title: Test-Computer.ps1
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
<#
.Synopsis
Check connectivity of a system

.DESCRIPTION
This function pings and opens a connection to the default RDP port to verify connectivity, futhermore it will check if a DNS entry exists and whether there is a computeraccount

.NOTES
Name: Test-Computer
Author: Jaap Brasser
Version: 1.0
DateUpdated: 2013-08-23

.LINK
http://www.jaapbrasser.com

.PARAMETER ComputerName
The computer to which connectivity will be checked

.EXAMPLE
Test-ComputerName

Description:
Will perform the ping, RDP, DNS and AD checks for the local machine

.EXAMPLE
Test-ComputerName -ComputerName server01,server02

Description:
Will perform the ping, RDP, DNS and AD checks for server01 and server02
#>
Function Test-Computer {
    param (
        [CmdletBinding()]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
    begin {
        $SelectHash = @{
         'Property' = @('Name','ADObject','DNSEntry','PingResponse','RDPConnection')
        }
    }
    process {
        foreach ($CurrentComputer in $ComputerName) {
            # Create new Hash
            $HashProps = @{
                'Name' = $CurrentComputer
                'ADObject' = $false
                'DNSEntry' = $false
                'RDPConnection' = $false
                'PingResponse' = $false
            }
            # Perform Checks
            switch ($true)
            {
                {([adsisearcher]"samaccountname=$CurrentComputer`$").findone()} {$HashProps.ADObject = $true}
                {$(try {[system.net.dns]::gethostentry($CurrentComputer)} catch {})} {$HashProps.DNSEntry = $true}
                {$(try {$socket = New-Object Net.Sockets.TcpClient($CurrentComputer, 3389);if ($socket.Connected) {$true};$socket.Close()} catch {})} {$HashProps.RDPConnection = $true}
                {Test-Connection -ComputerName $CurrentComputer -Quiet -Count 1} {$HashProps.PingResponse = $true}
                Default {}
            }
            # Output object
            New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
        }
    }
    end {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/powershell/functions/myProfile/Test-Computer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-Computer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
