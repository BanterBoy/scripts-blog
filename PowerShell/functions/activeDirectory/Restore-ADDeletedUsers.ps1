<#
    .SYNOPSIS
    Restores Users from the AD Recycle Bin.

    .PARAMETER Credential
    Elevated credentials to use.

    .PARAMETER UsertoRestore
    Username of the user to restore.

    .EXAMPLE
    Restore-ADDeletedUsers -Usertorestore ATest
#>

Function Restore-ADDeletedUsers {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $True)]
        [string]$usertorestore
    )
    Restore-ADObject -Credential $PSCredential -Confirm:$false -Identity $usertorestore
}
