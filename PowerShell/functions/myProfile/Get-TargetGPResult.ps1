function Get-TargetGPResult {
	<#
	.SYNOPSIS
		A brief description of the Get-TargetGPResult function.
	
	.DESCRIPTION
		A detailed description of the Get-TargetGPResult function.
		
		This command line tool displays the Resultant Set of Policy (RSoP) information for a target user and computer.
		Parameter List:
		/S        system           Specifies the remote system to connect to.
		/SCOPE    scope            Specifies whether the user or the computer settings need to be displayed. Valid values: "USER", "COMPUTER".
		/USER     [domain\]user    Specifies the user name for which the RSoP data is to be displayed.
		/H        <filename>       Saves the report in HTML format at the location and with the file name specified by the <filename> parameter. (valid in Windows at least Vista SP1 and at least Windows Server 2008)
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER TargetUser
		A description of the TargetUser parameter.
	
	.PARAMETER Path
		A description of the Path parameter.
	
	.PARAMETER FileName
		A description of the FileName parameter.
	
	.EXAMPLE
		Get-TargetUserGPResult -ComputerName 'value1' -TargetUser 'value2'
	
	.EXAMPLE
		$Params = @{  ComputerName = COMPUTERNAME
		TargetUser = "UserName"
		Path = "D:\"
		FileName = "Test.html"
		}
		Get-TargetUserGPResult @params

	.OUTPUTS
		System.String
	
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
			Position = 0,
			HelpMessage = 'Enter the Name for the computer source')]
		[string[]]$ComputerName,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 1,
			HelpMessage = 'Enter the SamAccountName for the user')]
		[string]$TargetUser,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 2,
			HelpMessage = 'Enter the file path for the exported report')]
		[string]$Path = "C:\Temp\",
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			Position = 3,
			HelpMessage = 'Enter the filename for the report')]
		[string]$FileName = "GPReport.html",
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 4,
            HelpMessage = 'Enter the scope for the report')]
            [ValidateSet('USER', 'COMPUTER')]
        [string]$Scope = "USER"
	)
	
	Begin {
	}
	
	Process {
		ForEach ($Computer In $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$($Computer)", "Export GPResult for User: $($TargetUser)")) {
				try {
					$Date = (Get-Date).ToString("yyyyMMdd-HHmmss")
					GPRESULT /S $Computer /SCOPE $Scope /USER $TargetUser /H $Path\$Date-$Computer-$FileName
				}
				catch {
					Write-Error -Message "Error: $($_.Exception.Message)"
				}
				finally {
					Write-Verbose -Message "GPResult exported to $($Path)$($Date)-$($Computer)-$($FileName)"
				}
			}
		}
	}
	
	End {
	}
}
