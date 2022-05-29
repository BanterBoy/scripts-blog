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
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter the Distinguished name of the Active Directory container where search for server accounts should begin.')]
		[string]
		$SearchBase = (Get-AdDomain -Current LocalComputer).DistinguishedName
	)
	Begin {
	}
	Process {
		$AdComputer = Get-ADComputer -Filter { OperatingSystem -like '*Server*' } -SearchBase $SearchBase -Properties *
		ForEach ($Computer In $AdComputer) {
			$features = Get-WindowsFeature -ComputerName $Computer.DnsHostName | Where-Object -Property Installed -EQ $true
			ForEach ($feature In $features) {
				Try {
					$properties = [ordered]@{
						ComputerName    = $Computer.Name
						OperatingSystem = $Computer.OperatingSystem
						DnsHostName     = $Computer.DnsHostName
						IPv4Address     = $Computer.IPv4Address
						Date            = Get-Date
						FeatureName     = $feature.Name
						DisplayName     = $feature.DisplayName
						Description     = $feature.Description
						Installed       = $feature.Installed
						InstallDate     = $feature.InstallDate
						ADComputer      = $Computer.Name
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
