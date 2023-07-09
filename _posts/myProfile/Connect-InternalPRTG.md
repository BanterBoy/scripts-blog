---
layout: post
title: Connect-InternalPRTG.ps1
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
function Connect-InternalPRTG {

    <#
        .SYNOPSIS
        Connects to the PRTG Monitoring Server.
        .DESCRIPTION
        Establishes a secure connection to the PRTG Monitoring Servers API, using the functions from the PrtgAPI module.
        .PARAMETER url
        Enter the url for the PRTG Monitoring Server API. This paramter is not mandatory and will default the CSO default PRTG server.
        .NOTES
        Name: Connect-InternalPRTG.ps1
        Author: Luke Leigh
        DateCreated: 02Sep2021

        .LINK
        http://
        .EXAMPLE
        Connect-InternalPRTG
    #>

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the url for the PRTG Monitoring Server."
        )]
        [string]
        $url = "https://csonetmon01.uk.cruk.net"
    )

    if (!(Get-PrtgClient)) {
        Connect-PrtgServer -Server $url -Credential (Get-Credential)
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Connect-InternalPRTG.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-InternalPRTG.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
