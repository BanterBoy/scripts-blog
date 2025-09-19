function Test-SamAccountName {
    param(
        [Parameter(Mandatory = $true)]
        [String] $SamAccountName
    )
    $null -ne ([ADSISearcher] "(SamAccountName=$SamAccountName)").FindOne()
}
