---
layout: post
title: Get-ServerIPInfo.ps1
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
function Get-ServerIPInfo {
    $ServerList = (Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"').Name
    $test = Test-Connection -ComputerName $ServerList -Count 1 -ErrorAction SilentlyContinue
    $Available = $test | Select-Object -ExpandProperty Address
    $result = @()

    foreach ($Server in $Available) {
        $Invoke = Invoke-Command -ComputerName $Server -ScriptBlock {
            Get-NetIPConfiguration | Select-Object -Property InterfaceAlias, Ipv4Address, DNSServer
            Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -ExpandProperty NextHop
        }
        $result += New-Object -TypeName PSCustomObject -Property ([ordered]@{
                'Server'      = $Server
                'Interface'   = $Invoke.InterfaceAlias -join ','
                'IPv4Address' = $Invoke.Ipv4Address.IPAddress -join ','
                'Gateway'     = $Invoke | Select-Object -Last 1
                'DNSServer'   = ($Invoke.DNSServer | Select-Object -ExpandProperty ServerAddresses) -join ','
            })
    }
    $result
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('https://scripts.lukeleigh.com/powershell/functions/myProfile/Get-ServerIPInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ServerIPInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
