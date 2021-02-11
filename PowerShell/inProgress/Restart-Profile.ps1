function Restart-Profile {

    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $isCtrl,

        [Parameter()]
        [switch]
        $isShift

    )

    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) |
    ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Running $_"
            . $_
        }
    }
    
}
