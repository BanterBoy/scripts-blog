---
layout: post
title: Remove-RDPUserSession.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-RDPUserSession/
categories:
- UserAdminModule
- RemoteConnections
tags:
- PowerShell
- User Admin Module
- RDP User Session
- RDP
description: Function to extend the use of the QUser Command.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Function to extend the use of the QUser Command.

#### Detailed Description

This function can be used to extend the use of the QUser Command in order to levy some addition automation. This command will query the Server/s specified and output the session details ( ID, SessionName,LogonTime, IdleTime, Username, State, ServerName).

These details are output as objects and can therefore be manipulated to use with additional commands.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-RDPUserSession -ComputerName DANTOOINE -ID 2
```

ID          : 2 SessionName : rdp-tcp#7 LogonTime   : 25/03/2020 01:49 IdleTime    : 2:41 Username    : administrator State       : Active ServerName  : DANTOOINE

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://blog.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
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

	[CmdletBinding(DefaultParameterSetName = 'ParameterSet1',
		SupportsShouldProcess = $false,
		PositionalBinding = $false,
		HelpUri = 'http://www.microsoft.com/',
		ConfirmImpact = 'Medium')]
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
		[string]$IdentityNo

	)
	
	reset session $IdentityNo /server:$ComputerName
	
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Remove-RDPUserSession.ps1')">
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

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

