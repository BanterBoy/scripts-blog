function Show-PSDrive {
	<#
    .SYNOPSIS
       Displays the details of all PowerShell drives.

    .DESCRIPTION
       The Show-PSDrive function retrieves all the PowerShell drives, sorts them by a specified property, and then displays them in a table format.

    .PARAMETER SortBy
       Specifies the property by which the PowerShell drives should be sorted.

    .EXAMPLE
       Show-PSDrive -SortBy "Name"
    #>
	param (
		[ValidateSet("Name", "Root", "Description", "MaximumSize", "Credential", "DisplayRoot", "Used", "Free", "CurrentLocation", "IsReady")]
		[string]$SortBy
	)

	try {
		$drives = Get-PSDrive

		if ($SortBy) {
			$drives = $drives | Sort-Object $SortBy
		}

		$drives = $drives | Select-Object Name, Root, Description, @{Name = 'Used'; Expression = { (Get-FriendlySize -Bytes $_.Used).FriendlySize } }, @{Name = 'Free'; Expression = { (Get-FriendlySize -Bytes $_.Free).FriendlySize } }, DisplayRoot

		$drives | Format-Table -AutoSize
	}
	catch {
		Write-Error "An error occurred: $_"
	}
}