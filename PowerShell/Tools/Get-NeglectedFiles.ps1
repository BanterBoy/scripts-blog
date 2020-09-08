Function Get-NeglectedFiles {
      Param(
            [string[]]$path,
            [int]$numberDays)
      $cutOffDate = (Get-Date).AddDays(-$numberDays)
      Get-ChildItem -Path $path |
      Where-Object { $_.LastAccessTime -le $cutOffDate }
}
