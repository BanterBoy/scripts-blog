---
layout: post
title: Remove-UserProfiles.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/remove-userprofiles/
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

Removes old user profiles from a specified domain controller.

#### Detailed Description

The Remove-OldUserProfile function removes old user profiles from a specified domain controller. It takes the name of the domain controller, credentials for the remote session, and the SamAccountName of the user whose profile needs to be removed as input parameters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-OldUserProfile -ComputerName "DC01" -Credential $cred -SamAccountName "john.doe"
```

This example removes the user profile for the user with SamAccountName "john.doe" from the domain controller named "DC01" using the specified credentials.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires administrative privileges on the domain controller.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Removes old user profiles from a specified domain controller.

.DESCRIPTION
The Remove-OldUserProfile function removes old user profiles from a specified domain controller. It takes the name of the domain controller, credentials for the remote session, and the SamAccountName of the user whose profile needs to be removed as input parameters.

.PARAMETER ComputerName
Specifies the name of the domain controller to sync. If not provided, the local computer name is used.

.PARAMETER Credential
Specifies the credentials to use for the remote session.

.PARAMETER SamAccountName
Specifies the SamAccountName of the user whose profile needs to be removed.

.EXAMPLE
Remove-OldUserProfile -ComputerName "DC01" -Credential $cred -SamAccountName "john.doe"

This example removes the user profile for the user with SamAccountName "john.doe" from the domain controller named "DC01" using the specified credentials.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
None. The function does not generate any output.

.NOTES
This function requires administrative privileges on the domain controller.

.LINK
https://github.com/your-repo/Remove-OldUserProfiles.ps1

#>

function Remove-UserProfiles {
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
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 2,
            HelpMessage = 'Enter the credentials you would like to use for the remote session.')]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 2,
            HelpMessage = 'Enter the Users SamAccountName whose profile you would like to remove.')]
        [string]$SamAccountName
    )

    begin {
        if (-not $ComputerName) {
            $ComputerName = $env:COMPUTERNAME
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Remove user profile for $SamAccountName")) {
            try {
                # Create a CIM session with the specified credentials
                $cimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential

                # Get the user profile on the server and remove it if it matches the SamAccountName
                $userProfile = Get-CimInstance -Class Win32_UserProfile -CimSession $cimSession | Where-Object { $_.LocalPath.split('\')[-1] -like $SamAccountName }
        
                if ($userProfile) {
                    Write-Verbose "User profile for $SamAccountName found on $ComputerName. Removing..."
                    $userProfile | Remove-CimInstance -CimSession $cimSession
                    Write-Verbose "User profile for $SamAccountName removed successfully."
                }
                else {
                    Write-Warning "User profile for $SamAccountName not found on $ComputerName"
                }

                # Remove the CIM session
                Remove-CimSession -CimSession $cimSession
            }
            catch {
                Write-Error "Failed to remove user profile for $SamAccountName on $($ComputerName)"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Remove-UserProfiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-UserProfiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

