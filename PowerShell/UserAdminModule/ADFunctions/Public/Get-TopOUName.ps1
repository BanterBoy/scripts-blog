function Get-TopOUName {
	<#
		.SYNOPSIS
			A brief description of the Get-TopOUName function.
		
		.DESCRIPTION
			A detailed description of the Get-TopOUName function.
		
		.PARAMETER DistinguishedName
			A description of the DistinguishedName parameter.
		
		.EXAMPLE
			PS C:\> Get-TopOUName -DistinguishedName 'value1'
		
		.OUTPUTS
			string
		
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 0,
			HelpMessage = 'A description of the DistinguishedName parameter.')]
		[string]
		$DistinguishedName
	)
	
	Begin {
		Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
		#ignore case
		$rx = [System.Text.RegularExpressions.Regex]::new("^(((CN=.*?))?)OU=(?<OUName>.*?(?=,))", "IgnoreCase")
	} #begin
	
	Process {
		if ($PSCmdlet.ShouldProcess("$($Month)" + "-" + "$($DistinguishedName)", "Processing")) {
			Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $DistinguishedName"
			If ($rx.IsMatch($DistinguishedName)) {
				$rx.Match($DistinguishedName).groups["OUName"].Value
			}
		} #process
	}
	End {
		Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
	} #end
}
