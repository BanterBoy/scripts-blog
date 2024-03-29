---
layout: post
title: Find-Movies.ps1
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
function Find-Movies
{
	<#
	.SYNOPSIS
		A function to search for files

	.DESCRIPTION
		A function to search for files.

		Searches are performed by passing the parameters to Get-Childitem which will then
		recursively search through your specified file path and then perform a sort to output
		the most recently amended files at the top of the list.

		Outputs inlcude the Name,DirectoryName and FullName

		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1

		If the extension is not provided it defaults to searching for PS1 files (PowerShell Scripts).

		Using the switch you can choose to search the start or end of the file or selecting wild,
		will perform a wildcard search using your searchterm.

	.PARAMETER Path
		Species the search path. The search will perform a recursive search on the specified folder path.

	.PARAMETER SearchTerm
		Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.

	.PARAMETER SearchType
		Specifies the type of search perfomed. Options are Start, End or Wild. This will search either the beginning, end or somewhere inbetween. If no option is selected, it will default to performing a wildcard search.

	.PARAMETER Extension
		Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg"

	.EXAMPLE
		Search-Scripts -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension .ps1

		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1

		Recursively scans the folder path looking for all files containing the searchterm and lists the files located in the output

	.OUTPUTS
		System.String. Search-Scripts returns a string with the extension or file name.

		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1

	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
		You can pipe objects to these perameters.

		- Path [string]
		- SearchTerm [string]
		- Extension [string]
		- SearchType [string]

	.LINK
		https://github.com/BanterBoy/scripts-blog
		Get-Childitem
		Select-Object
#>
	[CmdletBinding(DefaultParameterSetName = 'Default',
				   PositionalBinding = $true,
				   SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0,
				   HelpMessage = 'Enter the base path you would like to search.')]
		[ValidateNotNullOrEmpty()]
		[Alias('PSPath')]
		[string]$Path,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1,
				   HelpMessage = 'Enter the text you would like to search for.')]
		[ValidateNotNullOrEmpty()]
		[string]$SearchTerm,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 2,
				   HelpMessage = 'Select the type of search. You can select Start/End/Wild to perform search for a file.')]
		[ValidateSet('Start', 'End', 'Wild')]
		[string]$SearchType
	)
	BEGIN
	{
	}
	PROCESS
	{
		if ($PSCmdlet.ShouldProcess("$($Path)", "Searching for files"))
		{
			try
			{
				switch ($SearchType)
				{
					Start {
						Get-ChildItem -Path $Path -Filter "$SearchTerm*" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
					End {
						Get-ChildItem -Path $Path -Filter "*$SearchTerm" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
					Wild {
						Get-ChildItem -Path $Path -Filter "*$SearchTerm*" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
					Default {
						Get-ChildItem -Path $Path -Filter "*$SearchTerm*" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
				}
			}
			catch
			{
				Write-Error "Unable to locate files on path $Path"
			}
		}
	}
	END
	{
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Find-Movies.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Find-Movies.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
