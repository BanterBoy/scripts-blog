---
layout: post
title: Get-UserProfiles.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/get-userprofiles/
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

Retrieves user profiles from a remote server.

#### Detailed Description

The Get-UserProfiles function retrieves user profiles from a remote server using CIM sessions. It returns a list of user profiles with their corresponding usernames and profile paths.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-UserProfiles -ComputerName "DC01" -Credential $cred
```

Retrieves user profiles from the "DC01" domain controller using the specified credentials.

**Example 2**

```powershell
Get-UserProfiles
```

Retrieves user profiles from the local computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires administrative privileges on the remote server.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Retrieves user profiles from a remote server.

.DESCRIPTION
The Get-UserProfiles function retrieves user profiles from a remote server using CIM sessions. It returns a list of user profiles with their corresponding usernames and profile paths.

.PARAMETER ComputerName
Specifies the name of the domain controller to sync. If not specified, the local computer name is used.

.PARAMETER Credential
Specifies the credentials to use for the remote session.

.EXAMPLE
Get-UserProfiles -ComputerName "DC01" -Credential $cred
Retrieves user profiles from the "DC01" domain controller using the specified credentials.

.EXAMPLE
Get-UserProfiles
Retrieves user profiles from the local computer.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject
A custom object with the following properties:
- UserName: The username associated with the user profile.
- UserProfilePath: The path to the user profile.

.NOTES
This function requires administrative privileges on the remote server.

.LINK
https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters

#>
#requires -PSEdition Desktop

function Get-UserProfiles {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Enter the name of the domain controller you would like to sync.')]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 2,
            HelpMessage = 'Enter the credentials you would like to use for the remote session.')]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        # Create a CIM session with the specified computer name and credentials
        $cimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential
    }

    process {
        try {
            # Get all user profiles on the server
            $userProfiles = Get-CimInstance -Class Win32_UserProfile -CimSession $cimSession

            # Output the user profiles
            $userProfiles | ForEach-Object {
                $userName = $_.LocalPath.split('\')[-1]
                [PSCustomObject]@{
                    UserName        = $userName
                    UserProfilePath = $_.LocalPath
                }
            }

            # Remove the CIM session
            Remove-CimSession -CimSession $cimSession
        }
        catch {
            Write-Error "Failed to get user profiles on $($ComputerName)"
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-UserProfiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserProfiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

