---
layout: post
title: Remove-RDPUserSession.ps1
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

**_@GitHub Copilot_** - This is a PowerShell script that is used to remove a user session from a remote desktop. The script is called Remove-RDPUserSession.ps1 and it is written by Luke Leigh. The script is well documented with comments that explain the purpose of the script, the author's information, and links to the author's website, LinkedIn, and GitHub.

The script uses the CmdletBinding attribute to define the default parameter set, confirm impact, and help URI. The script also uses the Alias attribute to define an alias for the cmdlet. The script defines two parameters: ComputerName and IdentityNo. The ComputerName parameter is used to specify the name, IP, or FQDN of the computer that the user session is running on. The IdentityNo parameter is used to specify the ID of the user session that needs to be removed.

The script uses the reset session command to remove the user session. The reset session command is executed with the IdentityNo and ComputerName parameters. The script is well written and easy to understand.

To improve the readability of the code, the author could consider adding more comments to explain the purpose of each section of the script. Additionally, the author could consider using more descriptive parameter names to make it easier for other developers to understand the purpose of each parameter. Finally, the author could consider adding error handling to the script to make it more robust.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure, here are some examples of how to use the script:

Example 1: Remove a user session with ID 2 from a computer named DANTOOINE

```
Remove-RDPUserSession -ComputerName DANTOOINE -ID 2
```

Example 2: Remove a user session with ID 3 from a computer with IP address 192.168.1.100

```
Remove-RDPUserSession -ComputerName 192.168.1.100 -ID 3
```

Example 3: Remove a user session with ID 4 from a computer with FQDN mycomputer.mydomain.com

```
Remove-RDPUserSession -ComputerName mycomputer.mydomain.com -ID 4
```

Note that you will need to have administrative privileges on the remote computer in order to remove a user session.

---

#### Script

```powershell
function Remove-RDPUserSession {
	<#
    .SYNOPSIS
        Function to extend the use of the QUser Command.

    .DESCRIPTION
		This function can be used to extend the use of the QUser Command in order to levy some addition automation. This command will query the Server/s specified and output the session details ( ID, SessionName,LogonTime, IdleTime, Username, State, ServerName).

		These details are output as objects and can therefore be manipulated to use with additional commands.

    .EXAMPLE
		Remove-RDPUserSession -ComputerName DANTOOINE -ID 2

		ID          : 2
		SessionName : rdp-tcp#7
		LogonTime   : 25/03/2020 01:49
		IdleTime    : 2:41
		Username    : administrator
		State       : Active
		ServerName  : DANTOOINE

	.NOTES
		Author:     Luke Leigh
		Website:    https://blog.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.LINK
		https://github.com/BanterBoy

#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
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
		[string]
		$ComputerName,

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter User ID for the Session you would like to shut down or pipe input.'
		)]
		[Alias('idn')]
		[string]$IdentityNo

	)

	reset session $IdentityNo /server:$ComputerName

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Remove-RDPUserSession.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-RDPUserSession.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
