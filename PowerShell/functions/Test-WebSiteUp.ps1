Function Test-WebsiteUp {
<#
	.SYNOPSIS
		Test-Website can be used to test if a website is responding.
	
	.DESCRIPTION
		Test-Website can be used to test if a website is responding.
	
	.PARAMETER webAddress
		Enter the website address (URL) of the site that you want to test.
	
	.EXAMPLE
				PS C:\> Test-WebsiteUp -webAddress 'Value1'
	
	.OUTPUTS
		object
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
				   PositionalBinding = $true,
				   SupportsShouldProcess = $true)]
	[OutputType([object], ParameterSetName = 'Default')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1,
				   HelpMessage = 'Please enter the URL to test.')]
		[Alias('url')]
		[string]$webAddress
	)
	
	Begin {
		$Protocol = [System.Net.SecurityProtocolType]'Tls12,Tls13'
		[System.Net.ServicePointManager]::SecurityProtocol = $Protocol
	}
	
	Process {
		If ($PSCmdlet.ShouldProcess("$webAddress", "Getting the website status")) {
			Try {
				If ($Test.StatusCode -eq '200') {
					$Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop -TimeoutSec 10
					$properties = @{
						Code = [int]$Test.StatusCode
						Status = [string]$Test.StatusDescription
						Website = [string]$webAddress
						Message = "Website Status"
					}
				}
				ElseIf ($Test.StatusCode -ne '200') {
					$Test = Invoke-WebRequest -Uri $webAddress -ErrorAction Stop -TimeoutSec 30
					$properties = @{
						Code = [int]$Test.StatusCode
						Status = [string]$Test.StatusDescription
						Website = [string]$webAddress
						Message = "Website Status"
					}
				}
			}
			Catch [System.Net.Http.HttpRequestException] {
				Write-Warning -Message "Website Unavailable"
			}
			Finally {
				$obj = New-Object -TypeName PSObject -Property $properties
				Write-Output $obj
			}
			
		}
	}
	End {
		Write-Verbose -Message "The WebSite '$webAddress' has been tested."
	}
}
