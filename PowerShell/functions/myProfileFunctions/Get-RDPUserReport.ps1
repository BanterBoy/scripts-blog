function Get-RDPUserReport {
	<#
    .SYNOPSIS
        Function to extend the use of the QUser Command.

    .DESCRIPTION
		This function can be used to extend the use of the QUser Command in order to levy some addition automation. This command will query the Server/s specified and output the session details ( ID, SessionName,LogonTime, IdleTime, Username, State, ServerName).

		These details are output as objects and can therefore be manipulated to use with additional commands.

    .EXAMPLE
		Get-RDPUserReport -ComputerName DANTOOINE

		ID          : 2
		SessionName : rdp-tcp#7
		LogonTime   : 25/03/2020 01:49
		IdleTime    : 2:41
		Username    : administrator
		State       : Active
		ServerName  : DANTOOINE

    .EXAMPLE
        Get-RDPUserReport -ComputerName DANTOOINE | Sort-Object IdleTime | Format-Table -AutoSize

		ID SessionName LogonTime        IdleTime Username      State  ServerName
		-- ----------- ---------        -------- --------      -----  ----------
		2  rdp-tcp#7   25/03/2020 01:49 2:42     administrator Active DANTOOINE

	.NOTES
		Author:     Luke Leigh
		Website:    https://blog.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.LINK
		https://github.com/BanterBoy

#>

	[CmdletBinding(DefaultParameterSetName = 'ParameterSet1',
		SupportsShouldProcess = $false,
		PositionalBinding = $false,
		HelpUri = 'http://www.microsoft.com/',
		ConfirmImpact = 'Medium')]
	[Alias('RdpReport')]
	[OutputType([String])]
	Param (
        # Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName
	)
	
	#Initialize $Sessions which will contain all sessions
	[System.Collections.ArrayList]$Sessions = New-Object System.Collections.ArrayList($null)
	
	#Go through each server
	Foreach ($Computer in $ComputerName) {
		#Get the current sessions on $Server and also format the output
		$DirtyOuput = (quser /server:$Computer) -replace '\s{2,}', ',' | ConvertFrom-Csv
	
		#Go through each session in $DirtyOuput
		Foreach ($session in $DirtyOuput) {
			#Initialize a temporary hash where we will store the data
			$tmpHash = @{ }
	
			#Check if SESSIONNAME isn't like "console" and isn't like "rdp-tcp*"
			If (($session.sessionname -notlike "console") -AND ($session.sessionname -notlike "rdp-tcp*")) {
				#If the script is in here, the values are shifted and we need to match them correctly
				$tmpHash = @{
					Username    = $session.USERNAME
					SessionName = "" #Session name is empty in this case
					ID          = $session.SESSIONNAME
					State       = $session.ID
					IdleTime    = $session.STATE
					LogonTime   = $session."IDLE TIME"
					ServerName  = $Computer
				}
			}
			Else {
				#If the script is in here, it means that the values are correct
				$tmpHash = @{
					Username    = $session.USERNAME
					SessionName = $session.SESSIONNAME
					ID          = $session.ID
					State       = $session.STATE
					IdleTime    = $session."IDLE TIME"
					LogonTime   = $session."LOGON TIME"
					ServerName  = $Computer
				}
			}
			#Add the hash to $Sessions
			$Sessions.Add((New-Object PSObject -Property $tmpHash)) | Out-Null
		}
	}
	
	#Display the sessions
	$sessions
}
