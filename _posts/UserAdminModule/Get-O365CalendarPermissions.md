---
layout: post
title: Get-O365CalendarPermissions.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-O365CalendarPermissions/
categories:
- UserAdminModule
- Exchange
tags:
- PowerShell
- User Admin Module
- O 365 Calendar Permissions
description: Get-O365CalendarPermissions - A function to get the permissions for a
  calendar.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Get-O365CalendarPermissions - A function to get the permissions for a calendar.

#### Detailed Description

Get-O365CalendarPermissions - A function to get the permissions for a calendar. This function will only return the permissions for the calendar of the user named in UserPrincipalName. It will not return the permissions for any other calendars that the user may have access to.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-O365CalendarPermissions -UserPrincipalName "user@example.com"
```

Returns the permissions for the calendar of the user named in UserPrincipalName

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
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

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
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
                            'CalendarOwner'     = $Permission.Identity -split ':' | Select-Object -First 1
                            'UserPrincipalName' = $User
                            'UserType'          = $Permission.User.UserType
                            'PermissionType'    = 'Calendar'
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
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-O365CalendarPermissions.ps1')">
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

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

