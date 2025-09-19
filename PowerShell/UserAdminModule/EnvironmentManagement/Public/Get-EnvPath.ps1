function Get-EnvPath {
    <#
    .SYNOPSIS
        Gets the environment path for the specified container.
    .DESCRIPTION
        This function retrieves the environment path for the specified container (Machine, User, or Process).
    .PARAMETER Container
        Specifies the container for which to retrieve the environment path. Valid values are Machine, User, and Process.
    .EXAMPLE
        PS C:\> Get-EnvPath -Container User
        Returns the environment path for the current user.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Machine', 'User', 'Process')]
        [string] $Container
    )
    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User    = [EnvironmentVariableTarget]::User
        Process = [EnvironmentVariableTarget]::Process
    }
    $containerType = $containerMapping[$Container]
    [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' |
    Where-Object { $_ }
}
