function Save-Password {
<# Example

.EXAMPLE
New-Item -Path C:\ -Name MyPasswords -ItemType Directory
. .\Functions\Save-Password.ps1
Save-Password -Label UserName
Save-Password -Label Password

#>
    param(
        [Parameter(Mandatory)]
        [string]$Label
    )

    $securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
    $securePassword | Out-File -FilePath "C:\MyPasswords\$Label.txt"
}

function Get-Password {
<#
.EXAMPLE
$user = Get-Password -Label UserName
$pass = Get-Password -Label password

.OUTPUT
$user | Format-List

.OUTPUT
Label           : UserName
EncryptedString : domain\administrator

.OUTPUT
$pass | Format-List
Label           : password
EncryptedString : SomeSecretPassword

.OUTPUT
$user.EncryptedString
domain\administrator

.OUTPUT
$pass.EncryptedString
SomeSecretPassword

#>
    param(
        [Parameter(Mandatory)]
        [string]$Label
    )

    $filePath = "C:\MyPasswords\$Label.txt"
    if (-not (Test-Path -Path $filePath)) {
        throw "The password with Label [$($Label)] was not found!"
    }

    $password = Get-Content -Path $filePath | ConvertTo-SecureString
    $decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    [pscustomobject]@{
        Label = $Label
        EncryptedString = $decPassword
    }
}

