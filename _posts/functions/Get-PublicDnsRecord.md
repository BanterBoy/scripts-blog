---
layout: post
title: Get-PublicDnsRecord.ps1
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
Function Get-PublicDnsRecord {
    <#
    .SYNOPSIS
        Make some DNS query based on Stat DNS.
    .DESCRIPTION
        Use Invoke-WebRequest on Stat DNS to resolve DNS query.
    .EXAMPLE
        Get-PublicDnsRecord -DomaineNAme "ItForDummies.net" -DnsRecordType A,MX
    .EXAMPLE
        Get-PublicDnsRecord -DomaineNAme "www.valbox.fr" -DnsRecordType A,MX
    .PARAMETER DomainName
        Domain name to query.
    .PARAMETER DnsRecordType
        DNS type to query.
    .INPUTS
    .OUTPUTS
    .NOTES
    .LINK
    #>
    Param(
        [Parameter(Mandatory = $true,
            HelpMessage = 'DNS domain name to query.',
            Position = 1)]
        [String]$DomainName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'DNS record type to query.',
            Position = 2)]
        [ValidateSet('A', 'AAAA', 'CERT', 'CNAME', 'DHCIP', 'DLV', 'DNAME', 'DNSKEY', 'DS', 'HINFO', 'HIP', 'IPSECKEY', 'KX', 'LOC', 'MX', 'NAPTR', 'NS', 'NSEC', 'NSEC3', 'NSEC3PARAM', 'OPT', 'PTR', 'RRSIG', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TA', 'TALINK', 'TLSA', 'TXT')]
        [String[]]$DnsRecordType
    )

    DynamicParam {
        $AttribColl = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
        $ParamAttrib = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamAttrib.Mandatory = $false
        $ParamAttrib.ParameterSetName = '__AllParameterSets'
        $ParamAttrib.ValueFromPipeline = $false
        $ParamAttrib.ValueFromPipelineByPropertyName = $false
        $AttribColl.Add($ParamAttrib)
        $AttribColl.Add((New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList ((Invoke-WebRequest -Uri 'http://www.dns-lg.com/nodes.json' | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty nodes | Select-Object -ExpandProperty name))))
        $RuntimeParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('Node', [string], $AttribColl)
        $RuntimeParamDic = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Node', $RuntimeParam)
        $RuntimeParamDic
    }

    Begin {
        $PsBoundParameters.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Key -Value $_.Value -ErrorAction 'SilentlyContinue' }
        if (!$Node) { $Node = Invoke-WebRequest -Uri 'http://www.dns-lg.com/nodes.json' | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty nodes | Select-Object -ExpandProperty name | Get-Random }
    }
    Process {
        ForEach ($Record in $DnsRecordType) {
            Try {
                $WebUrl = 'http://www.dns-lg.com/{0}/{1}/{2}' -f $Node, $DomainName, $Record

                Write-Verbose -Message "Constructed URL for query is $WebUrl."

                $WebData = Invoke-WebRequest -Uri $WebUrl -ErrorAction Stop | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty answer
                $WebData | % {
                    New-Object -TypeName PSObject -Property @{
                        'Name'   = $_.name
                        'Type'   = $_.type
                        'Target' = $_.rdata
                        'Node'   = $Node
                    }
                }
            }
            catch {
                Write-Warning -Message $_
                New-Object -TypeName PSObject -Property @{
                    'Name'   = $DomainName
                    'Type'   = $Record
                    'Target' = ($_[0].ErrorDetails.Message -split '"')[-2]
                    'Node'   = $Node
                }
            }
        }
    }
    End {}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/dns/Get-PublicDnsRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PublicDnsRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
