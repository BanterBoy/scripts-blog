---
layout: post
title: Resolve-DnsDomain.ps1
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

**_@GitHub Copilot_** -

---

#### Script

```powershell
Enum DnsQueryType {
    A_AAAA = 0
    A = 1
    NS = 2
    MD = 3
    MF = 4
    CNAME = 5
    SOA = 6
    MB = 7
    MG = 8
    MR = 9
    NULL = 10
    WKS = 11
    PTR = 12
    HINFO = 13
    MINFO = 14
    MX = 15
    TXT = 16
    RP = 17
    AFSDB = 18
    X25 = 19
    ISDN = 20
    RT = 21
    NSAP = 22
    NSAPPTR = 23
    SIG = 24
    KEY = 25
    PX = 26
    GPOS = 27
    AAAA = 28
    LOC = 29
    NXT = 30
    EID = 31
    NIMLOC = 32
    SRV = 33
    ATMA = 34
    NAPTR = 35
    KX = 36
    CERT = 37
    A6 = 38
    DNAME = 39
    SINK = 40
    OPT = 41
    APL = 42
    DS = 43
    SSHFP = 44
    IPSECKEY = 45
    RRSIG = 46
    NSEC = 47
    DNSKEY = 48
    DHCID = 49
    NSEC3 = 50
    NSEC3PARAM = 51
    TLSA = 52
    SMIMEA = 53
    Unassigned = 54
    HIP = 55
    NINFO = 56
    RKEY = 57
    TALINK = 58
    CDS = 59
    CDNSKEY = 60
    OPENPGPKEY = 61
    CSYNC = 62
    SPF = 99
    UINFO = 100
    UID = 101
    GID = 102
    UNSPEC = 103
    NID = 104
    L32 = 105
    L64 = 106
    LP = 107
    EUI48 = 108
    EUI64 = 109
    TKEY = 249
    TSIG = 250
    IXFR = 251
    AXFR = 252
    MAILB = 253
    MAILA = 254
    All = 255
    URI = 256
    CAA = 257
    AVC = 258
    DOA = 259
    TA = 32768
    DLV = 32769
}
class TakDns {
    [string]$Name
    [DnsQueryType]$Type
}
class DnsResponse : TakDns {
    [DnsQuestion]$Question
    [int]$TTL
}
class DnsQuestion : TakDns {
}
class DnsResponseA : DnsResponse {
    DnsResponseA ($obj,$Q) {
        $this.IPAddress = $obj.data
        $this.Question = $q[0]
        $this.TTL = $obj.ttl
        $this.Type = $obj.Type
        $this.Name = $obj.Name
    }
    [ipaddress]$IPAddress
    [string]$Name
}
class DnsResponseCName : DnsResponse {
    DnsResponseCName ($obj,$Q) {
        $this.NameHost = $obj.data
        $this.Question = $q[0]
        $this.TTL = $obj.ttl
        $this.Type = $obj.Type
        $this.Name = $obj.Name
    }
    [string]$NameHost
    [string]$Name
}
class DnsResponseMX : DnsResponse {
    DnsResponseMX ($obj,$Q) {
        $DataSplit = $obj.data -split " "
        $this.NameExchange = $DataSplit[1]
        $this.Priority = $DataSplit[0]
        $this.Question = $q[0]
        $this.TTL = $obj.ttl
        $this.Type = $obj.Type
        $this.Name = $obj.Name
    }
    [string]$NameExchange
    [string]$Name
    [int]$Priority
}
class DnsResponseSRV : DnsResponse {
    DnsResponseSRV ($obj,$Q) {
        $DataSplit = $obj.data -split " "
        $this.NameTarget = $DataSplit[3]
        $this.Weight = $DataSplit[1]
        $this.Priority = $DataSplit[0]
        $this.Port = $DataSplit[2]
        $this.Question = $q[0]
        $this.TTL = $obj.ttl
        $this.Type = $obj.Type
        $this.Name = $obj.Name
    }
    [string]$NameTarget
    [string]$Name
    [int]$Priority
    [int]$Weight
    [int]$Port
}
class DnsResponseTXT : DnsResponse {
    DnsResponseTXT ($obj,$Q) {
        $this.Strings = $obj.data.replace('"','')
        $this.Question = $q[0]
        $this.TTL = $obj.ttl
        $this.Type = $obj.Type
        $this.Name = $obj.Name
    }
    [string[]]$Strings
    [string]$Name
}

function Resolve-DnsDomain {
    <#
    .SYNOPSIS
        Resolves DNS queries over https.
    .DESCRIPTIO
        This function uses Invoke-RestMethod to resolve DNS queries over https. It uses the Cloudflare https://1.1.1.1/ service.
    .EXAMPLE
        PS C:\> Resolve-HttpsDns -Name ntsystems.it -Type mx

        The above example queries for the `MX` record of the `ntsystems.it` domain.
    .INPUTS
        [string]

        This function accepts objects with a name property as input.
    .OUTPUTS
        [psobject]

        This function writes custom objects to the pipeline.
    .NOTES
        Author: @torggler
        Module: TAK
    #>
    [CmdletBinding()]
    param(
        # Specify the hostname to query.
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $Name,
        # Specify the query type.
        [DnsQueryType[]]
        $Type = "A_AAAA",
        # Specify which server to connect to.
        [Parameter()]
        [ValidateSet('2606:4700:4700::1111','2606:4700:4700::1001','1.0.0.1','1.1.1.1')]
        [ipaddress]
        $Server = "1.1.1.1"
    )
    begin {
        # Mimic Resolve-DnsName behaviour which queries for A and AAAA if no type is specified.
        if($Type -contains "A_AAAA") {
            $Type = "A","AAAA"
        }
    }
    process {
        foreach($n in $name) {
            foreach($t in $type) {
                # Build uri for request
                $uri = -join("https://",$Server,"/dns-query")
                # Invoke Web Request
                $response = Invoke-RestMethod -Uri $uri -Body @{
                    ct = "application/dns-json"
                    name = $n
                    type = $t
                } -ErrorAction SilentlyContinue
                if($response){
                    foreach ($answer in $response.Answer) {
                        switch($answer.Type) {
                            1  { [DnsResponseA]::new($answer, $response.Question) }
                            2  { [DnsResponseCName]::new($answer, $response.Question) }
                            5  { [DnsResponseCName]::new($answer, $response.Question) }
                            28 { [DnsResponseA]::new($answer, $response.Question) }
                            15 { [DnsResponseMX]::new($answer, $response.Question) }
                            33 { [DnsResponseSRV]::new($answer, $response.Question) }
                            16 { [DnsResponseTXT]::new($answer, $response.Question) }
                        }
                    }
                }
            }
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/dns/Resolve-DnsDomain.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Resolve-DnsDomain.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
