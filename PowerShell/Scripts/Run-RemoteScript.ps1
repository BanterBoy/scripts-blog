# Create a secure string for the password
$Username = Read-Host "Enter Username (domain\username)"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Server Variable
$Server = Read-Host "Enter Server (FQDN or IP)"

Invoke-Command -ComputerName $Server -Credential $Credentials -Authentication Negotiate -FilePath "C:\Users\Luke Leigh\Documents\GitHub\PowerRepo\Scripts\SomeScriptFile.ps1"
