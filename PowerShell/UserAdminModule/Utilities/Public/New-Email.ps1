<#
	.SYNOPSIS
        Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.
	
	.DESCRIPTION        
		Generates a test email in the format abc+yyyyMMdd@xyz.com and adds the result to the clipboard.

		Formats available via parameters:

		- abc+yyyyMMdd@xyz.com					(no parameters)
		- abc+yyyyMMdd_HHmmss@xyz.com			(IncludeTime parameter)
		- abc+yyyyMMdd_SUFFIX@xyz.com			(Suffix parameter)
		- abc+yyyyMMdd_HHmmss_SUFFIX@xyz.com	(IncludeTime and Suffix parameters)
		- abc+SUFFIX@xyz.com					(NoDate and Suffix parameters)
		- abc+@xyz.com							(NoDateparameter)
	
	.PARAMETER Phrase
		Adds this string as a suffix to the email address, e.g. abc+yyyyMMdd_SUFFIX@xyz.com.
	
	.PARAMETER Email
		Email address to use.
	
	.PARAMETER NoClipboard
		If supplied the output will not be written to the clipboard.
	
	.PARAMETER NoDate
		If supplied the generated email will not contain the current date in yyyyMMdd format. Ignored if IncludeTime is supplied.
	
	.PARAMETER IncludeTime
		If supplied the generated email will add the time after the current date in yyyyMMdd_HHmmss format. Overrides NoDate parameter.
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_test@xyz.com
		New-Email -Suffix test
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com
		New-Email -Suffix test -IncludeTime
	
	.EXAMPLE
        Generates a new test email in the format abc+yyyyMMdd_HHmmss_test@xyz.com (IncludeTime overrides NoDate)
		New-Email -Suffix test -IncludeTime -NoDate
	
	.EXAMPLE
        Generates a new test email in the format abc+test@xyz.com
		New-Email -Suffix test -NoDate
	
	.OUTPUTS
		System.String. Awesome email.
	
	.NOTES
		Author: Rob Green
	
	.INPUTS
		You can pipe objects to these parameters.
		
		- Suffix [string]
#>
function New-Email {
	param (
		[Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0, HelpMessage = "Adds this string as a suffix to the email address, e.g. abc+yyyyMMdd_SUFFIX@xyz.com.")]
		[string]$Suffix,

		[Parameter(Mandatory = $false, Position = 1, HelpMessage = "Email address to use.")]
		# [ValidateSet (, "luke.leigh@gmail.com", "banterboy@gmail.com")]
		[string]$Email = "luke@leigh-services.com",
		
		[Parameter(Mandatory = $false, HelpMessage = "If supplied the output will not be written to the clipboard.")]
		[switch]$NoClipboard,

		[Parameter(Mandatory = $false, HelpMessage = "If supplied the generated email will not contain the current date in yyyyMMdd format. Ignored if IncludeTime is supplied.")]
		[switch]$NoDate,

		[Parameter(Mandatory = $false, HelpMessage = "If supplied the generated email will add the time after the current date in yyyyMMdd_HHmmss format. Overrides NoDate parameter.")]
		[switch]$IncludeTime
	)

	$parts = $Email.Split('@')

	# ascertain the date format to use
	$dateFormat = $IncludeTime.IsPresent ? "yyyyMMdd_HHmmss" : "yyyyMMdd"

	# generate the date string to be included in the output. IncludeTime overrides NoDate
	$date = $NoDate.IsPresent -and -not $IncludeTime.IsPresent ? "" : "$([System.DateTime]::Now.ToString($dateFormat))_"

	# ascertain whether a suffix should be added to the output
	$suffix = [String]::IsNullOrWhiteSpace($Suffix) ? "" : $Suffix

	# build the output email
	$email = "$($parts[0])+$($date)$($suffix)@$($parts[1])"

	if (-Not $NoClipboard.IsPresent) {
		$email | Set-Clipboard -PassThru

		Write-Host("Copied to clipboard")
	} 
	else {
		Write-Host $email
	}
}
