function Remove-EnvPath {
    <#
    .SYNOPSIS
        Removes a path from the environment variable 'Path' for the specified container.
    .DESCRIPTION
        This function removes a path from the environment variable 'Path' for the specified container. The container can be 'Machine', 'User', or 'Session'. If the container is 'Session', the function only removes the path from the current session's environment variable 'Path'. If the container is 'Machine' or 'User', the function also removes the path from the persisted environment variable 'Path' for the specified container.
    .PARAMETER Path
        The path to remove from the environment variable 'Path'.
    .PARAMETER Container
        The container for the environment variable 'Path'. The default value is 'Session'.
        Valid values are:
        - Machine
        - User
        - Session
    .EXAMPLE
        Remove-EnvPath -Path 'C:\temp' -Container 'User'
        This example removes the path 'C:\temp' from the environment variable 'Path' for the user container.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )
    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -contains $Path) {
            $persistedPaths = $persistedPaths | Where-Object { $_ -and $_ -ne $Path }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }
    $envPaths = $env:Path -split ';'
    if ($envPaths -contains $Path) {
        $envPaths = $envPaths | Where-Object { $_ -and $_ -ne $Path }
        $env:Path = $envPaths -join ';'
    }
}
