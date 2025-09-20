function Get-GoogleDirections {
    param([string] $From, [String] $To)

    process {
        Start-Process "https://www.google.com/maps/dir/$From/$To/"
    }
}