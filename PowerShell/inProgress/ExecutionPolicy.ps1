$execpol = Get-ExecutionPolicy -List
if ( $execpol -ne 'Unrestricted' ) {
	Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}


Set-ExecutionPolicy -ExecutionPolicy Unrestricted
