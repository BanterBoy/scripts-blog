function Lock-UserAccount {

    <#
    .SYNOPSIS
    Lock AD User Account.
    
    .DESCRIPTION
    This function will lock a user account in Active Directory.
    
    .PARAMETER SamAccountName
    The SamAccountName of the user account to be locked.
    
    .NOTES
    The user account running this function, needs to have 'Domain Admin Privileges' in order to lock the account.
    
    .EXAMPLE
    Lock-UserAccount -SamAccountName "jdoe"
    
    #>
    
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SamAccountName
    )
    begin {
        Write-Verbose "Locking user account '$SamAccountName'..."
    }
    process {
        if ($PSCmdlet.ShouldProcess("$SamAccountName", "Locking user account")) {
            $user = Get-ADUser -Identity $SamAccountName
            if ($user) {
                Set-ADAccountLockout -Identity $user.DistinguishedName -LockoutTime ([timespan]::MaxValue).Days -Confirm:$false
                Write-Output "User account '$SamAccountName' has been locked."
            }
            else {
                Write-Error "User account '$SamAccountName' not found."
            }
        }
    }
    end {
    }
}
