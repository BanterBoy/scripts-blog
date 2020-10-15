function Test-ADUserCredentials {
    [CmdletBinding()]
    param (
        [string]$username,
        [string]$password
    )
    
    begin {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    }
    
    process {
        $credentials = "$username" + "," + "$password"
        $account = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([ DirectoryServices.AccountManagement.ContextType]::Domain, $env:userdomain),
        $account.ValidateCredentials("$credentials")
    }
    
    end {
    }
}
