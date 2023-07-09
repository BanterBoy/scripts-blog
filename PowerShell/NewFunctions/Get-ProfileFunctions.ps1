function Get-ProfileFunctions {
	function Get-Functions {
		Get-ChildItem "$PSScriptRoot\*.ps1" | Select-Object -Property BaseName
	}
	Get-Functions | Format-Wide -Autosize
}
