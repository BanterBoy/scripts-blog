# Create a secure string for the password
$Username = Read-Host "Enter Username (domain\username)"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Server Variable
$Server = Read-Host "Enter Server (FQDN or IP)"

# Create Remote Session
Enter-PSSession -ComputerName $Server -Credential $Credentials -Authentication Negotiate
