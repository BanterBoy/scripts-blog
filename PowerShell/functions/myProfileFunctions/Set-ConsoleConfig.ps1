function Set-ConsoleConfig {
    param (
        [int]$WindowHeight,
        [int]$WindowWidth
    )
    [System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
}
