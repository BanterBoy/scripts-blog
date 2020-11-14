$csvcontent = Import-CSV -Path C:\Users\Administrator\Downloads\NewDCusers.csv
foreach ($user in $csvcontent) {
    $userInfo = @{
        AccountPassword       = (ConvertTo-SecureString "PoPeYeDaSail0rM@@n!" -AsPlainText -Force)
        ChangePasswordAtLogon = $true
        Company               = ($user.Company)
        DisplayName           = "$($user.Firstname) $($user.Lastname)"
        Enabled               = $true
        MobilePhone           = ($user.MobilePhone)
        OfficePhone           = ($user.PhoneNumber)
        Name                  = "$($user.Firstname) $($user.Lastname)"
        SamAccountName        = ($user.SamAccountName)
        Title                 = ($user.Title)
        Path                  = "OU=Users,OU=UNIFY,DC=unify,DC=org,DC=au"
        State                 = ($user.StateOrProvince)
        GivenName             = ($user.FirstName)
        SurName               = ($user.LastName)
        UserPrincipalName     = "$($user.Lastname)$($user.Firstname.Substring(0,1))@UNIFY.org.au"
        Department            = ($user.Department)
        Description           = ($user.Description)
        Office                = ($user.Office)
        City                  = ($user.City)
        Fax                   = ($user.Fax)
        Initials              = ($user.Initials)
        LogonName             = ($user.LogonName)
        PostalCode            = ($user.PostalCode)
        StreetAddress         = ($user.StreetAddress)
        HomeDirectory         = ($user.HomeDirectory)
        HomeDrive             = ($user.HomeDrive)
    }
    New-ADUser @userInfo
}
