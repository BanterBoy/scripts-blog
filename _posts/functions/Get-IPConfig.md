---
layout: post
title: Get-IPConfig.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
[cmdletbinding()]
param (
    [parameter(ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $ComputerName = $env:ComputerName
)

begin {}
process {
    foreach ($Computer in $ComputerName) {
        if (Test-Connection -ComputerName $Computer -Count 1 -ErrorAction 0) {
            try {
                $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | Where-Object { $_.IPEnabled }
            }
            catch {
                Write-Warning "Error occurred while querying $Computer."
                Continue
            }
            foreach ($Network in $Networks) {
                $IPAddress = $Network.IpAddress[0]
                $SubnetMask = $Network.IPSubnet[0]
                $DefaultGateway = $Network.DefaultIPGateway
                $DNSServers = $Network.DNSServerSearchOrder
                $IsDHCPEnabled = $false
                If ($network.DHCPEnabled) {
                    $IsDHCPEnabled = $true
                }
                $MACAddress = $Network.MACAddress
                $OutputObj = New-Object -Type PSObject
                $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()
                $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
                $OutputObj | Add-Member -MemberType NoteProperty -Name SubnetMask -Value $SubnetMask
                $OutputObj | Add-Member -MemberType NoteProperty -Name Gateway -Value $DefaultGateway
                $OutputObj | Add-Member -MemberType NoteProperty -Name IsDHCPEnabled -Value $IsDHCPEnabled
                $OutputObj | Add-Member -MemberType NoteProperty -Name DNSServers -Value $DNSServers
                $OutputObj | Add-Member -MemberType NoteProperty -Name MACAddress -Value $MACAddress
                $OutputObj
            }
        }
    }
}

end {}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/ip/Get-IPConfig.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-IPConfig.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
