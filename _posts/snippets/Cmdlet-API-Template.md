---
layout: post
title: Cmdlet-API-Template.ps1
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
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .INPUTS

    .OUTPUTS

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        HelpMessage = "####",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('####')]
    [string[]]$something,

    [Parameter(Mandatory = $True,
        HelpMessage = "####",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('####')]
    [string[]]$somethingelse

)

BEGIN {
    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # $SiteURL = "http://apilayer.net/api/check"
    # $AccessKey = ("?access_key=" + "$ApiKey")
    # $Address = ("&email=" + "$EmailAddress")
    # $smtp = "&smtp=1"
    # $format = "&format=1"
    # # $catchall = "&catch_all=1" (Disabled, requires Pro Account)
    # $ValidationResults = Invoke-RestMethod -Method Get -Uri ($SiteURL + $AccessKey + $Address + $smtp + $format + $catchall)
}

PROCESS {

    foreach ($item in $####s) {
        $#### = $item | Select-Object -Property *

        try {
            $properties = @{

            }
        }
        catch {
            $properties = @{

            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

}

END {

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Cmdlet-API-Template.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Cmdlet-API-Template.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/snippets.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Snippets
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
