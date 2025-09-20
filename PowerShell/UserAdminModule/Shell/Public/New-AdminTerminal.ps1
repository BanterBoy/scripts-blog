function New-AdminTerminal {
    <#
	.Synopsis
	Starts an Elevated Microsoft Terminal.

	.Description
	Opens a new Microsoft Terminal Elevated as Administrator. If the user is already running an elevated
	Microsoft Terminal, a message is displayed in the console session.

	.Example
	New-AdminShell

	#>

	Start-Process "wt.exe" -ArgumentList "-p pwsh" -Verb runas -PassThru
}
