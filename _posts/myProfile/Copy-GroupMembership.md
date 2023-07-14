---
layout: post
title: Copy-GroupMembership.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Copy-GroupMembership`. This function is designed to copy a user's Active Directory group membership to another user. The function takes two parameters: `$CopyMembershipFrom` and `$CopyMembershipTo`. These parameters are used to specify the source and destination users for the group membership copy operation.

The function begins by using the `Get-ADUser` cmdlet to retrieve the group membership of the source user specified by the `$CopyMembershipFrom` parameter. The `memberof` property of the user object is used to retrieve the list of groups that the user is a member of.

The function then iterates over each group in the `$GroupMembership` list. For each group, the function checks if the destination user specified by the `$CopyMembershipTo` parameter is already a member of the group. If the destination user is not already a member of the group, the function uses the `Add-ADGroupMember` cmdlet to add the destination user to the group. The function also writes the name of the group to the output stream using the `Write-Output` cmdlet.

Overall, this function is a useful tool for administrators who need to copy group membership from one user to another in an Active Directory environment. By automating this process, the function can save administrators time and reduce the risk of errors.

Possible ways to improve the code with respect to readability and performance include adding comments to explain the purpose of each section of the code, using more descriptive variable names, and optimizing the code to reduce the number of calls to the Active Directory server.

**_@BanterBoy:_** - Can you provide an example of how to use the Copy-GroupMembership function in a PowerShell script?

**_@GitHub Copilot_** - Sure! Here's an example of how to use the `Copy-GroupMembership` function in a PowerShell script:

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Call the Copy-GroupMembership function to copy group membership from one user to another
Copy-GroupMembership -CopyMembershipFrom "jdoe" -CopyMembershipTo "jsmith"
```

In this example, the `Copy-GroupMembership` function is called with the `-CopyMembershipFrom` parameter set to `"jdoe"` and the `-CopyMembershipTo` parameter set to `"jsmith"`. This will copy all of the group memberships from the user with the SamAccountName `"jdoe"` to the user with the SamAccountName `"jsmith"`. The function will output a list of the Active Directory groups that the destination user was added to.

Note that the `ActiveDirectory` module needs to be imported before the `Copy-GroupMembership` function can be used. This module provides the `Get-ADUser` and `Add-ADGroupMember` cmdlets that the function relies on.

---

#### Script

```powershell
Function Copy-GroupMembership {

    <#
    .SYNOPSIS
        Copy Group Membership from an existing Active Directory User to another Active Directory User
    .DESCRIPTION
        This function will copy a users Active Directory Group Membership to another Active Directory User by querying a users current membership and adding the same groups to another user.
    .EXAMPLE
        PS C:\> Copy-GroupMembership -CopyMembershipFrom SAMACCOUNTNAME -CopyMembershipTo SAMACCOUNTNAME
        Copies all group membership from one Active Directory User and replicates on another Active Directory User
    .INPUTS
        Active Directory SamAccountName
    .OUTPUTS
        Outputs a list of Active Directory Groups the Active Directory User has been added to.
    .NOTES
        General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName for the user you are copying from."
        )]
        [string]
        $CopyMembershipFrom,

        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName of the user you are copying to."
        )]
        [string]
        $CopyMembershipTo

        )

    $GroupMembership = Get-ADUser -Identity $CopyMembershipFrom -Properties memberof
    foreach ($Group in $GroupMembership.memberof) {
        if ($Group -notcontains $Group.SamAccountName) {
            Add-ADGroupMember -Identity $Group $CopyMembershipTo -ErrorAction SilentlyContinue
            Write-Output $Group
        }
    }
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Copy-GroupMembership.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-GroupMembership.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
