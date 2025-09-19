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
