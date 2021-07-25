function Test-ProfileExists {
    $profprec = @(
        'CurrentUserCurrentHost',
        'CurrentUserAllHosts',
        'AllUsersCurrentHost',
        'AllUsersAllHosts'
    )
    $profhash = @{}

    # Get all the profile paths
    ($PROFILE | Get-Member -MemberType noteproperty).Name | ForEach-Object {
        $profhash.$_ = $profile.$_
    }

    $profprec | ForEach-Object {
        if (Test-Path $profhash.$_) {
            Write-Output "$_ - Exists!"
            Write-Output "Path - $($profhash.$_)"
        }
        else {
            Write-Output "$_ - Not Found!"
        }
    }
}
