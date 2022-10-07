---
layout: post
title: Get-LatestFiles.ps1
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
function Get-LatestFiles {

	<#
	.SYNOPSIS
		Short function to find recently saved files.

	.DESCRIPTION
		Short function that can be used to find/locate recently saved files.

		Searches are performed by passing the parameters to Get-Childitem which will then
		recursively search through your specified file path and then perform a sort to output
		the most recently amended files at the top of the list.

		Outputs inlcude the Directory,Filename and LastWriteTime

	.PARAMETER DaysPast
		Enter the number of days in the past you would like to search.

	.PARAMETER Path
		Enter the file path that you would like to search.

	.PARAMETER Extention
		Select a file extension to select a specific file type.

	.EXAMPLE
		Get-LatestFiles -DaysPast 7 -Path 'C:\GitRepos\AdminToolkit\PowerShell' -FileType *.*

		Recursively scans the folder 'C:\GitRepos\AdminToolkit\PowerShell' looking for all files that have been
		amended in the last 7 days

	.OUTPUTS
		Directory                                  Name                LastWriteTime
		---------                                  ----                -------------
		C:\GitRepos\AdminToolkit\PowerShell\CmdLet Get-LatestFiles.ps1 02/02/2018 15:30:35

	.NOTES
		Author:     Luke Leigh
		Website:    https://admintoolkit.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		DaysPast [int]
		Path [string]
		FileType [string]

	.LINK
		https://github.com/BanterBoy/adminToolkit/wiki
	#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		SupportsShouldProcess = $true)]
	[OutputType([String], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			Position = 3,
			HelpMessage = 'Please enter the number of days.')]
		[ValidateNotNullOrEmpty()]
		[Alias('Days')]
		[int32]$DaysPast = 1,

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 1,
			HelpMessage = 'Please enter search file path.')]
		[ValidateNotNullOrEmpty()]
		[string]$Path = 'C:\GitRepos\',

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			Position = 2,
			HelpMessage = 'Please enter file extension.')]
		[ValidateSet('*.AIFF', '*.AIF', '*.AU', '*.AVI', '*.BAT', '*.BMP', '*.CHM', '*.CLASS', '*.CONFIG', '*.CSS', '*.CSV', '*.CVS', '*.DBF', '*.DIF', '*.DOC', '*.DOCX', '*.DLL', '*.DOTX', '*.EPS', '*.EXE', '*.FM3', '*.GIF', '*.HQX', '*.HTM', '*.HTML', '*.ICO', '*.INF', '*.INI', '*.JAVA', '*.JPG', '*.JPEG', '*.JSON', '*.LOG', '*.MD', '*.MP4', '*.MAC', '*.MAP', '*.MDB', '*.MID', '*.MIDI', '*.MOV', '*.QT', '*.MTB', '*.MTW', '*.PDB', '*.PDF', '*.P65', '*.PNG', '*.PPT', '*.PPTX', '*.PSD', '*.PSP', '*.PS1', '*.PSD1', '*.PSM1', '*.QXD', '*.RA', '*.RTF', '*.SIT', '*.SVG', '*.TAR', '*.TIF', '*.T65', '*.TXT', '*.VBS', '*.VSDX', '*.WAV', '*.WK3', '*.WKS', '*.WPD', '*.WP5', '*.XLS', '*.XLSX', '*.XML', '*.YML', '*.ZIP', '*.*') ]
		[Alias('Ext')]
		[string]$Extention = '*.*'
	)

	BEGIN { }

	PROCESS {

		if ($PSCmdlet.ShouldProcess("Target", "Operation")) {

			$Start = (Get-Date).AddDays(-$DaysPast)
			$Files = Get-ChildItem -Path $Path -Filter $Extention -Recurse | Where-Object { $_.LastWriteTime -ge $Start }
			foreach ($File in $Files) {
				$FileInfo = Select-Object -InputObject $File -Property Directory, Name, LastWriteTime
				try {
					$properties = @{
						Name          = $FileInfo.Name
						Directory     = $FileInfo.Directory
						LastWriteTime = $FileInfo.LastWriteTime
					}
				}
				catch {
					$properties = @{
						Name          = $FileInfo.Name
						Directory     = $FileInfo.Directory
						LastWriteTime = $FileInfo.LastWriteTime
					}
				}
				finally {
					$obj = New-Object -TypeName PSObject -Property $properties
					Write-Output $obj
				}
			}
		}
	}

	END { }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-LatestFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LatestFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
