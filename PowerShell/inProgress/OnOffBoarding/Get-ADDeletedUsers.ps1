Function Get-ADDeletedUsers {
	<#
		.SYNOPSIS
		Gives a list of all Restorable Users from the AD Recycle Bin.

		.EXAMPLE
		Get-ADDeletedUsers -DeletedObjectsContainer (Get-ADDomain).DeletedObjectsContainer
	#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][string]$DeletedObjectsContainer = (Get-ADDomain).DeletedObjectsContainer
    )
    Get-ADObject -SearchBase "$($DeletedObjectsContainer)" -IncludeDeletedObjects -filter * -Properties * |
    Where-Object { $_.ObjectClass -ne 'container' -and $_.ObjectClass -eq 'user' }
}
