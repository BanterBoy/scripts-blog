---
layout: post
title: Set-ADUserPassword.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/set-aduserpassword/
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

Sets the password for an Active Directory user account.

#### Detailed Description

This function sets the password for an Active Directory user account based on the provided SamAccountName. The password is taken as a secure string for security purposes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$NewPassword = ConvertTo-SecureString "NewPassword123!" -AsPlainText -Force
```

Set-ADUserPassword -SamAccountName 'jdoe' -Password $NewPassword -ChangePasswordAtLogon This example sets the password for the user account 'jdoe' to the new password provided and forces the user to change the password at next logon.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Set-ADUserPassword {
	<#
    .SYNOPSIS
        Sets the password for an Active Directory user account.

    .DESCRIPTION
        This function sets the password for an Active Directory user account based on the provided SamAccountName.
        The password is taken as a secure string for security purposes.

    .PARAMETER SamAccountName
        The SamAccountName (username) of the Active Directory user account for which the password needs to be set.

    .PARAMETER Password
        The new password to be set for the user account. This should be provided as a secure string.

    .PARAMETER ChangePasswordAtLogon
        Optional switch to force the user to change the password at next logon.

    .EXAMPLE
        $NewPassword = ConvertTo-SecureString "NewPassword123!" -AsPlainText -Force
        Set-ADUserPassword -SamAccountName 'jdoe' -Password $NewPassword -ChangePasswordAtLogon

        This example sets the password for the user account 'jdoe' to the new password provided and forces the user to change the password at next logon.

    .NOTES
        Author: Your Name
        Date: 2024-06-30
    #>

	[CmdletBinding(
		SupportsShouldProcess = $true,
		ConfirmImpact = "Medium"
	)]
	param(
		[Parameter(
			Mandatory = $true,
			Position = 0,
			HelpMessage = "Enter the SamAccountName of the AD user."
		)]
		[string]$SamAccountName,

		[Parameter(
			Mandatory = $true,
			Position = 1,
			HelpMessage = "Enter the new password as a secure string."
		)]
		[SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			HelpMessage = "Force the user to change the password at next logon."
		)]
		[switch]$ChangePasswordAtLogon
	)

	begin {
		Write-Verbose "Starting to set password for AD user."
	}

	process {
		if ($SamAccountName) {
			if ($PSCmdlet.ShouldProcess($SamAccountName, "Setting AD User password")) {
				try {
					Write-Verbose "Setting password for user: $SamAccountName"
					Set-ADAccountPassword -Identity $SamAccountName -NewPassword $Password -Reset -ErrorAction Stop
					Write-Verbose "Password for user $SamAccountName has been set successfully."

					if ($ChangePasswordAtLogon) {
						Write-Verbose "Forcing user $SamAccountName to change password at next logon"
						Set-ADUser -Identity $SamAccountName -ChangePasswordAtLogon $true -ErrorAction Stop
					}
				}
				catch {
					Write-Error -Message "Failed to set password for user $SamAccountName. Error: $_"
				}
			}
		}
		else {
			Write-Error -Message "SamAccountName is null or empty."
		}
	}

	end {
		Write-Verbose "Completed setting password for AD user."
	}
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Set-ADUserPassword.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-ADUserPassword.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

