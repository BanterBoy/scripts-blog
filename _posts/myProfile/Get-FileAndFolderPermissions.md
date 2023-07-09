---
layout: post
title: Get-FileAndFolderPermissions.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
Function Get-FileAndFolderPermissions {
	<#
		.SYNOPSIS
			Get-FileAndFolderPermissions can be used to extract file or folder permissions for a given path.

		.DESCRIPTION
			Get-FileAndFolderPermissions can be used to extract file or folder permissions for a given path. You can choose between 'File' or 'Folder' permissions and you can choose whether or not to recurse through the folder structure of the given path.

		.PARAMETER SourcePath
			Enter the path for the folder that you would like to extract the permissions.

		.PARAMETER FileFolder
			Specify whether you would like to get 'File' or 'Folder' permissions. The Default is Folder permissions.

		.PARAMETER Recurse
			 Specify whether you would like to recurse the folder structure for permissions. The Default is disabled.

		.PARAMETER Extension
			Specifies the extension. The Default is '.*'

			You can tab complete through the suggested list of extensions.

			'.AIFF', '.AIF', '.AU', '.AVI', '.BAT', '.BMP', '.CHM', '.CLASS', '.CONFIG', '.CSS', '.CSV', '.CVS', '.DBF', '.DIF', '.DOC', '.DOCX', '.DLL', '.DOTX', '.EPS', '.EXE', '.FM3', '.GIF', '.HQX', '.HTM', '.HTML', '.ICO', '.INF', '.INI', '.JAVA', '.JPG', '.JPEG', '.JSON', '.LOG', '.MD', '.MP4', '.MAC', '.MAP', '.MDB', '.MID', '.MIDI', '.MKV', '.MOV', '.QT', '.MTB', '.MTW', '.PDB', '.PDF', '.P65', '.PNG', '.PPT', '.PPTX', '.PSD', '.PSP', '.PS1', '.PSD1', '.PSM1', '.QXD', '.RA', '.RTF', '.SIT', '.SVG', '.TAR', '.TIF', '.T65', '.TXT', '.VBS', '.VSDX', '.WAV', '.WK3', '.WKS', '.WPD', '.WP5', '.XLS', '.XLSX', '.XML', '.YML', '.ZIP', '.*'

			'.AIFF or .AIF'	Audio Interchange File Format
			'.AU'	Basic Audio
			'.AVI'	Multimedia Audio/Video
			'.BAT'	PC batch file
			'.BMP'	Windows BitMap
			'.CLASS' or .JAVA	Java files
			'.CSV'	Comma separated, variable length file (Open in Excel)
			'.CVS'	Canvas
			'.DBF'	dbase II, III, IV data
			'.DIF'	Data Interchange format
			'.DOC or .DOCX'	Microsoft Word for Windows/Word97
			'.EPS'	Encapsulated PostScript
			'.EXE'	PC Application
			'.FM3'	Filemaker Pro databases (the numbers following represent the version #)
			'.GIF'	Graphics Interchange Format
			'.HQX'	Macintosh BinHex
			'.HTM or .HTML'	Web page source text
			'.JPG or JPEG'	JPEG graphic
			'.MAC'	MacPaint
			'.MAP'	Web page imagemap
			'.MDB'	MS Access database
			'.MID or .MIDI'	MIDI sound
			'.MKV'    Matroska video
			'.MOV or .QT'	QuickTime Audio/Video
			'.MTB or .MTW'	MiniTab
			'.PDF'	Acrobat -Portable document format
			'.P65'
			'.T65'	PageMaker (the numbers following represent the version #) P=publication, T=template
			'.PNG'	Portable Network Graphics
			'.PPT or .PPTX'	PowerPoint
			'.PSD'	Adobe PhotoShop
			'.PSP'	PaintShop Pro
			'.QXD'	QuarkXPress
			'.RA'	RealAudio
			'.RTF'	Rich Text Format
			'.SIT'	Stuffit Compressed Archive
			'.TAR'	UNIX TAR Compressed Archive
			'.TIF'	TIFF graphic
			'.TXT'	ASCII text (Mac text does not contain line feeds--use DOS Washer Utility to fix)
			'.WAV'	Windows sound
			'.WK3'	Lotus 1-2-3 (the numbers following represent the version #)
			'.WKS'	MS Works
			'WPD or .WP5'	WordPerfect (the numbers following represent the version #)
			'.XLS or .XLSX'	Excel spreadsheet
			'.ZIP'	PC Zip Compressed Archive

		.INPUTS
			You can pipe objects to these perameters.
			[string] SourcePath
			[string] FileFolder
			[string] Recurse
			[string] Extension

		.OUTPUTS
			object

		.EXAMPLE
			Get-FileAndFolderPermissions

		.EXAMPLE
			Get-FileAndFolderPermissions -SourcePath C:\

		.EXAMPLE
			Get-FileAndFolderPermissions -SourcePath C:\ -Recurse true

		.NOTES
			Author:	Luke Leigh
			Website:	https://scripts.lukeleigh.com/
			LinkedIn:	https://www.linkedin.com/in/lukeleigh/
			GitHub:	https://github.com/BanterBoy/scripts-blog
			GitHubGist:	https://gist.github.com/BanterBoy

		.LINK
			Get-Childitem
			Get-Acl
			New-Object
			Where-Object
			ForEach-Object
			Write-Warning
			Write-Output
	#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[Alias('GFPR')]
	[OutputType([object], ParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 1,
			HelpMessage = 'Enter the directory string that you want to search. Default is the current directory.')]
		[Alias('sp')]
		[String]$SourcePath = ".",

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true,
			Position = 2,
			HelpMessage = 'Specify whether you want to search for files or folders. Default is folders.')]
		[ValidateSet('File', 'Folder')]
		[Alias('ff')]
		[string]$FileFolder = 'Folder',

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true,
			Position = 3,
			HelpMessage = 'When enabled, this will recurse through all the subfolders. Default is disabled.')]
		[ValidateSet('true', 'false')]
		[Alias('rec')]
		[string]$Recurse = 'false',

		[Parameter(
			Mandatory = $false,
			Position = 4,
			ParameterSetName = "Default",
			ValueFromPipelineByPropertyName,
			HelpMessage = "Select the file extension you are looking for. Defaults to '*.*' files.")]
		[ValidateSet('.AIFF', '.AIF', '.AU', '.AVI', '.BAT', '.BMP', '.CHM', '.CLASS', '.CONFIG', '.CSS', '.CSV', '.CVS', '.DBF', '.DIF', '.DOC', '.DOCX', '.DLL', '.DOTX', '.EPS', '.EXE', '.FM3', '.GIF', '.HQX', '.HTM', '.HTML', '.ICO', '.INF', '.INI', '.JAVA', '.JPG', '.JPEG', '.JSON', '.LOG', '.MD', '.MP4', '.MAC', '.MAP', '.MDB', '.MID', '.MIDI', '.MKV', '.MOV', '.QT', '.MTB', '.MTW', '.PDB', '.PDF', '.P65', '.PNG', '.PPT', '.PPTX', '.PSD', '.PSP', '.PS1', '.PSD1', '.PSM1', '.QXD', '.RA', '.RTF', '.SIT', '.SVG', '.TAR', '.TIF', '.T65', '.TXT', '.VBS', '.VSDX', '.WAV', '.WK3', '.WKS', '.WPD', '.WP5', '.XLS', '.XLSX', '.XML', '.YML', '.ZIP', '.*') ]
		[string]$Extension = '.*'
	)

	Begin {
	}

	Process {
		Switch ($Recurse) {
			true {
				If ($pscmdlet.ShouldProcess("$SourcePath", "Extracting for permissions")) {
					if ($FileFolder -eq 'File') {
						$fileType = '*' + $Extension
						$Search = Get-ChildItem $SourcePath -Recurse | Where-Object {
							($_.psiscontainer -eq $false) -And ($_.FullName -Like $fileType)
						}
					}
					ElseIf ($FileFolder -eq 'Folder') {
						$Search = Get-ChildItem $SourcePath | Where-Object {
							$_.psiscontainer -eq $true
						}
					}
					ForEach ($item In $Search) {
						$ACLs = Get-Acl $item.fullname | ForEach-Object {
							$_.Access
						}
						Try {
							ForEach ($ACL In $ACLs) {
								$OutInfo = @{
									Fullname          = $item.Fullname
									IdentityReference = $ACL.IdentityReference
									AccessControlType = $ACL.AccessControlType
									IsInherited       = $ACL.IsInherited
									InheritanceFlags  = $ACL.InheritanceFlags
									PropagationFlags  = $ACL.PropagationFlags
								}
								$obj = New-Object -TypeName PSObject -Property $OutInfo
								Write-Output $obj
							}
						}
						Catch {
							Write-Warning "$_"
						}
					}
				}
			}
			false {
				If ($pscmdlet.ShouldProcess("$SourcePath", "Extracting for permissions")) {
					if ($FileFolder = 'File') {
						$fileType = '*' + $Extension
						$Search = Get-ChildItem $SourcePath -Recurse | Where-Object {
							($_.psiscontainer -eq $false) -And ($_.FullName -Like $fileType)
						}
					}
					ElseIf ($FileFolder -eq 'Folder') {
						$Search = Get-ChildItem $SourcePath | Where-Object {
							$_.psiscontainer -eq $true
						}
					}
					ForEach ($item In $Search) {
						$ACLs = Get-Acl $item.fullname | ForEach-Object {
							$_.Access
						}
						Try {
							ForEach ($ACL In $ACLs) {
								$OutInfo = @{
									Fullname          = $item.Fullname
									IdentityReference = $ACL.IdentityReference
									AccessControlType = $ACL.AccessControlType
									IsInherited       = $ACL.IsInherited
									InheritanceFlags  = $ACL.InheritanceFlags
									PropagationFlags  = $ACL.PropagationFlags
								}
								$obj = New-Object -TypeName PSObject -Property $OutInfo
								Write-Output $obj
							}
						}
						Catch {
							Write-Warning "$_"
						}
					}
				}
			}
			Default {
				If ($pscmdlet.ShouldProcess("$SourcePath", "Extracting for permissions")) {
					if ($FileFolder = 'File') {
						$fileType = '*' + $Extension
						$Search = Get-ChildItem $SourcePath -Recurse | Where-Object {
							($_.psiscontainer -eq $false) -And ($_.FullName -Like $fileType)
						}
					}
					ElseIf ($FileFolder -eq 'Folder') {
						$Search = Get-ChildItem $SourcePath | Where-Object {
							$_.psiscontainer -eq $true
						}
					}
					ForEach ($item In $Search) {
						$ACLs = Get-Acl $Folder.FullName | ForEach-Object {
							$_.Access
						}
						Try {
							ForEach ($ACL In $ACLs) {
								$OutInfo = @{
									Fullname          = $Folder.Fullname
									IdentityReference = $ACL.IdentityReference
									AccessControlType = $ACL.AccessControlType
									IsInherited       = $ACL.IsInherited
									InheritanceFlags  = $ACL.InheritanceFlags
									PropagationFlags  = $ACL.PropagationFlags
								}
								$obj = New-Object -TypeName PSObject -Property $OutInfo
								Write-Output $obj
							}
						}
						Catch {
							Write-Warning "$_"
						}
					}
				}
			}
		}
	}

	End {
		Write-Verbose "Search for files completed."
	}

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-FileAndFolderPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FileAndFolderPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
