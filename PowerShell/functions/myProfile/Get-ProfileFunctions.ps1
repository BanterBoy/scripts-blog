function Get-ProfileFunctions {
    $psPath = "C:\GitRepos\ProfileFunctions"
	$funcs = @();
	Get-ChildItem "$psPath\ProfileFunctions\*.ps1" |
		ForEach-Object {
			$funcs = $funcs + (Get-ScriptFunctionNames -Path "$psPath\ProfileFunctions\$($_.Name)")
		}
	$funcs = $funcs + (Get-ScriptFunctionNames -Path "$psPath\Microsoft.PowerShell_profile.ps1")
	Invoke-BatchArray -Arr ($funcs | Sort-Object) -BatchSize 4 | 
		ForEach-Object {
			$line = ''
			$_ | ForEach-Object {
				$line += $_.PadRight(40, ' ')
			}
			Write-Host($line)
		}
}
