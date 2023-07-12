---
layout: post
title: Get-RDPUserReport.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
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
	[Alias()]
	[OutputType([String])]
	Param (
		# Given Name (Forename of User)
		[Parameter(Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ParameterSetName = 'ParameterSet1')]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[Alias('Computer', 'cn')]
		[OutputType([String])]
		[string[]]$ComputerName
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
					ServerName  = $Server
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
					ServerName  = $Server
				}
			}
			#Add the hash to $Sessions
			$Sessions.Add((New-Object PSObject -Property $tmpHash)) | Out-Null
		}
	}

	#Display the sessions
	$sessions
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-RDPUserReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDPUserReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
