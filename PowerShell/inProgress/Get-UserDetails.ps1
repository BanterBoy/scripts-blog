function Get-UserDetails {
    [CmdletBinding()]
    param (
        [Parameter()]
        $AccountName,
        
        [Parameter()]
        [ValidateSet('MemberOf', 'AllDetails', 'Logon')]
        $Option
    )

    function Get-ADUserLastLogon([string]$userName) {
        $dcs = Get-ADDomainController -Filter { Name -like "*" }
        $time = 0
        foreach ($dc in $dcs) {
            $hostname = $dc.HostName
            $user = Get-ADUser $userName | Get-ADObject -Properties lastLogon
            if ($user.LastLogon -gt $time) {
                $time = $user.LastLogon
            }
        }
        $dt = [DateTime]::FromFileTime($time)
        Write-Host $username "last logged on at:" $dt "on" $hostname
    }

    switch ($Option) {
        AllDetails {
            $AllUsers = Get-ADUser -Filter { SamAccountName -like $AccountName } -Properties *
            ForEach ($User in $AllUsers) {
                Try {
                    $Properties = @{
                        BadLogonCount          =	$User.BadLogonCount
                        badPwdCount            =	$User.badPwdCount
                        carLicense             =	$User.carLicense
                        Created                =	$User.Created
                        Deleted                =	$User.Deleted
                        Description            =	$User.Description
                        DisplayName            =	$User.DisplayName
                        EmailAddress           =	$User.EmailAddress
                        Enabled                =	$User.Enabled
                        GivenName              =	$User.GivenName
                        isDeleted              =	$User.isDeleted
                        LastBadPasswordAttempt =	$User.LastBadPasswordAttempt
                        LastLogonDate          =	$User.LastLogonDate
                        LockedOut              =	$User.LockedOut
                        lockoutTime            =	$User.lockoutTime
                        Name                   =	$User.Name
                        PasswordExpired        =	$User.PasswordExpired
                        PasswordLastSet        =	$User.PasswordLastSet
                        PasswordNeverExpires   =	$User.PasswordNeverExpires
                        SamAccountName         =	$User.SamAccountName
                        SID                    =	$User.SID
                        Surname                =	$User.Surname
                        UserPrincipalName      =	$User.UserPrincipalName
                        whenChanged            =	$User.whenChanged
                        whenCreated            =	$User.whenCreated
                    }
                    $obj = New-Object -TypeName PSObject -Property $Properties
                    Write-Output $obj
                }
                catch {
                    Write-Warning "Failed with error: $_"
                }
            }
        }
        MemberOf {
            $AllUsers = Get-ADUser -Filter ' SamAccountName -like $AccountName ' -Properties * | Select-Object -Property MemberOf
            ForEach ($User in $AllUsers) {
                try {
                    Write-Output $User.MemberOf
                }
                catch {
                    Write-Warning "Failed with error: $_"
                }
            }
        }
        Logon {
            $AllUsers = Get-ADUser -Filter { SamAccountName -like $AccountName } -Properties *
            ForEach ($User in $AllUsers) {
                try {
                    Get-ADUserLastLogon -userName $User.SamAccountName
                    $Properties = @{
                        DisplayName            =	$User.DisplayName
                        SamAccountName         =	$User.SamAccountName
                        UserPrincipalName      =	$User.UserPrincipalName
                        carLicense             =	$User.carLicense
                        Enabled                =	$User.Enabled
                        LastBadPasswordAttempt =	$User.LastBadPasswordAttempt
                        LockedOut              =	$User.LockedOut
                        lockoutTime            =	$User.lockoutTime
                        PasswordExpired        =	$User.PasswordExpired
                        PasswordLastSet        =	$User.PasswordLastSet
                        PasswordNeverExpires   =	$User.PasswordNeverExpires
                    }
                    $obj = New-Object -TypeName PSObject -Property $Properties
                    Write-Output $obj
                }
                catch {
                    Write-Warning "Failed with error: $_"
                }
            }
        }
        Default {
            Write-Verbose -Message "You need to choose an option" -Verbose
        }
    }
}
