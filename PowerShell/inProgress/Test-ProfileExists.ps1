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
            Write-Verbose -Message "$_ - Exists!"
            Write-Verbose -Message "Path - $($profhash.$_)"
        }
        else {
            Write-Verbose -Message "$_ - Not Found!"
        }
    }
}
