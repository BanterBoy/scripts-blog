function New-StreamDeckShell {
    <#
    .SYNOPSIS
    Launches a new PowerShell console window suitable for Stream Deck buttons while running under alternate credentials.

    .DESCRIPTION
    Wraps the New-Shell command to guarantee a dedicated console window is created even when invoked from hosts that hide child
    windows (for example, Stream Deck scripts). This function forces the RunAsUser scenario to use a separate cmd.exe process so
    the interactive shell remains visible.

    .PARAMETER Credential
    Credentials used to start the shell session.

    .PARAMETER Shell
    Specifies which shell executable to launch. Valid values are 'pwsh' (PowerShell 7+) and 'PowerShell' (Windows PowerShell).

    .PARAMETER WindowTitle
    Optional console window title applied when the shell is launched.

    .PARAMETER ArgumentList
    Additional arguments that should be passed to the target shell executable.

    .EXAMPLE
    $credential = Get-Secret -Name 'lukeleigh.admin'
    New-StreamDeckShell -Credential $credential

    .EXAMPLE
    $credential = Get-Secret -Name 'lukeleigh.admin'
    New-StreamDeckShell -Credential $credential -Shell 'PowerShell' -WindowTitle 'Admin PowerShell'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $false)]
        [ValidateSet('pwsh', 'PowerShell')]
        [string]
        $Shell = 'pwsh',

        [Parameter(Mandatory = $false)]
        [string]
        $WindowTitle,

        [Parameter(Mandatory = $false)]
        [string[]]
        $ArgumentList = @()
    )

    $runAsUserMap = @{
        pwsh       = 'pwshRunAsUser'
        PowerShell = 'PowerShellRunAsUser'
    }

    $runAsUser = $runAsUserMap[$Shell]

    $parameters = @{
        RunAsUser      = $runAsUser
        Credentials    = $Credential
        ForceNewWindow = $true
    }

    if ($ArgumentList -and $ArgumentList.Count -gt 0) {
        $parameters['ShellArgumentList'] = $ArgumentList
    }

    if ($PSBoundParameters.ContainsKey('WindowTitle') -and -not [string]::IsNullOrWhiteSpace($WindowTitle)) {
        $parameters['WindowTitle'] = $WindowTitle
    }

    New-Shell @parameters
}
