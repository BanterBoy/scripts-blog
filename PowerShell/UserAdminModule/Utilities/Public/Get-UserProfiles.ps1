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
