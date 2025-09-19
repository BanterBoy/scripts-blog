Function Get-FeaturesInventory {
	<#
		.SYNOPSIS
			Get-FeaturesInventory - This is a function to query AD for servers and then inventory the roles and features on each server.
		
		.DESCRIPTION
			This is a function to query AD for servers and then inventory the roles and features on each server.
		
		.PARAMETER SearchBase
			Distinguished name of Active Directory container where search for computer accounts for servers should begin.  Defaults to the entire domain of which the local computer is a member.
		
		.EXAMPLE
			PS C:\> Get-FeaturesInventory
		
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		- SearchBase [string]
		Distinguished name of Active Directory container where search for computer accounts for servers should begin.  Defaults to the entire domain of which the local computer is a member.
	
	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Get-AdDomain
		Get-WindowsFeature
		Write-Error
		Write-Output
	#>
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 0,
			HelpMessage = 'Enter the Name of the computer you would like to test.')]
		[Alias('cn')]
		[string[]]$ComputerName
	)
	Begin {
	}
	Process {
		ForEach ($Computer In $ComputerName) {
			$AdComputer = Get-ADComputer -Filter { Name -like $Computer } -Properties *
			$features = Get-WindowsFeature -ComputerName $AdComputer.DnsHostName | Where-Object -Property Installed -EQ $true
			ForEach ($feature In $features) {
				Try {
					$properties = [ordered]@{
						ComputerName    = $AdComputer.Name
						OperatingSystem = $AdComputer.OperatingSystem
						DnsHostName     = $AdComputer.DnsHostName
						IPv4Address     = $AdComputer.IPv4Address
						Date            = Get-Date
						FeatureName     = $feature.Name
						DisplayName     = $feature.DisplayName
						Description     = $feature.Description
						Installed       = $feature.Installed
						InstallDate     = $feature.InstallDate
						ADComputer      = $AdComputer.Name
					}
				}
				Catch {
					Write-Error "Error getting feature properties"
				}
				Finally {
					$obj = New-Object -TypeName PSObject -Property $properties
					Write-Output $obj
				}
			}
		}
	}
	End {
	}
}
