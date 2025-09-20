Function Get-NeglectedFiles {
    Param(
        [Parameter()]
        [string[]]
        $path,

        [Parameter()]
        [int]
        $numberDays
    )
    $cutOffDate = (Get-Date).AddDays(-$numberDays)
    Get-ChildItem -Path $path | Where-Object { 
        $_.LastAccessTime -le $cutOffDate 
    }
}
