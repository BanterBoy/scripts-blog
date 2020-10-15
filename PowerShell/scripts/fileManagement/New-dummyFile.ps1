<#

File System Stress Test

All Versions

This can be used to generate  large files for stress test purposes, you don’t have to waste time pumping data
into a file to make it grow. Instead, simply set the desired file size to reserve the space on disk.
This creates a 1GB test file:



#>




# Create a secure string for the password
$Username = Read-Host "Enter Username"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username,$Password)

# Server Variable
$Server = Read-Host "Enter Server Name"

# Create Remote Session
Write-Host "Connecting to Server $Server"
Enter-PSSession -ComputerName $Server -Credential $Credentials
Wait-Event -Timeout 5
Clear-Host
Write-Host "You are PSRemoting to $Server"




# create a test file
$path = "$env:temp\dummyFile.txt"
$file = [System.IO.File]::Create($path)

# set the file size (file uses random content)
$file.SetLength(1gb)
$file.Close()

# view file properties
Get-Item $path
