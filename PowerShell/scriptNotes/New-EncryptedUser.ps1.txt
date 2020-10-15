<#
Create Encrypted Password file
This file is tied to the creator and the machine
Can not be used elsewhere
#>

$Path = "$home\Desktop\"
$File = Read-Host "Enter Filename.xml"
$FilePath =  Join-Path -Path $Path -ChildPath $File

[PSCustomObject]@{
    User = Get-Credential -Message User
    } | Export-Clixml -Path $FilePath

	
<#
Example use

$encrypted = Import-Clixml -Path "FilePath"

$encrypted.User
#>
