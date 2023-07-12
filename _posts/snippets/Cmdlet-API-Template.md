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

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script appears to be a template for a cmdlet that performs some kind of email validation. The script defines a cmdlet with a number of parameters, including `$ApiKey`, `$EmailAddress`, and `$somethingelse`. The `ValueFromPipelineByPropertyName` attribute on the `$somethingelse` parameter indicates that the cmdlet can accept input from the pipeline based on the property name. The `Alias` attribute provides an alternative name for the parameter.

The `BEGIN` block is commented out, but it appears to set the security protocol and define some variables related to an API endpoint for email validation. The `PROCESS` block contains a loop that iterates over each item in the `$####s` array. The `$####` variable is assigned the value of the current item, and a try-catch-finally block is used to define a `$properties` hash table. The `New-Object` cmdlet is used to create a new PSObject with the properties defined in the `$properties` hash table, and the object is written to the output stream with `Write-Output`.

The `END` block is empty, so it doesn't do anything.

Without more context, it's difficult to say exactly what this cmdlet is supposed to do or how it fits into a larger script or module. However, it appears to be a basic template for a cmdlet that performs some kind of email validation and outputs a PSObject with properties based on the input.

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
