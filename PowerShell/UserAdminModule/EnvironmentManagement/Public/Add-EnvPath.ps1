function Add-EnvPath {
    <#
    .SYNOPSIS
    Adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'.
    
    .DESCRIPTION
    The Add-EnvPath function adds a path to the system or user environment variable 'Path' and the current session's environment variable 'Path'. If the specified path already exists in the environment variable, it will not be added again.
    
    .PARAMETER Path
    The path to add to the environment variable 'Path'.
    
    .PARAMETER Container
    Specifies the environment variable container to add the path to. Valid values are 'Machine', 'User', and 'Session'. The default value is 'Session'.
    
    .EXAMPLE
    Add-EnvPath -Path 'C:\Program Files\MyApp'
    
    This example adds 'C:\Program Files\MyApp' to the current session's environment variable 'Path'.
    
    .EXAMPLE
    Add-EnvPath -Path 'C:\Program Files\MyApp' -Container 'Machine'
    
    This example adds 'C:\Program Files\MyApp' to the system environment variable 'Path'.
    
    .NOTES
    Author: Unknown
    Date: Unknown
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
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }
    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}
