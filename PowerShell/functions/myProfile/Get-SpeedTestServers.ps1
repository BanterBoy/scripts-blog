function Get-SpeedTestServers {
    <#
		.SYNOPSIS
			Get-SpeedTestServers function is a function.
		
		.DESCRIPTION
			Get-SpeedTestServers function is a function.
		
		.PARAMETER Path
			A description of the Path parameter.
		
		.PARAMETER Format
			A description of the Format parameter.
		
		.PARAMETER selectionDetails
			A description of the selectionDetails parameter.
		
		.PARAMETER File
			A description of the File parameter.
		
		.EXAMPLE
			PS C:\> New-SpeedTest
		
		.NOTES
			Additional information about the function.
	#>
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true
    )]
    param
    (
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [bool]
        $File = $false,
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            Position = 0,
            HelpMessage = 'Brief explanation of the parameter and its requirements/function'
        )]
        [string]
        $Path = 'C:\Temp\'
    )

    BEGIN {
    }
    Process {
        if ($PSCmdlet.ShouldProcess("$Server", "Listing SpeedTest Server...")) {
            $Servers = .\ProfileFunctions\ProfileFunctions\speedtest.exe --servers --format json-pretty
            $Servers = $Servers | ConvertFrom-Json
            if ($File) {
                $ServerList = .\ProfileFunctions\ProfileFunctions\speedtest.exe --servers --format json-pretty
                $ServerList | Out-File -FilePath (  "$Path" + "\SpeedTestServers-" + [datetime]::Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".json") -Encoding utf8 -Force
            }
            foreach ($Server in $Servers.Servers) {
                Try {
                    $properties = @{
                        Id       = $Server.id
                        Host     = $Server.host
                        Port     = $Server.port
                        Name     = $Server.name
                        Location = $Server.location
                        Country  = $Server.country
                    }
                }
                Catch {
                    Write-Error 'Error getting properties'
                }
                Finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
    }
    END {
    }
}
