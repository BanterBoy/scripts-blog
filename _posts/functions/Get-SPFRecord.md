---
layout: post
title: Get-SPFRecord.ps1
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
function Get-SPFRecord {
    <#
    .Synopsis
    Get SPF Record for a domain.
    .DESCRIPTION
    This function uses Resolve-DNSName to get the SPF Record for a given domain. Objects with a DomainName property,
    such as returned by Get-AcceptedDomain, can be piped to this function.
    .EXAMPLE
    Get-AcceptedDomain | Get-SPFRecord

    This example gets SPF records for all domains returned by Get-AcceptedDomain.
    #>
    [CmdletBinding(HelpUri = 'https://ntsystems.it/PowerShell/TAK/Get-SPFRecord/')]
    param (
        # Specify the Domain name for the query.
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [string]
        $DomainName,

        # Specify the Domain name for the query.
        [string]
        $Server
    )
    process {
        $params = @{
            Type        = "txt"
            Name        = $DomainName
            ErrorAction = "Stop"
        }
        if ($Server) { $params.Add("Server", $Server) }
        try {
            $dns = Resolve-DnsName @params | Where-Object Strings -Match "spf1"
            $dns | Select-Object @{Name = "DomainName"; Expression = { $_.Name } }, @{Name = "Record"; Expression = { $_.Strings } }
        }
        catch {
            Write-Warning $_
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/dns/Get-SPFRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-SPFRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
