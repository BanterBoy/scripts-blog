---
layout: post
title: Test-EmailAddress.ps1
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
<#
    .SYNOPSIS
    Short function to validate email addresses using an API service at https://mailboxlayer.com
    The API (http://apilayer.net/api/check) validates email addresses based on format and tests
    to see if a valid domain.

    .DESCRIPTION
    Short function to validate email addresses using an API service at https://mailboxlayer.com

    Checks Email Address against API, returns details on email address validation and tests for
    "In Use" email addresses testing or if email address is disposable or if domain is valid

    Mailboxlayer offers a simple REST-based JSON API enabling you to thoroughly check and verify
    email addresses right at the point of entry into your system.

    In addition to checking the syntax, the actual existence of an email address using MX-Records
    and the Simple Mail Transfer Protocol (SMTP), and detecting whether or not the requested
    mailbox is configured to catch all incoming mail traffic, the mailboxlayer API is linked
    to a number of regularly updated databases containing all available email providers, which
    simplifies the separation of disposable (e.g. "mailinator") and free email addresses (e.g.
    "gmail", "yahoo") from individual domains.

    Combined with typo checks, did-you-mean suggestions and a numeric score reflecting the quality
    of each email address, these structures will make it simple to automatically filter "real"
    customers from abusers and increase response and success rates of your email campaigns.

    Signup for a free (or paid) account at https://mailboxlayer.com/product
    Free account rate controlled (250 tests per Month)

    .EXAMPLE
    .\Test-EmailAddress.ps1 -ApiKey YourApiKeyGoesHere -EmailAddress email@hotmail.com
    Checks Email Address against API, returns details on email address validation and tests for
    "In Use" email addresses testing or if email address is disposable or if domain is valid

    .INPUTS
    None

    .OUTPUTS
    Domain           : domain.com
    Did you mean?    : email@hotmail.com
    Free             : False
    Valid Format     : True
    MX Record Exists : True
    Username         : email
    Disposable       : False
    Email is Role    : False
    Catch All        : (Disabled, requires Pro Account)
    Score            : 0.48
    SMTP Exists      : True
    Email            : email@domain.com

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
        HelpMessage = "Please enter your API Access Key here (registration is required to be issued an AccessKey)",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('key', 'AK')]
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('em', 'Mail')]
    [string[]]$EmailAddress

)

BEGIN {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SiteURL = "http://apilayer.net/api/check"
    $AccessKey = ("?access_key=" + "$ApiKey")
    $Address = ("&email=" + "$EmailAddress")
    $smtp = "&smtp=1"
    $format = "&format=1"
    # $catchall = "&catch_all=1" (Disabled, requires Pro Account)
    $ValidationResults = Invoke-RestMethod -Method Get -Uri ($SiteURL + $AccessKey + $Address + $smtp + $format + $catchall)
}

PROCESS {

    foreach ($Result in $ValidationResults) {
        $Validation = $Result | Select-Object -Property *

        try {
            $properties = @{
                Email              = $Validation.email
                "Did you mean?"    = $Validation.did_you_mean
                Username           = $Validation.user
                Domain             = $Validation.domain
                "Valid Format"     = $Validation.format_valid
                "MX Record Exists" = $Validation.mx_found
                "SMTP Exists"      = $Validation.smtp_check
                "Catch All"        = "(Disabled, requires Pro Account)" # $Validation.catch_all
                "Email is Role"    = $Validation.role
                Disposable         = $Validation.disposable
                Free               = $Validation.free
                Score              = $Validation.score
            }
        }
        catch {
            $properties = @{
                Email              = $Validation.email
                "Did you mean?"    = $Validation.did_you_mean
                Username           = $Validation.user
                Domain             = $Validation.domain
                "Valid Format"     = $Validation.format_valid
                "MX Record Exists" = $Validation.mx_found
                "SMTP Exists"      = $Validation.smtp_check
                "Catch All"        = "(Disabled, requires Pro Account)" # $Validation.catch_all
                "Email is Role"    = $Validation.role
                Disposable         = $Validation.disposable
                Free               = $Validation.free
                Score              = $Validation.score
            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

}

END {}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-EmailAddress.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-EmailAddress.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
