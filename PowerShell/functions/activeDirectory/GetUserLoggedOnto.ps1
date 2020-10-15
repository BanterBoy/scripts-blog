<#
http://powershell.com/cs/members/jagnagra/default.aspx
Queries a computer to check for interactive sessions
.EXAMPLE
.\GetUserLoggedOnto.ps1 -UserName <userid>
#>

[CmdletBinding()]
Param(
    [Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = (Get-ADComputer -filter {
						Enabled -eq $True} | Sort-Object name | Select-Object -expand Name),
	[Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
	[string]$username = 'username',
	[Parameter()]
	[string]
	$OutputDir = "\\fileserver\sharename"
)
begin
{
	$OutputFile = Join-Path $OutputDir "filename.csv"
	Write-Verbose "Script will write the output to $OutputFile folder"
	$ErrorActionPreference = 'Stop'
}
process {
    foreach ($Computer in $ComputerName) {
		If(!(Test-Connection -ComputerName $Computer -Count 1 -Quiet))
		{
			# Device is off
		}
		else
		{
		    try
			{
            quser /server:$Computer 2>&1 | Select-Object -Skip 1 | ForEach-Object {
                $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s'
                $HashProps = @{
                    UserName = $CurrentLine[0]
                    ComputerName = $Computer
                }

				# If session is disconnected different fields will be selected

				if ($currentline[0] -eq $username -and $CurrentLine[2] -eq 'Disc')
				{
					$HashProps.Id = $CurrentLine[1]
					$HashProps.State = $CurrentLine[2]
					$HashProps.IdleTime = $CurrentLine[3]
					$HashProps.LogonTime = $CurrentLine[4..6] -join ' '
					$HashProps.LogonTime = $CurrentLine[4..($CurrentLine.GetUpperBound(0))] -join ' '
					New-Object -TypeName PSCustomObject -Property $HashProps |
					Select-Object -Property UserName,ComputerName,State,ID,IdleTime,LogonTime
					Add-Content -Path $OutPutFile -Value "$Computer, $CurrentLine[1], State"
				}
				else
				{
                    $HashProps.SessionName = $CurrentLine[1]
                    $HashProps.Id = $CurrentLine[2]
                    $HashProps.State = $CurrentLine[3]
                    $HashProps.IdleTime = $CurrentLine[4]
                    $HashProps.LogonTime = $CurrentLine[5..($CurrentLine.GetUpperBound(0))] -join ' '
					New-Object -TypeName PSCustomObject -Property $HashProps |
					Select-Object -Property UserName,ComputerName,State,ID,IdleTime,LogonTime
					Add-Content -Path $OutPutFile -Value "$Computer, $CurrentLine[1], State"
                }
			}
		}
		catch {

		}
		finally{

		}
	}
}
}
end{

}
