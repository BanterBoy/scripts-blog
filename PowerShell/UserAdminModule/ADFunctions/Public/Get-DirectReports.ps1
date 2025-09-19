function Get-DirectReports {

	<#
	.SYNOPSIS
		A brief description of the Get-DirectReports function.
	
	.DESCRIPTION
		A detailed description of the Get-DirectReports function.
	
	.PARAMETER Identity
		The SamAccountName of the Manager.
	
	.EXAMPLE
		PS C:\> Get-DirectReports -EmployeeID 'Value1'
	
	.OUTPUTS
		string
	
	.NOTES
		Additional information about the function.
	#>
	
	[OutputType([string], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter the SamAccountName for the Manager whose direct reports you would like to view.')]
		[ValidateNotNullOrEmpty()]
		[string]$Identity
	)
	
	Function Get-Reports {
		[cmdletbinding()]
		Param (
			[Parameter(Position = 0, ValueFromPipelineByPropertyName = $True)]
			[string]$DistinguishedName,
			[int]$Tab = 2
		)
		
		Process {
			$direct = Get-ADUser -Identity $DistinguishedName -Properties DirectReports
			
			if ($direct.DirectReports) {
				$direct.DirectReports | Get-ADUser -Properties Title | ForEach-Object {
					"{0} [{1}]" -f $_.Name.padleft($_.name.length + $tab), $_.title
					$_ | Get-Reports -Tab $($tab + 2)
				}
			}
			
		} #process
		
	} #end function
	
	$user = Get-ADUser $Identity -Properties DirectReports, Title
	$reports = $user.DirectReports
	
	"{0} [{1}]" -f $User.name, $User.Title
	
	foreach ($report in $reports) {
		$direct = $report | Get-ADUser -Properties DirectReports, Title, Department
		"{0} [{1}]" -f $direct.name.padleft($direct.name.length + 1, ">"), $direct.Title
		$direct | Get-Reports
	} #foreach
}
