function Set-DisplayIsAdmin {

    if ((Test-IsAdmin) -eq $true) {
		$Username = whoami.exe /upn
		$host.UI.RawUI.WindowTitle = "$($Username) - Admin Privileges"
    }	
    else {
		$Username = whoami.exe /upn
		$host.UI.RawUI.WindowTitle = "$($Username) - User Privileges"
    }	
}
