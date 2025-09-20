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


function Test-ADCredentials {
    [CmdletBinding()]
    param(
        [pscredential]$Credential
    )
     
    try {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        if (!$Credential) {
            $Credential = Get-Credential -EA Stop
        }
        if ($Credential.username.split("\").count -ne 2) {
            throw "You haven't entered credentials in DOMAIN\USERNAME format. Given value : $($Credential.Username)"
        }
     
        $DomainName = $Credential.username.Split("\")[0]
        $UserName = $Credential.username.Split("\")[1]
        $Password = $Credential.GetNetworkCredential().Password
     
        $PC = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $DomainName)
        if ($PC.ValidateCredentials($UserName, $Password)) {
            Write-Verbose "Credential validation successful for $($Credential.Username)"
            return $True
        }
        else {
            throw "Credential validation failed for $($Credential.Username)"
        }
    }
    catch {
        Write-Verbose "Error occurred while performing credential validation. $_"
        return $False
    }
}
