---
layout: post
title: Sync-DomainController.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Sync-DomainController`. This function synchronizes all domain controllers in the specified domain by forcing replication using the `repadmin` tool. The function takes one parameter, `Domain`, which specifies the name of the domain to synchronize. If no domain is specified, the function defaults to the user's domain.

The function begins with a comment-based help section that provides a synopsis, description, parameter information, example usage, and other notes about the function. This information is useful for anyone who wants to use the function or understand what it does.

The function uses the `Get-ADDomain` cmdlet to retrieve the distinguished name of the specified domain. It then uses the `Get-ADDomainController` cmdlet to retrieve the names of all domain controllers in the specified domain. For each domain controller, the function uses the `repadmin` tool to force synchronization with all other domain controllers in the domain.

Overall, this script is a useful tool for synchronizing domain controllers in a Windows Active Directory environment. To improve the code's readability, the author could consider adding comments to explain each step of the process. Additionally, the author could consider adding error handling to handle cases where the `repadmin` tool fails to synchronize domain controllers.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use the `Sync-DomainController` function:

1. To synchronize all domain controllers in a specific domain:

```
Sync-DomainController -Domain "contoso.com"
```

2. To run the function in verbose mode, which will display additional information about the synchronization process:

```
Sync-DomainController -Domain "contoso.com" -Verbose
```

These are just a few examples of how you could use the `Sync-DomainController` function. You can customize the function's behavior by specifying different parameters or modifying the function's code.

---

#### Script

```powershell
function Sync-DomainController {

    <#
    .SYNOPSIS
        Synchronizes all domain controllers in the specified domain.

    .DESCRIPTION
        This function synchronizes all domain controllers in the specified domain by forcing replication using the repadmin tool.

    .PARAMETER Domain
        The name of the domain to synchronize. Defaults to the user's domain.

    .EXAMPLE
        Sync-DomainController -Domain "contoso.com"

    .NOTES
        Author: Unknown
        Last Edit: Unknown
        Version: 1.0
        Keywords: Active Directory, Domain Controller, Replication
    #>

    [CmdletBinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN
    )
    $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
    (Get-ADDomainController -Filter * -Server $Domain).Name | ForEach-Object {
        Write-Verbose -Message "Sync-DomainController - Forcing synchronization $_"
        repadmin /syncall $_ $DistinguishedName /e /A | Out-Null
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Sync-DomainController.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Sync-DomainController.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
