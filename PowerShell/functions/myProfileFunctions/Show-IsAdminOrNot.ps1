function Show-IsAdminOrNot {
    $IsAdmin = Test-IsAdmin
    if ( $IsAdmin -eq "False") {
        Write-Warning -Message "Admin Privileges!"
    }
    else {
        Write-Warning -Message "User Privileges"
    }
}