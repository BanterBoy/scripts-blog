---
layout: post
title: Connect-O365Exchange.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@BanterBoy:_** - Explain what the script does and how it works.

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Connect-O365Exchange`. This function is used to connect to Office 365 Exchange Online using Modern Authentication. The function takes one parameter, `UserName`, which is a string that represents the username of the user with permissions to Office 365. If the `UserName` parameter is left blank, the function will try to use the default account for the PowerShell session, using the `$env:USERNAME` environment variable.

The function is well-documented with a detailed description, examples, and notes. The `SYNOPSIS` section provides a brief summary of what the function does, while the `DESCRIPTION` section provides a more detailed explanation. The `EXAMPLE` section provides examples of how to use the function, including using the `ex365` alias. The `NOTES` section provides information about the author, website, LinkedIn, GitHub, and GitHubGist.

The function uses the `CmdletBinding` attribute to specify the default parameter set, confirm impact, support for should process, and help URI. The `OutputType` attribute specifies the output type of the function, which is a string. The `Alias` attribute specifies the `ex365` alias for the function.

The function imports the `ExchangeOnlineManagement` module and connects to Exchange Online using the `Connect-ExchangeOnline` cmdlet. The `Get-ADUser` cmdlet is used to get the user principal name of the user with the specified username. The `ShouldProcess` method is used to confirm the action before executing it.

To improve the code's readability, the author could consider adding comments to explain the purpose of each section of the code. Additionally, the author could consider using more descriptive variable names and breaking up long lines of code into multiple lines. To improve the code's performance, the author could consider using the `-Credential` parameter of the `Connect-ExchangeOnline` cmdlet instead of using the `Get-ADUser` cmdlet to get the user principal name.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - To use the `Connect-O365Exchange` function to connect to a specific Office 365 account, you need to provide the `UserName` parameter with the username of the account you want to connect to. For example, if the username of the account you want to connect to is "user@example.com", you can use the following command:

```
Connect-O365Exchange -UserName "user@example.com"
```

This will connect to the specified Office 365 account using Modern Authentication. If the `UserName` parameter is left blank, the function will try to use the default account for the PowerShell session, using the `$env:USERNAME` environment variable.

#### Script

```powershell
Function Connect-O365Exchange {

    <#

    .SYNOPSIS
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication.

	.DESCRIPTION
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication. This function will import the ExchangeOnlineManagement module and connect to Exchange Online using the credentials of the user named in UserName. If UserName is left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.

	.PARAMETER UserName
    [string]UserName - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.

	.EXAMPLE
    Connect-O365Exchange -UserName "lukeleigh.admin"

    Connects using the account named in UserName

	.EXAMPLE
    Connect-O365Exchange

    Connects using the environment variable $Env:USERNAME

	.EXAMPLE
    ex365 -UserName "lukeleigh"

    Using the command alias, this command connects using the account named in UserName

	.OUTPUTS
    No output returned.

	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
    You can pipe objects to these perameters.

    - UserName [string] - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.

	.LINK
    https://scripts.lukeleigh.com
    Import-Module
    Connect-ExchangeOnline

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ex365')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to Office 365 e.g. "lukeleigh.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [Alias('user')]
        [string]$UserName = $env:USERNAME
    )

    begin {

    }

    process {
        if ($PSCmdlet.ShouldProcess($UserName, "Connecting to Exchange Online as")) {

            Import-Module ExchangeOnlineManagement
            Connect-ExchangeOnline -UserPrincipalName (Get-ADUser -Identity $UserName).UserPrincipalName -ShowBanner:$false

        }
    }

    end {

    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Connect-O365Exchange.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-O365Exchange.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
