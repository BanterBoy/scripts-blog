function Test-ProfileExists {
    $profile.PSObject.Properties.Name |
    Where-Object { $_ -ne 'Length' } |
    ForEach-Object { [PSCustomObject]@{Profile = $_; Present = Test-Path $profile.$_ ; Path = $profile.$_ } }
}
