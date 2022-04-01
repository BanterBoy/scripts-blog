Function Restore-ADDeletedUsers {
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
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $True)]$UsertoRestore
    )
    Restore-ADObject -Credential $PSCredential -Confirm:$false -Identity $UsertoRestore
}
