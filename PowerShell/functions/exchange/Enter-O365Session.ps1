<#
Enter-O365Session.ps1
#>

# Create a secure string for the password
$Username = Read-Host "Enter Username"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credentials -Authentication Basic -AllowRedirection
Import-PSSession $Session

# Display Host Message
Write-Error -Message "You are now connected to Exchange 365" -Verbose
Write-Error -Message "Username:- $Username"

# Separate Command required to end the Session
# Get-PSSession | Remove-PSSession
