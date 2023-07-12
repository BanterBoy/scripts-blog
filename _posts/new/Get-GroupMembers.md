---
layout: post
title: Get-GroupMembers.ps1
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

**_@GitHub Copilot_** - This is a PowerShell script that defines a function called `Get-GroupMembers`. The purpose of this function is to extract the members of a specified Active Directory group. The function takes a single parameter, `$GroupName`, which is a string representing the name of the group to search for.

The function uses the `CmdletBinding` attribute to specify that it supports positional binding and should process the input. It also uses the `OutputType` attribute to specify that it returns a string. The `Alias` attribute is used to define an alias for the function, `ggm`.

The function begins by defining the `begin` and `end` blocks, which are empty in this case. The `process` block is where the main logic of the function is defined. It first checks if the `ShouldProcess` method returns true for the specified group name. If it does, the function uses the `Get-ADGroup` cmdlet to retrieve the group object(s) that match the specified group name. It then loops through each group object and retrieves the members of that group using the `Get-ADGroupMember` cmdlet. Finally, it loops through each group member and retrieves the corresponding user object using the `Get-ADUser` cmdlet.

Overall, this function is a useful tool for extracting the members of an Active Directory group. However, there are some potential areas for improvement. For example, the function could benefit from better error handling and more detailed output. Additionally, the function could be made more efficient by using pipeline input instead of looping through each group and member object.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use this PowerShell script:

Example 1: Get members of a specific group

```
Get-GroupMembers -GroupName "Sales Group"
```

This command will extract the members of the "Sales Group" Active Directory group.

Example 2: Get members of multiple groups

```
"Sales Group", "Marketing Group" | Get-GroupMembers
```

This command will extract the members of both the "Sales Group" and "Marketing Group" Active Directory groups.

Example 3: Get members of groups matching a wildcard pattern

```
Get-GroupMembers -GroupName "IT*"
```

This command will extract the members of all Active Directory groups whose names start with "IT".

These are just a few examples of how you could use this script. You can customize the command to fit your specific needs by adjusting the `-GroupName` parameter and any other parameters as necessary.

---

#### Script

```powershell
<#
.SYNOPSIS
    Get-GroupMembers

.DESCRIPTION
    This function exports the users within Active Directory groups that match a specified search string.

.PARAMETER GroupName
    Specifies the name of the group to search for. This parameter supports wildcards.

.EXAMPLE
    Get-GroupMembers -GroupName "Domain Admins"
    Outputs a list of users in the Active Directory groups matching the search string.

.OUTPUTS
    [Object]

.NOTES
    Author: Luke Leigh
    Date: 05/07/2023
    Version: 0001
    Changelog:
        - initial version

.INPUTS
    [string]GroupName
#>
function Get-GroupMembers {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ggm')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [Alias('gn')]
        [String]$GroupName
    )

    begin {

    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            $groups = Get-ADGroup -Filter ' Name -like $GroupName '
            $groups | ForEach-Object -Process {
                $groupMembers = Get-ADGroupMember -Identity $_.SamAccountName
                $groupMembers |
                ForEach-Object -Process {
                    Get-ADUser -Filter ' SamAccountName -like $_.SamAccountName ' -Properties *
                }
            }
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

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-GroupMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GroupMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
