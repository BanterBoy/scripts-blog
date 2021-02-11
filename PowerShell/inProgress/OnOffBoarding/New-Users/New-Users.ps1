<#
This section contains all of the Functions required by this script.
#>

function New-Password {
    [CmdletBinding()]
    $AllProtocols = [Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    $password = Invoke-RestMethod -Uri 'https://www.passwordrandom.com/query?command=password&scheme=RRRRRRRRR!NNN'
    $password
}

<#
    OU Class
#>

enum OrgUnit {
    Accounts
    Directors
    IT
    Support
    Testing
}

class OUs {
    [string]$Accounts = "OU=Accounts,OU=Users,OU=Departments,DC=domain,DC=leigh-services,DC=com"
    [string]$Directors = "OU=Directors,OU=Users,OU=Departments,DC=domain,DC=leigh-services,DC=com"
    [string]$IT = "OU=IT,OU=Users,OU=Departments,DC=domain,DC=leigh-services,DC=com"
    [string]$Support = "OU=Support,OU=Users,OU=Departments,DC=domain,DC=leigh-services,DC=com"
    [string]$Testing = "OU=Testing,OU=Users,OU=Departments,DC=domain,DC=leigh-services,DC=com"
}


<#
    User Class
#>

class User {
    [string]$SamAccountName
    [string]$UserPrincipalName = "$Username@ventrica.co.uk"
    [string]$Name = "$Firstname $Lastname"
    [string]$GivenName = $Firstname
    [string]$Surname = $Lastname
    [string]$Enabled = $True
    [string]$DisplayName = "$Firstname $Lastname"
    [string]$Path = $OU
    [string]$AccountPassword = (New-Password)
    [bool]$ChangePasswordAtLogon = $True

    # Constructors

    User ([string]$SamAccountName,[string]$Username,[string]$Firstname,[string]$Lastname,[string]$GivenName,[string]$DisplayName,[string]$OU,[string]$AccountPassword,[string]$UserPrincipalName) {
        if ($User = Get-ADUser -Filter { SamAccountName -eq '$SamAccountName' } -Properties * -ErrorAction Stop) {
            Write-Verbose -Message "$SamAccountName already exists."
            $User | Out-File -FilePath "D:\GitRepos\OutPutFile.txt"
        }
        else {
            try {
                $ADUsers = Import-csv  $PSScriptRoot\bulk_users1.csv | ConvertFrom-Csv -Delimiter ','
                foreach ($User in $ADUsers) {
                    New-ADUser -SamAccountName $Username -UserPrincipalName $UserPrincipalName -Name "$Firstname $Lastname" -GivenName $Firstname -Surname $Lastname -Enabled $True -DisplayName "$Firstname $Lastname" -Path $OU -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -Force) -ChangePasswordAtLogon $True -ErrorAction Stop
                    $this.SamAccountName = $SamAccountName
                    $this.UserPrincipalName = $UserPrincipalName
                    $this.Name = "$Firstname $Lastname"
                    $this.GivenName = $Firstname
                    $this.Surname = $Lastname
                    $this.Enabled = $True
                    $this.DisplayName = "$Firstname $Lastname"
                    $this.Path = $OU
                    $this.AccountPassword = (New-Password)
                    $this.ChangePasswordAtLogon = $True
                }
            }
            catch {
                $_
            }
        }
    }
}



$OrgUnit = [OrgUnit]::Accounts
$OrgUnit
$OU = [OUs]::new().Accounts
$OU
$Password = New-Password
$Password

