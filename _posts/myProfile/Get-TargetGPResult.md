---
layout: post
title: Get-TargetGPResult.ps1
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-TargetGPResult.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TargetGPResult.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
