function New-PSPasswordV2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)][Switch]$SkipUpperCase,
        [Parameter(Mandatory = $false)][Switch]$SkipLowerCase,
        [Parameter(Mandatory = $false)][Switch]$SkipNumbers,
        [Parameter(Mandatory = $false)][Switch]$SkipSymbols,
        [Parameter(Mandatory = $false)][Int]$PasswordLength = 16,
        [Parameter(Mandatory = $false)][Int]$NumberOfPasswords = 1,
        [Parameter(Mandatory = $false)][String]$PasswordsFilePath
    )
    
    begin {
        if ($SkipUpperCase.IsPresent -and $SkipLowerCase.IsPresent -and $SkipNumbers.IsPresent -and $SkipSymbols.IsPresent) {
            Write-Error "You may not skip all four types of characters at the same time, try again..."
            Exit
        }

        $CharArray = New-Object System.Collections.ArrayList
        $ValidatePass = New-Object System.Collections.ArrayList

        $LowerLetters = New-Object System.Collections.ArrayList; 97..122 | ForEach-Object { $LowerLetters.Add([Char]$_) } | Out-Null
        $UpperLetters = New-Object System.Collections.ArrayList; 65..90 | ForEach-Object { $UpperLetters.Add([Char]$_) } | Out-Null
        $Numbers = New-Object System.Collections.ArrayList; 0..9 | ForEach-Object { $Numbers.Add($_.ToString()) } | Out-Null
        $Symbols = New-Object System.Collections.ArrayList; 33..47 | ForEach-Object { $Symbols.Add([Char]$_) } | Out-Null

        if (!$SkipNumbers.IsPresent) { $CharArray.Add($Numbers) | Out-Null; $ValidatePass.Add(1) | Out-Null }
        if (!$SkipLowerCase.IsPresent) { $CharArray.Add($LowerLetters) | Out-Null; $ValidatePass.Add(2) | Out-Null }
        if (!$SkipUpperCase.IsPresent) { $CharArray.Add($UpperLetters) | Out-Null; $ValidatePass.Add(3) | Out-Null }
        if (!$SkipSymbols.IsPresent) { $CharArray.Add($Symbols) | Out-Null; $ValidatePass.Add(4) | Out-Null }

        $WorkingSet = $CharArray | ForEach-Object { $_ }
    }
    
    process {
        if ($PasswordsFilePath -and !(Test-Path $PasswordsFilePath)) {
            New-Item $PasswordsFilePath -ItemType File
        }

        for ($i = 0; $i -le $NumberOfPasswords; $i++) {
            $Password = New-Object System.Collections.ArrayList
            for ($y = 0; $y -le $PasswordLength; $y++) {
                $Character = $WorkingSet | Get-Random
                $Password.Add($Character) | Out-Null
            }

            Switch ($ValidatePass) {
                1 { if (!($Password -match '\d')) { $PassNotValid = $true } }
                2 { if (!($Password -cmatch "[a-z]")) { $PassNotValid = $true } }
                3 { if (!($Password -cmatch "[A-Z]")) { $PassNotValid = $true } }
                4 {
                    $Password | ForEach-Object { if ($Symbols -contains $_) { $ContainSymbol = $true } }
                    if ($ContainSymbol -eq $false) { $PassNotValid = $true }
                    $ContainSymbol = $false
                }
            }
            if ($PassNotValid -eq $true) { $i = $i - 1; $PassNotValid = $false; continue }else {
                $Password = $Password -join ""
                if ($PasswordsFilePath) { Add-Content -Path $PasswordsFilePath -Value $Password }else { Return $Password }
            }
        }
    }
    
    end {
        Write-Verbose -Message "Finishing function"
    }
}