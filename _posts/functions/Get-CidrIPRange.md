---
layout: post
title: Get-CidrIPRange.ps1
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
<#

    .SYNOPSIS
    Short function to display the details for a CIDR range

    .DESCRIPTION
    This function was created to output the details of a CIDR range using the API from hackertarget.com

    .EXAMPLE
    Get-CidrIPRange -cidrAddress 192.168.1.1 -prefix 24

    Address       = 192.168.1.1
    Network       = 192.168.1.0 / 24
    Netmask       = 255.255.255.0
    Broadcast     = 192.168.1.255
    Wildcard Mask = 0.0.0.255
    Hosts Bits    = 8
    Max. Hosts    = 254   (2^8 - 2)
    Host Range    = { 192.168.1.1 - 192.168.1.254 }

    .INPUTS
    cidrAddress [string]
    prefix [int]

    .OUTPUTS
    Output is simple and of content type text

    .NOTES
    Author:     Luke Leigh
    Website:    https://admintoolkit.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/adminToolkit/wiki

#>

[cmdletbinding(DefaultParameterSetName = 'default')]
param([Parameter(Mandatory = $True,
        HelpMessage = "Please enter a network address e.g. 10.0.0.0",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('CIDR')]
    [string]$cidrAddress,
    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter a prefix e.g. 29",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('pre')]
    [int]$prefix
)

begin {

}

process {
    $cidrRange = $cidrAddress + '/' + $prefix
    Invoke-RestMethod -Method Default -Uri "https://api.hackertarget.com/subnetcalc/?q=$CidrRange"
}

end {

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/ip/Get-CidrIPRange.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-CidrIPRange.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
