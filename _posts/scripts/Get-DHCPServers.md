---
layout: post
title: Get-DHCPServers.ps1
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
function Get-AuthorizedDHCPServers {
    # The configNC is replicated to all DCs in a forest, similar
    # to the schema, so this function will get all authorized
    # DHCP servers in the forest.
    $adsi = [ADSI]( "LDAP://RootDSE" )
    $configNC = $adsi.configurationNamingContext.Item( 0 )
    $names = @()
    $cn = [ADSI]("LDAP://CN=NetServices,CN=Services," + $configNC )
    foreach ( $object in $cn.children ) {
        if ( $null -ne $object.Properties[ 'dhcpIdentification' ] ) {
            if ( $object.dhcpIdentification -eq 'DHCP Server Object' ) {
                $names += $object.Name
            }
        }
    }
    $names
}

$Servers = Get-AuthorizedDHCPServers


#$ComputerName = "PTHADDS03.FMG.local"
#$ServiceName = "DHCPServer"
#$serviceObj = Get-Service -ComputerName $ComputerName | ?{ $_.ServiceName -eq $serviceName } | Select-Object Name, @{Name="Jeremy";Expression={$._Status}}, Status
#$serviceObj

#http://blogs.technet.com/b/heyscriptingguy/archive/2012/11/12/force-a-domain-wide-update-of-group-policy-with-powershell.aspx


$sessions = New-PSSession -ComputerName $Servers
$Sessions
$serviceObj = Invoke-Command -Session $sessions -ScriptBlock {
    $ServiceName = "DHCPServer"
    Get-Service | Where-Object { $_.ServiceName -eq $serviceName } | Select-Object -Property Name, @{Name = "State"; Expression = { $_.Status } }
}

$serviceObj

Remove-PSSession $sessions
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Get-DHCPServers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DHCPServers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
