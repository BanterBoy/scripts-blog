---
layout: post
title: Test-DNSPropagation.ps1
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
function Test-DNSPropagation {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter DNS record to be tested)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $Records,

        [Parameter(Mandatory = $True,
            HelpMessage = "Please select DNS record type)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('A', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT')]
        [string[]]
        $Type
    )

    begin {

    }

    process {

        foreach ($Record in $Records) {
            Try {
                Write-Warning -Message "Testing Google Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 8.8.8.8
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 8.8.4.4

                Write-Warning -Message "Testing Quad9 Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 9.9.9.9
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 149.112.112.112

                Write-Warning -Message "Testing OpenDNS Home Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 208.67.222.222
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 208.67.220.220

                Write-Warning -Message "Testing Cloudflare Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 1.1.1.1
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 1.0.0.1

                Write-Warning -Message "Testing CleanBrowsing Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 185.228.168.9
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 185.228.169.9

                Write-Warning -Message "Testing Verisign Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 64.6.64.6
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 64.6.65.6

                Write-Warning -Message "Testing Alternate DNS Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 198.101.242.72
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 23.253.163.53

                Write-Warning -Message "Testing AdGuardDNS Public DNS"
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 176.103.130.130
                Resolve-DnsName -Name $Record -Type $Type -ErrorAction Stop -Server 176.103.130.131
            }
            Catch [System.Exception] {
                Write-Verbose "$Record not found!" -Verbose
            }
            Catch {
                Write-Verbose "Catch all" -Verbose
            }
        }

    }

    end {

    }
}

# Test-DNSPropagation -Records "mail.example.co.uk", "mail2.example.co.uk", "mail3.example.co.uk" -Type A
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/dns/Test-DNSPropagation.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-DNSPropagation.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
