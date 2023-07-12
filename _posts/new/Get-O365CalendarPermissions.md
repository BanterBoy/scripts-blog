---
layout: post
title: Get-O365CalendarPermissions.ps1
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

**_@GitHub Copilot_** - This PowerShell script is called Get-O365CalendarPermissions.ps1 and it is used to query the calendar permissions for a given user or set of users. The script starts with some basic PowerShell commands such as Get-Mailbox, New-Object, and Write-Output. These commands are used to create and output objects in PowerShell.

The script then defines a PowerShell cmdlet using the CmdletBinding attribute. This cmdlet has a default parameter set named 'Default', a medium confirm impact, and supports should process. It also has an output type of string and an alias of 'gcp'. The cmdlet takes a single parameter named UserPrincipalName, which is an array of strings. This parameter is used to specify the user or set of users whose calendar permissions will be queried.

The script then defines the begin, process, and end blocks of the cmdlet. The begin and end blocks are empty, but the process block contains the main logic of the cmdlet. The process block first checks if the ShouldProcess method of the PSCmdlet object returns true for the given UserPrincipalName. If it does, the script loops through each user in the UserPrincipalName array and gets the mailbox folder permissions for their calendar using the Get-MailboxFolderPermission cmdlet.

The script then loops through each permission returned by Get-MailboxFolderPermission and checks if the user type is 'Internal'. If it is, the script creates a new PSObject with properties for the UserPrincipalName, Calendar, User, and AccessRights. This PSObject is then output using the Write-Output cmdlet.

Overall, this script is a useful tool for querying the calendar permissions for a given user or set of users in an Office 365 environment. It uses PowerShell cmdlets and objects to accomplish this task in an efficient and readable manner.

To improve the code's readability, the developer could add comments to explain the purpose of each block of code. Additionally, the developer could use more descriptive variable names to make the code easier to understand. To improve performance, the developer could consider using the -ResultSize parameter with the Get-Mailbox cmdlet to limit the number of mailboxes returned.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are some examples of how you could use this script:

1. To query the calendar permissions for a single user, you could run the following command:

   `Get-O365CalendarPermissions -UserPrincipalName user1@contoso.com`

   This would return a list of all the internal users who have access to user1's calendar.

2. To query the calendar permissions for multiple users, you could run the following command:

   `Get-O365CalendarPermissions -UserPrincipalName user1@contoso.com, user2@contoso.com, user3@contoso.com`

   This would return a list of all the internal users who have access to the calendars of user1, user2, and user3.

3. You could also pipe the output of another cmdlet into Get-O365CalendarPermissions. For example, to query the calendar permissions for all users in a specific distribution group, you could run the following command:

   `Get-DistributionGroupMember -Identity 'Sales Team' | Get-O365CalendarPermissions`

   This would return a list of all the internal users who have access to the calendars of all members of the 'Sales Team' distribution group.

I hope these examples help you understand how to use this script!

---

#### Script

```powershell
function Get-O365CalendarPermissions {

    <#

    .SYNOPSIS
    Get-O365CalendarPermissions - A function to get the permissions for a calendar.

	.DESCRIPTION
    Get-O365CalendarPermissions - A function to get the permissions for a calendar. This function will only return the permissions for the calendar of the user named in UserPrincipalName. It will not return the permissions for any other calendars that the user may have access to.

	.PARAMETER UserName
    [string]UserPrincipalName - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.

	.EXAMPLE
    Get-O365CalendarPermissions -UserPrincipalName "user@example.com"

    Returns the permissions for the calendar of the user named in UserPrincipalName

	.INPUTS
    You can pipe objects to these perameters.

    - UserPrincipalName [string] - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.

	.OUTPUTS
    [string] - Returns the permissions for the calendar of the user named in UserPrincipalName

	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

	.LINK
    https://scripts.lukeleigh.com
    Get-MailboxFolderPermission
    Get-Mailbox
    New-Object
    Write-Output

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('gcp')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [Alias('upn')]
        [string[]]$UserPrincipalName
    )

    begin {
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Querying calendar permissions for")) {

            foreach ($User in $UserPrincipalName) {

                $Permissions = Get-MailboxFolderPermission "$($User):\Calendar"

                foreach ($Permission in $Permissions) {

                    if ($Permission.User.UserType -like 'Internal') {
                        $properties = @{
                            'UserPrincipalName' = $User
                            'Calendar'          = 'Calendar'
                            'User'              = $Permission.User.DisplayName
                            'AccessRights'      = $Permission.AccessRights
                        }
                        $Output = New-Object -TypeName psobject -Property $properties
                        Write-Output -InputObject $Output

                    }

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

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-O365CalendarPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-O365CalendarPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
