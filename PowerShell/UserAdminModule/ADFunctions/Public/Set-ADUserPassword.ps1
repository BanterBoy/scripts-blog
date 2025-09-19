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

# Example usage:
# $NewPassword = ConvertTo-SecureString "NewPassword123!" -AsPlainText -Force
# Set-ADUserPassword -SamAccountName 'jdoe' -Password $NewPassword -ChangePasswordAtLogon
