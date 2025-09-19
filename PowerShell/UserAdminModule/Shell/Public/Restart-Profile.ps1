function Restart-Profile {

    <#
    .SYNOPSIS
        Restarts specified PowerShell profiles by reloading them.

    .DESCRIPTION
        This function reloads the specified PowerShell profiles. It checks if the profile path exists 
        before attempting to run it. You can specify which profile(s) to restart using the -ProfileType parameter.

    .PARAMETER ProfileType
        Specifies which profile(s) to restart. Possible values are:
        - AllUsersAllHosts: All users, all hosts profile
        - AllUsersCurrentHost: All users, current host profile
        - CurrentUserAllHosts: Current user, all hosts profile
        - CurrentUserCurrentHost: Current user, current host profile
        - All: All profiles (default)

    .EXAMPLE
        Restart-Profile -ProfileType AllUsersCurrentHost -Verbose
        This example reloads the AllUsersCurrentHost profile with verbose output enabled.

    .EXAMPLE
        Restart-Profile -ProfileType All -Verbose
        This example reloads all profiles with verbose output enabled.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('AllUsersAllHosts', 'AllUsersCurrentHost', 'CurrentUserAllHosts', 'CurrentUserCurrentHost', 'All')]
        [string]$ProfileType = 'All'
    )

    # Array of profile paths to be reloaded based on the ProfileType parameter
    switch ($ProfileType) {
        'AllUsersAllHosts' {
            $profilePaths = @($Profile.AllUsersAllHosts)
        }
        'AllUsersCurrentHost' {
            $profilePaths = @($Profile.AllUsersCurrentHost)
        }
        'CurrentUserAllHosts' {
            $profilePaths = @($Profile.CurrentUserAllHosts)
        }
        'CurrentUserCurrentHost' {
            $profilePaths = @($Profile.CurrentUserCurrentHost)
        }
        'All' {
            $profilePaths = @(
                $Profile.AllUsersAllHosts,
                $Profile.AllUsersCurrentHost,
                $Profile.CurrentUserAllHosts,
                $Profile.CurrentUserCurrentHost
            )
        }
    }

    # Iterate through each profile path
    foreach ($profilePath in $profilePaths) {
        if (Test-Path -Path $profilePath) {
            Write-Verbose "Running profile script: $profilePath"
            try {
                . $profilePath
                Write-Verbose "Successfully ran profile script: $profilePath"
            }
            catch {
                Write-Warning "Failed to run profile script: $profilePath - $_"
            }
        }
        else {
            Write-Verbose "Profile path does not exist: $profilePath"
        }
    }
}

# Example Usage:
# Restart-Profile -ProfileType AllUsersCurrentHost -Verbose
