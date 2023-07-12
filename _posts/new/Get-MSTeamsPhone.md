---
layout: post
title: Get-MSTeamsPhone.ps1
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

**_@GitHub Copilot_** - This PowerShell script defines a cmdlet called `Get-MSTeamsPhone` that retrieves information about a Microsoft Teams phone assignment for a given user. The script starts by defining the cmdlet's description, examples, inputs, outputs, and notes using PowerShell's comment-based help syntax.

The `Get-MSTeamsPhone` cmdlet takes a single parameter called `UserPrincipalName`, which is a string representing the user's principal name. This parameter is marked as mandatory and can be piped to the cmdlet. The cmdlet also imports the `MicrosoftTeams` module in the `begin` block.

The `process` block is where the main logic of the cmdlet resides. It first checks if the cmdlet should process the input using the `ShouldProcess` method. If it should, it tries to retrieve the user's information using the `Get-CsOnlineUser` cmdlet from the `MicrosoftTeams` module. If an error occurs, it writes the error to the console using the `Write-Error` cmdlet. Finally, it outputs the user's information using the `Write-Output` cmdlet and selects a subset of properties using the `Select-Object` cmdlet.

The `end` block is empty and serves as a placeholder for any cleanup code that may be needed.

Overall, this script provides a simple and straightforward way to retrieve Microsoft Teams phone assignment information for a given user. However, it could benefit from some improvements in terms of readability and performance. For example, the `process` block could be refactored to use a `try`/`catch` block instead of an `if` statement to handle errors. Additionally, the `Select-Object` cmdlet could be replaced with a `Format-Table` cmdlet to improve the output's readability.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you can use this PowerShell script:

1. To retrieve the Microsoft Teams phone assignment information for a specific user, run the following command:

   ```
   Get-MSTeamsPhone -UserPrincipalName "user@example.com"
   ```

   This will return the phone assignment information for the user with the specified UserPrincipalName.

2. To retrieve the Microsoft Teams phone assignment information for multiple users, you can pipe a list of UserPrincipalNames to the cmdlet. For example:

   ```
   "user1@example.com", "user2@example.com", "user3@example.com" | Get-MSTeamsPhone
   ```

   This will return the phone assignment information for all three users.

3. You can also use the `Select-Object` cmdlet to select specific properties from the output. For example:

   ```
   Get-MSTeamsPhone -UserPrincipalName "user@example.com" | Select-Object DisplayName, LineUri
   ```

   This will return only the DisplayName and LineUri properties for the specified user.

I hope these examples help you get started with using this script!

---

#### Script

```powershell
function Get-MSTeamsPhone {

    <#
    .SYNOPSIS
        Get-MSTeamsPhone
    .DESCRIPTION
        Get-MSTeamsPhone -
    .EXAMPLE
        PS C:\> Get-MSTeamsPhone

    .INPUTS
        None.
    .OUTPUTS
        [String]
    .NOTES
        Author	: Luke Leigh
        Website	: https://blog.lukeleigh.com
        Twitter	: https://twitter.com/luke_leighs
        GitHub  : https://github.com/BanterBoy

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('gtp')]
    Param
    (

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [Alias('upn')]
        [string]$UserPrincipalName

    )

    begin {
        Import-Module MicrosoftTeams
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Getting MSTeams phone assignment")) {

            try {
                $User = Get-CsOnlineUser -Identity $UserPrincipalName
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                Write-Output -InputObject $User | Select-Object -Property DisplayName, DialPlan, EnterpriseVoiceEnabled, FeatureTypes, LineUri, UserPrincipalName
            }

        }

    }

    end {}

}


```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-MSTeamsPhone.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MSTeamsPhone.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
