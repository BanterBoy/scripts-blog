---
layout: post
title: Copy-GroupMembership.ps1
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

<button class="btn" type="submit" onclick="window.open('https://scripts.lukeleigh.com/powershell/functions/myProfile/Copy-GroupMembership.ps1')">
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
