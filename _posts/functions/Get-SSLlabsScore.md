---
layout: post
title: Get-SSLlabsScore.ps1
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
function Get-SslLabsScore {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [String[]]$UrlList
    )

    Begin {
        [int]$i = 0
    }
    Process {
        Foreach ($Url in $UrlList) {
            try {
                $i++
                Write-Progress -Activity "Checking URI" -Status "$Url - $i/$(@($UrlList).count) $($i/$(@($UrlList).count)*100 -as [int])%" -PercentComplete ($i / $(@($UrlList).count) * 100 -as [int])

                #API Doc https://github.com/ssllabs/ssllabs-scan/blob/master/ssllabs-api-docs-v3.md
                $API = "https://api.ssllabs.com/api/v2/analyze?host=$url&all=on&maxAge=24&"

                do {
                    $JsonData = Invoke-WebRequest -Uri $API -ErrorAction SilentlyContinue | ConvertFrom-Json
                    Write-Verbose -Message "$($Url): Status is $($JsonData.status), sleeping for 20 seconds"
                    Start-Sleep -seconds 20
                }
                while ((-Not($JsonData.status -eq "Ready") ))

                New-Object -TypeName PSObject -Property @{
                    Host            = $JsonData.Host
                    IPAddress       = $JsonData.endpoints.ipAddress
                    Grade           = $JsonData.endpoints.grade
                    StatusMessage   = $JsonData.endpoints.statusMessage
                    DurationSeconds = $JsonData.endpoints.duration / 1000 -as [int]

                    #Key
                    KeyStrength     = $JsonData.endpoints.details.key.size

                    #Cert
                    CommonName      = $JsonData.endpoints.details.cert | Select-Object -ExpandProperty commonNames
                    SAN             = ($JsonData.endpoints.details.cert | Select-Object -ExpandProperty altNames) -join ','
                    Issuer          = $JsonData.endpoints.details.cert.issuerLabel
                    notBefore       = ([DateTime]'1/1/1970').AddMilliseconds($JsonData.endpoints.details.cert.notBefore)
                    notAfter        = ([DateTime]'1/1/1970').AddMilliseconds($JsonData.endpoints.details.cert.notAfter)
                    sigAlg          = $JsonData.endpoints.details.cert.sigAlg
                }
            }
            catch {
                Write-Warning -Message "$Url failed: $_ !"
            }
        }
    }
    End {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-SSLlabsScore.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-SSLlabsScore.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
