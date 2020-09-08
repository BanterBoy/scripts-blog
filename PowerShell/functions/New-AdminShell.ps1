function Test-IsAdmin {
	<#
	.Synopsis
	Tests if the user is an administrator
	
	.Description
	Returns true if a user is an administrator, false if the user is not an administrator
	
	.Example
	Test-IsAdmin
	
	#>
	
	$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = New-Object Security.Principal.WindowsPrincipal $identity
	$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

}


function New-AdminShell {
	<#
	.Synopsis
	Starts an Elevated PowerShell Console.

	.Description
	Opens a new PowerShell Console Elevated as Administrator. If the user is already running an elevated
	administrator shell, a message is displayed in the console session.

	.Example
	New-AdminShell

	#>

	$Process = Get-Process | Where-Object { $_.Id -eq "$($PID)" }
	if (Test-IsAdmin = $True) {
		Write-Warning -Message "Admin Shell already running!"
	}
	else {
		if ($Process.Name -eq "powershell") {
			Start-Process -FilePath "powershell.exe" -Verb runas -PassThru
		}
		if ($Process.Name -eq "pwsh") {
			Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
		}
	}
}
