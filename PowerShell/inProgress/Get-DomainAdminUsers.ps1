function Get-DomainAdminUsers {
    [CmdletBinding()]
    $Groups = Get-ADGroup -Filter { Name -like 'Domain Admins' } | Get-ADGroupMember | Select-Object SamAccountName
    ForEach ($Group in $Groups) {
        $User = Get-ADUser -Identity $Group.SamAccountName -Properties * | Select-Object -Property *
        Try {
            $Properties = [ordered]@{
                AccountExpirationDate                = $User.AccountExpirationDate
                AccountLockoutTime                   = $User.AccountLockoutTime
                AccountNotDelegated                  = $User.AccountNotDelegated
                AllowReversiblePasswordEncryption    = $User.AllowReversiblePasswordEncryption
                BadLogonCount                        = $User.BadLogonCount
                badPasswordTime                      = $User.badPasswordTime
                badPwdCount                          = $User.badPwdCount
                CannotChangePassword                 = $User.CannotChangePassword
                carLicense                           = $User.carLicense
                City                                 = $User.City
                CN                                   = $User.CN
                codePage                             = $User.codePage
                Company                              = $User.Company
                Country                              = $User.Country
                countryCode                          = $User.countryCode
                Created                              = $User.Created
                Deleted                              = $User.Deleted
                Department                           = $User.Department
                Description                          = $User.Description
                DisplayName                          = $User.DisplayName
                DistinguishedName                    = $User.DistinguishedName
                Division                             = $User.Division
                EmailAddress                         = $User.EmailAddress
                EmployeeID                           = $User.EmployeeID
                EmployeeNumber                       = $User.EmployeeNumber
                Enabled                              = $User.Enabled
                Fax                                  = $User.Fax
                GivenName                            = $User.GivenName
                HomeDirectory                        = $User.HomeDirectory
                HomedirRequired                      = $User.HomedirRequired
                HomeDrive                            = $User.HomeDrive
                homeMDB                              = $User.homeMDB
                HomePage                             = $User.HomePage
                HomePhone                            = $User.HomePhone
                Initials                             = $User.Initials
                isDeleted                            = $User.isDeleted
                LastBadPasswordAttempt               = $User.LastBadPasswordAttempt
                LastKnownParent                      = $User.LastKnownParent
                LastLogonDate                        = $User.LastLogonDate
                legacyExchangeDN                     = $User.legacyExchangeDN
                LockedOut                            = $User.LockedOut
                lockoutTime                          = $User.lockoutTime
                logonCount                           = $User.logonCount
                LogonWorkstations                    = $User.LogonWorkstations
                mail                                 = $User.mail
                mailNickname                         = $User.mailNickname
                Manager                              = $User.Manager
                MemberOf                             = $User.MemberOf
                MobilePhone                          = $User.MobilePhone
                Modified                             = $User.Modified
                modifyTimeStamp                      = $User.modifyTimeStamp
                Name                                 = $User.Name
                Office                               = $User.Office
                OfficePhone                          = $User.OfficePhone
                Organization                         = $User.Organization
                otherMobile                          = $User.otherMobile
                OtherName                            = $User.OtherName
                PasswordExpired                      = $User.PasswordExpired
                PasswordNeverExpires                 = $User.PasswordNeverExpires
                PasswordNotRequired                  = $User.PasswordNotRequired
                POBox                                = $User.POBox
                PostalCode                           = $User.PostalCode
                PrimaryGroup                         = $User.PrimaryGroup
                PrincipalsAllowedToDelegateToAccount = $User.PrincipalsAllowedToDelegateToAccount
                ProfilePath                          = $User.ProfilePath
                ProtectedFromAccidentalDeletion      = $User.ProtectedFromAccidentalDeletion
                proxyAddresses                       = $User.proxyAddresses
                pwdLastSet                           = $User.pwdLastSet
                SamAccountName                       = $User.SamAccountName
                ScriptPath                           = $User.ScriptPath
                ServicePrincipalNames                = $User.ServicePrincipalNames
                showInAddressBook                    = $User.showInAddressBook
                SID                                  = $User.SID
                SmartcardLogonRequired               = $User.SmartcardLogonRequired
                sn                                   = $User.sn
                State                                = $User.State
                StreetAddress                        = $User.StreetAddress
                Surname                              = $User.Surname
                Title                                = $User.Title
                TrustedForDelegation                 = $User.TrustedForDelegation
                TrustedToAuthForDelegation           = $User.TrustedToAuthForDelegation
                userAccountControl                   = $User.userAccountControl
                UserPrincipalName                    = $User.UserPrincipalName
                whenChanged                          = $User.whenChanged
                whenCreated                          = $User.whenCreated
            }
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
        catch {
            Write-Warning "Failed with error: $_.Message"
        }
    }
}


