Get-GPO -All | 
ForEach-Object { 
    $GPO = $_.DisplayName; $Perms = (
        Get-GPPermissions $GPO -All
    ).Trustee.Name; if (
        !($Perms.Contains(
                "Authenticated Users"
            )
        )
    ) {
        "$GPO" 
    } 
} |
Out-File GPOs.txt


Get-ADObject -LDAPFilter "(cn=*cnf:*)"
Get-ADObject -LDAPFilter "(sAMAccountName=$duplicate)"
