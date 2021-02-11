# Function	New-OnPremExchangeSession
function New-OnPremExchangeSession {
    $creds = Get-Credential
    $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
    Import-PSSession $OnPremSession -DisableNameChecking
}

# Import active directory module for running AD cmdlets
Import-Module activedirectory
New-OnPremExchangeSession

$CSVName = read-host "What do you want to call the output file?"

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv C:\powershell\bulk_users1.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers) {
    #Read user data from each field in each row and assign the data to a variable as below
		
    $Username = $User.username
    $Password = $User.password
    $Firstname = $User.firstname
    $Lastname = $User.lastname
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $Password = $User.Password

    If ($username -eq "") { break }

    Else { }

    #Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $Username }) {
        #If user does exist, give a warning
        Write-Warning "A user account with username $Username already exist in Active Directory."
         
    }
    else {
        #User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@ventrica.local" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Firstname $Lastname" `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
            
    }

    Add-ADGroupMember -Identity FortnumGrp $Username
    Add-ADGroupMember -Identity FortnumEmailGroup $Username

    $choice = ""
    while ($choice -notmatch "[y|n]") {
        Write-host "selected user is: $Username"
        $choice = read-host "Does this user need an Email Address? (Y/N)"
        
    }
    

    if ($choice -eq "y") {
        
        Enable-Mailbox $Username
    }      
    else { Write-host "No mailbox created for $Username" }

    # Write-Host "File Can be found here C:\Powershell\$CSVName.csv"
    $datecutoff = (get-date).AddDays(-1) 
    $mrusers = Get-ADUser -Filter * -SearchBase "OU=Pitch Test,OU=Test,OU=Ventrica,DC=ventrica,DC=local" -Properties * |
    Where-Object { $_.whenCreated -gt $datecutoff } 
        
        
        
        
}
$mrusers | Select-Object Name, SamAccountName, mail |
Export-CSV C:\Powershell\$CSVName.csv -Append
    
Write-Host $mrusers.count "users modified/created"
Write-Host "File Can be found here C:\Powershell\$CSVName.csv"