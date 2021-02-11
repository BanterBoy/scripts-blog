$Servers = Get-ADComputer -LDAPFilter "(name=*)" -SearchBase "OU=Servers,DC=ventrica,DC=local"
foreach ( $Server in $Servers ) {
    Get-RemoteServiceAccount -ComputerName DC01 | Where-Object { ( $_.StartName -notmatch 'LocalSystem|^NT Authority' ) -and ( $_.StartName -like '*Administrator' ) }
}


function Get-DomainAdminUsers {
    $Groups = Get-ADGroup -Filter { Name -like 'Domain Admins' } | Get-ADGroupMember | Select-Object SamAccountName
    ForEach ($Group in $Groups) {
        $User = Get-ADUser -Identity $Group.SamAccountName -Properties *
        Try {
            $Properties = @{
                DisplayName          = $User.DisplayName
                SamAccountName       = $User.SamAccountName
                UserPrincipalName    = $User.UserPrincipalName
                LastLogonDate        = $User.LastLogonDate
                PasswordNeverExpires = $User.PasswordNeverExpires
                PasswordLastSet      = $User.PasswordLastSet
            }
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
        catch {
            Write-Warning "Failed with error: $_.Message"
        }
    }
}


Get-RemoteServiceAccount -ComputerName APP01 | Where-Object { ( $_.StartName -notmatch 'LocalSystem|^NT Authority' ) }

