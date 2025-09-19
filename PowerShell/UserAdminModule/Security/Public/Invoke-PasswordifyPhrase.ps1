function Invoke-PasswordifyPhrase {
    <#
	.SYNOPSIS
		Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.
	
	.DESCRIPTION
		Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.
	
	.PARAMETER Phrase
		Phrase to passwordify.
	
	.PARAMETER AllowNumericToAlphaConversion
		If supplied then any numeric characters defined in the conversion table can be converted to alpha characters.
	
	.PARAMETER DisallowAlphaCaseChange
		If supplied then alpha characters casing can not be changed.
	
	.PARAMETER DisallowConversionToSpecialCharacters
		If supplied then any characters defined in the conversion table can not be converted to special characters if available.
	
	.PARAMETER SpecialCharactersAllowed
		If supplied then only special characters within this array will be used as replacements.
	
	.PARAMETER NoClipboard
		If supplied the output will not be written to the clipboard
	
	.EXAMPLE
		Invoke-PasswordifyPhrase "SecureMyPassphraseAndMakeItAwesome"
	
	.OUTPUTS
		System.String. Phrase, passwordified :)
	
	.NOTES
		Author:     Rob Green
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- Phrase [string]
    #>
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Phrase to passwordify.")]
		[string]$Phrase,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then any numeric characters defined in the conversion table can be converted to alpha characters.")]
		[switch]$AllowNumericToAlphaConversion,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then alpha characters casing can not be changed.")]
		[switch]$DisallowAlphaCaseChange,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then any characters defined in the conversion table can not be converted to special characters if available.")]
		[switch]$DisallowConversionToSpecialCharacters,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then only special characters within this array will be used as replacements.")]
		[string[]]$SpecialCharactersAllowed = $null,

		[Parameter(Mandatory = $false, HelpMessage="If supplied the output will not be written to the clipboard")]
		[switch]$NoClipboard
	)

    function RandChar {
        param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Phrase to passwordify.")]
            [string]$Char
        )

        $allowed = @()
    
        if ($hashTable.ContainsKey($Char)) {
            foreach ($c in $hashTable[$Char]) {
                if (($DisallowConversionToSpecialCharacters.IsPresent) -and (-not ($c -match "[a-zA-Z0-9]"))) {
                    continue
                }

                if (($null -ne $SpecialCharactersAllowed) -and (-not ($c -match "[a-zA-Z0-9]") -and (-not ($SpecialCharactersAllowed -contains $c)))) {
                    continue
                }

                if (($DisallowAlphaCaseChange.IsPresent) -and ((($c -match "[a-z]") -and ($Char -match "[A-Z]")) -or (($c -match "[A-Z]") -and ($Char -match "[a-z]")))) {
                    continue
                }

                $allowed += $c
            }

            if ($null -ne $allowed -and $allowed.length -gt 0) {
                return get-random $allowed
            }
        }
    
        return $Char
    }

    $hashTable = New-Object System.Collections.HashTable
    $hashTable.b = @("b", "B", "8")
    $hashTable.B = @("b", "B", "8")
    $hashTable.e = @("e", "E", "3")
    $hashTable.E = @("e", "E", "3")
    $hashTable.i = @("i", "I", "1", "|", "!")
    $hashTable.I = @("i", "I", "1", "|", "!")
    $hashTable.l = @("l", "L", "1", "|", "!")
    $hashTable.L = @("l", "L", "1", "|", "!")
    $hashTable.o = @("o", "O", "0")
    $hashTable.O = @("o", "O", "0")
    $hashTable.s = @("s", "S", "5", "$")
    $hashTable.S = @("s", "S", "5", "$")
    $hashTable.t = @("t", "T", "7")
    $hashTable.T = @("t", "T", "7")

    if ($AllowNumericToAlphaConversion.IsPresent) {
        $hashTable.0 = @("o", "O", "0")
        $hashTable.1 = @("L", "l", "i", "I", "|", "!")
        $hashTable.3 = @("e", "E", "3")
        $hashTable.5 = @("s", "S", "5", "$")
        $hashTable.7 = @("t", "T", "7")
        $hashTable.8 = @("b", "B", "8")
    }

    if (-not $DisallowAlphaCaseChange.IsPresent) {
        $lowerAlpha = "abcdefghijklmnopqrstuvwxyz"
        $upperAlpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        for ($i = 0; $i -lt $lowerAlpha.length; $i++) { 
            if (-not $hashTable.ContainsKey($lowerAlpha[$i])) {
                $hashTable.Add($lowerAlpha[$i], @($lowerAlpha[$i], $upperAlpha[$i]))
            }
        }

        for ($i = 0; $i -lt $upperAlpha.length; $i++) { 
            if (-not $hashTable.ContainsKey($upperAlpha[$i])) {
                $hashTable.Add($upperAlpha[$i], @($upperAlpha[$i], $lowerAlpha[$i]))
            }
        }
    }

	$passwordified = ''

    $char = for ($i = 0; $i -lt $phrase.length; $i++) { 
        $passwordified = "$passwordified$(RandChar -Char $phrase[$i])"
    }

    Write-Host $passwordified

    if (-Not $NoClipboard.IsPresent) {
        $passwordified | Set-Clipboard

        Write-Host("passwordified phrase copied to clipboard")
    }
}

# uncomment to test
# Invoke-PasswordifyPhrase "SecureMyPassphraseAndMakeItAwesome" -DisallowConversionToSpecialCharacters