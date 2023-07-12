---
layout: post
title: New-MSTeamsPhone.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called New-MSTeamsPhone.ps1 and contains a function with the same name. The function takes three parameters: $Credentials, $UserPrincipalName, and $PhoneNumber. The $Credentials parameter is of type PSCredential and is used to authenticate the user. The $UserPrincipalName parameter is a string that represents the user's principal name, and the $PhoneNumber parameter is a string that represents the user's phone number.

The function begins by importing the MicrosoftTeams module. It then checks if the ShouldProcess method of the PSCmdlet object returns true. If it does, the function attempts to configure the user's phone number by calling three methods: Set-CsPhoneNumberAssignment, Grant-CsOnlineVoiceRoutingPolicy, and Get-CsOnlineUser. If an error occurs, the function writes the error message to the console. Finally, the function returns the user's display name, dial plan, enterprise voice enabled status, feature types, line URI, and user principal name.

This script is designed to configure a user's phone number in Microsoft Teams. It uses the MicrosoftTeams module to set the user's phone number and voice routing policy. The function is well-structured and easy to read, with clear parameter names and helpful help messages. The use of try-catch blocks ensures that any errors are handled gracefully. One possible improvement to the code would be to add more detailed error messages to help diagnose any issues that may arise. Additionally, the function could be made more efficient by using pipeline input instead of positional parameters.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use this script:

Example 1: Using positional parameters

```
New-MSTeamsPhone.ps1 -Credential $creds -UserPrincipalName "jdoe@contoso.com" -PhoneNumber "+442048418255"
```

This example uses positional parameters to specify the user's credentials, user principal name, and phone number. The script will attempt to configure the user's phone number in Microsoft Teams.

Example 2: Using pipeline input

```
$creds | New-MSTeamsPhone.ps1 -UserPrincipalName "jdoe@contoso.com" -PhoneNumber "+442048418255"
```

This example uses pipeline input to specify the user's credentials. The script will prompt you to enter the user principal name and phone number.

Example 3: Using the output in a variable

```
$user = New-MSTeamsPhone.ps1 -Credential $creds -UserPrincipalName "jdoe@contoso.com" -PhoneNumber "+442048418255"
$user.DisplayName
```

This example stores the output of the script in a variable called `$user`. The script will return an object with properties such as `DisplayName`, `DialPlan`, and `LineUri`. You can then access these properties using dot notation.

---

#### Script

```powershell
function New-MSTeamsPhone {

    <#
    .SYNOPSIS
        Install-RequiredModules - Tests to see if scripts/function required modules are available.
    .DESCRIPTION
        Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .EXAMPLE
        PS C:\> Install-RequiredModules
        Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .INPUTS
        None.
    .OUTPUTS
        [String] Outputs details of installation, importing and failure.
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
    [Alias('trm')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter your credentials or pipe input.'
        )]
        [Alias('creds')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [Alias('upn')]
        [string]$UserPrincipalName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2,
            HelpMessage = 'Enter the full telephone number or pipe input. (e.g. +442048418255)'
        )]
        [Alias('tel')]
        [string]$PhoneNumber
    )

    begin {
        Import-Module MicrosoftTeams
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Configuring MSTeams phone assignment")) {

            try {
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -EnterpriseVoiceEnabled:$true
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -PhoneNumber $PhoneNumber -PhoneNumberType DirectRouting
                Grant-CsOnlineVoiceRoutingPolicy -Identity $UserPrincipalName -PolicyName "VRPolicy"
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                Get-CsOnlineUser -Identity $UserPrincipalName | Select-Object -Property DisplayName, DialPlan, EnterpriseVoiceEnabled, FeatureTypes, LineUri, UserPrincipalName
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

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/New-MSTeamsPhone.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-MSTeamsPhone.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
