<#
.SYNOPSIS
    Generates a secure password with specified complexity requirements.

.DESCRIPTION
    This function generates a secure password of a specified length with a minimum number of uppercase letters, lowercase letters, digits, and special characters.

.PARAMETER length
    The total length of the generated password. Default is 12.

.PARAMETER minUpperCase
    The minimum number of uppercase letters in the generated password. Default is 1.

.PARAMETER minLowerCase
    The minimum number of lowercase letters in the generated password. Default is 1.

.PARAMETER minDigits
    The minimum number of digits in the generated password. Default is 1.

.PARAMETER minSpecialChars
    The minimum number of special characters in the generated password. Default is 1.

.EXAMPLE
    PS C:\> New-SecurePassword -length 16 -minUpperCase 2 -minLowerCase 2 -minDigits 2 -minSpecialChars 2 -Verbose
    Generates a secure password with a length of 16 characters, including at least 2 uppercase letters, 2 lowercase letters, 2 digits, and 2 special characters.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function New-SecurePassword {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$length = 12,

        [Parameter(Mandatory = $false)]
        [int]$minUpperCase = 1,

        [Parameter(Mandatory = $false)]
        [int]$minLowerCase = 1,

        [Parameter(Mandatory = $false)]
        [int]$minDigits = 1,

        [Parameter(Mandatory = $false)]
        [int]$minSpecialChars = 1
    )

    begin {
        Write-Verbose "Starting password generation with length $length and minimum requirements: UpperCase=$minUpperCase, LowerCase=$minLowerCase, Digits=$minDigits, SpecialChars=$minSpecialChars"

        # Check if the total minimum character requirements exceed the specified length
        if ($length -lt ($minUpperCase + $minLowerCase + $minDigits + $minSpecialChars)) {
            throw "The length of the password must be greater than or equal to the sum of the minimum number of uppercase, lowercase, digit, and special characters."
        }
    }

    process {
        # Define character sets
        $upperCase = 65..90 | ForEach-Object { [char]$_ }
        $lowerCase = 97..122 | ForEach-Object { [char]$_ }
        $digits = 48..57 | ForEach-Object { [char]$_ }
        $specialChars = "!@#$%&*()-=+[{]}|;:"

        Write-Verbose "Generating random characters from each character set"

        # Generate required characters from each set
        $passwordChars = @(
            ($upperCase | Get-Random -Count $minUpperCase)
            ($lowerCase | Get-Random -Count $minLowerCase)
            ($digits | Get-Random -Count $minDigits)
            ($specialChars.ToCharArray() | Get-Random -Count $minSpecialChars)
        ) + (($upperCase + $lowerCase + $digits + $specialChars.ToCharArray()) | Get-Random -Count ($length - $minUpperCase - $minLowerCase - $minDigits - $minSpecialChars))

        Write-Verbose "Randomizing the final password characters"
        
        # Join and randomize the final password characters
        $password = -join ($passwordChars | Get-Random -Count $length)

        Write-Verbose "Generated password: $password"
        return $password
    }

    end {}
}

# Example call to the function with verbose output
# New-SecurePassword -length 16 -minUpperCase 2 -minLowerCase 2 -minDigits 2 -minSpecialChars 2 -Verbose
