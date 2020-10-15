function Test-UserExists {
    param([Parameter(Mandatory)]
        [string]
        $SAMAccountName
    )

    @(Get-ADUser -LDAPFilter "(samaccountname=$SAMAccountName)").Count -ne 0
}
