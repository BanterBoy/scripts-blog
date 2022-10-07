---
layout: post
title: New-Shell.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function New-Shell {

	<#
		.Synopsis
			Starts an Elevated PowerShell Console.

		.Description
			Opens a new PowerShell Console Elevated as Administrator. If the user is already running an elevated
			administrator shell, a message is displayed in the console session.
		.PARAMETER User
			A description of the User parameter. Brief explanation of the parameter and its requirements/function

		.PARAMETER RunAs
			A description of the RunAs parameter. Brief explanation of the parameter and its requirements/function

		.PARAMETER RunAsUser
			A description of the RunAsUser parameter. Brief explanation of the parameter and its requirements/function

		.PARAMETER Credentials
			A description of the Credentials parameter. Brief explanation of the parameter and its requirements/function

		.EXAMPLE
			PS C:\> New-Shell -RunAs PowerShellRunAs
			Launch PowerShell a new elevated Shell as current user.
		.EXAMPLE
			PS C:\> New-Shell -RunAsUser PowerShellRunAsUser -Credentials (Get-Credential)
			Launch PowerShell a new Shell as specified user.
		.NOTES
			Additional information about the function.
	#>

	[CmdletBinding(DefaultParameterSetName = 'User')]
	param
	(
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'User',
				   Mandatory = $false,
				   Position = 0,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShell', 'pwsh')]
		[string]
		$User,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAs',
				   Mandatory = $false,
				   Position = 0,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShellRunAs', 'pwshRunAs')]
		[string]
		$RunAs,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAsUser',
				   Mandatory = $false,
				   Position = 1,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[ValidateSet ('PowerShellRunAsUser', 'pwshRunAsUser')]
		[string]
		$RunAsUser,
		# Brief explanation of the parameter and its requirements/function
		[Parameter(ParameterSetName = 'RunAsUser',
				   Mandatory = $true,
				   Position = 2,
				   HelpMessage = 'Brief explanation of the parameter and its requirements/function')]
		[pscredential]
		$Credentials

	)

	switch ($User)
	{
		PowerShell {
			Start-Process -FilePath:"PowerShell.exe" -PassThru:$true
		}
		pwsh {
			Start-Process -FilePath:"pwsh.exe" -PassThru:$true
		}
	}
	switch ($RunAs)
	{
		PowerShellRunAs {
			Start-Process -FilePath:"PowerShell.exe" -Verb:RunAs -PassThru:$true
		}
		pwshRunAs {
			Start-Process -FilePath:"pwsh.exe" -Verb:RunAs -PassThru:$true
		}
	}
	switch ($RunAsUser)
	{
		PowerShellRunAsUser {
			Start-Process -Credential:$Credentials -FilePath:"PowerShell.exe" -LoadUserProfile:$true -UseNewEnvironment:$true -ArgumentList @("-Mta")
		}
		pwshRunAsUser {
			Start-Process -Credential:$Credentials -FilePath:"pwsh.exe" -LoadUserProfile:$true -UseNewEnvironment:$true -ArgumentList @("-Mta")
		}
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/New-Shell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Shell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
