function Get-ScriptFunctionNames {
    param (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [System.String]$Path
    )

    Process{
        [System.Collections.Generic.List[String]]$funcNames = New-Object System.Collections.Generic.List[String]

        if (([System.String]::IsNullOrWhiteSpace($Path))) {
			return $funcNames
		}
        
		Select-String -Path "$Path" -Pattern "^[F|f]unction.*[A-Za-z0-9+]-[A-Za-z0-9+]" | 
			ForEach-Object {
				[System.Text.RegularExpressions.Regex] $regexp = New-Object Regex("(function)( +)([\w-]+)")
				[System.Text.RegularExpressions.Match] $match = $regexp.Match("$_")

				if ($match.Success)	{
					$funcNames.Add("$($match.Groups[3])")
				}   
			}
        
        return ,$funcNames.ToArray()
    }
}
