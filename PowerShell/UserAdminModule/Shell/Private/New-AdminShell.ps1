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
	if ($Process.Name -eq "PowerShell") {
		Start-Process -FilePath "PowerShell.exe" -Verb runas -PassThru
	}
	if ($Process.Name -eq "pwsh") {
		Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
	}
}
