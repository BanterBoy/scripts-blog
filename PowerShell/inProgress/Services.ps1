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


$Computers = Get-ADComputer -Filter "Name -like '*'"
ForEach ($Computer in $Computers) {
    Get-CimInstance -ComputerName $Computer.Name -Class Win32_PingStatus -Filter ("Address='$_'") |
    Select-Object -Property PSComputerName, Address, IPV4Address, ResponseTime, StatusCode
}

$Computers = 'DANTOOINE', 'AGAMAR', $ENV:COMPUTERNAME, 'localhost', 'bing.com', 'blog.lukeleigh.com', 'me.lukeleigh.com'
ForEach ($Computer in $Computers) {
    $Results = Get-CimInstance -ComputerName $Computer -Class Win32_PingStatus -Filter ("Address='$_'")
    foreach ($Result in $Results) {
        $Properties = @{
            DNSName      = $Result.PSComputerName
            Address      = $Result.Address
            IPV4Address  = $Result.IPV4Address
            ResponseTime = $Result.ResponseTime
            StatusCode   = $Result.StatusCode
        }
        Write-Output -InputObject $Properties
    }
}
