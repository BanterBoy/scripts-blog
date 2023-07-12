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

**_@GitHub Copilot_** - This is a PowerShell script that copies group membership from one user to another. The script takes two parameters, the SamAccountName of the user to copy from and the SamAccountName of the user to copy to. The script uses the Get-ADUser cmdlet to retrieve the group membership of the user to copy from. It then loops through each group and attempts to add the user to the group using the Add-ADGroupMember cmdlet. If the user is already a member of the group, it is skipped. If an error occurs while attempting to add the user to a group, a warning is written to the console and the group is output to the verbose stream.

The script uses PowerShell's CmdletBinding attribute to specify the default parameter set, positional binding, and support for ShouldProcess. The OutputType attribute is used to specify the type of output the cmdlet produces. The param block defines the two parameters the script takes, CopyMembershipFrom and CopyMembershipTo. The ValidateNotNullOrEmpty attribute is used to ensure that the parameters are not null or empty.

The script uses a try-catch block to handle errors that may occur while adding the user to a group. If an error occurs, the error message is written to the console and the group is output to the verbose stream. The Write-Output cmdlet is used to output a message indicating that the user has been added to a group.

To improve the readability of the code, the script could use more comments to explain what each section of the code does. Additionally, the script could use more descriptive variable names to make it easier to understand what each variable represents. To improve performance, the script could be optimized to use the pipeline more efficiently, reducing the amount of memory used by the script.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use the `Copy-GroupMembership` script:

Example 1: Copy group membership from one user to another

```
Copy-GroupMembership -CopyMembershipFrom "UserA" -CopyMembershipTo "UserB"
```

This example would copy the group membership from the user "UserA" to the user "UserB".

Example 2: Use ShouldProcess to confirm the operation before proceeding

```
Copy-GroupMembership -CopyMembershipFrom "UserA" -CopyMembershipTo "UserB" -Confirm
```

This example would use the ShouldProcess feature of PowerShell to prompt the user to confirm the operation before proceeding.

Example 3: Use Verbose output to display detailed information about the operation

```
Copy-GroupMembership -CopyMembershipFrom "UserA" -CopyMembershipTo "UserB" -Verbose
```

This example would use the Verbose output to display detailed information about the operation, including which groups were copied and any errors that occurred.

I hope these examples help you understand how to use the `Copy-GroupMembership` script!

---

#### Script

```powershell
function Copy-GroupMembership {

    <#
	.SYNOPSIS
		Copy Group Membership from an existing Active Directory User to another Active Directory User

	.DESCRIPTION
		This function will copy a users Active Directory Group Membership to another Active Directory User by querying a users current membership and adding the same groups to another user.

	.PARAMETER CopyMembershipFrom
		Enter the SamAccountName for the user you are copying from.

	.PARAMETER CopyMembershipTo
		Enter the SamAccountName of the user you are copying to.

	.EXAMPLE
		PS C:\> Copy-GroupMembership -CopyMembershipFrom SAMACCOUNTNAME -CopyMembershipTo SAMACCOUNTNAME
		Copies all group membership from one Active Directory User and replicates on another Active Directory User

	.OUTPUTS
		Outputs a list of Active Directory Groups the Active Directory User has been added to.

	.NOTES
		General notes

	.INPUTS
		Active Directory SamAccountName
	#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('cgm')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the SamAccountName for the user you are copying from.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cmf')]
        [string]$CopyMembershipFrom,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2,
            HelpMessage = 'Enter the SamAccountName of the user you are copying to.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cmt')]
        [string]$CopyMembershipTo
    )

    begin {
    }

    process {

        if ($PSCmdlet.ShouldProcess("$CopyMembershipTo", "Copying Group Membership from $($CopyMembershipFrom)")) {

            $GroupMembership = Get-ADUser -Identity $CopyMembershipFrom -Properties memberof
            foreach ($Group in $GroupMembership.memberof) {
                try {
                    if ($Group -notcontains $Group.SamAccountName) {
                        Add-ADGroupMember -Identity $Group $CopyMembershipTo -ErrorAction Stop
                        Write-Output "Added to - $($Group)"
                    }
                }
                catch {
                    Write-Warning "$($_)"
                    Write-Verbose "$($Group)" -Verbose
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Copy-GroupMembership.ps1')">
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

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
