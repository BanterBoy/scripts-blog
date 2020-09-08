<#
.SYNOPSIS
	Produce a simple HTML report of all files in a folder, who the owner is
	and when the file was last written.
.DESCRIPTION
	Produce a simple HTML report of all files in a folder, who the owner is
	and when the file was last written.  You can specify if you want all sub-
	folders included in the report and also narrow the report to specific
	extensions if you want.
	
	Make sure to edit the $ReportPath in the parameters section to match your
	environment (if desired).

	**CAUTION** The bigger the directory structure the longer this script will
	run.  Be patient!
	
	Script inspired by a question on Spiceworks:
	http://community.spiceworks.com/topic/283850-how-to-find-out-who-is-putting-what-on-shared-drives
.PARAMETER Path
	Specify the path where you want the report to run
.PARAMETER FileExtension
	Specify the extension that you want to narrow your search to.  Do not include
	any wildcards.  IE  jpg, xls, etc.
.PARAMETER SubFolders
	Specify whether you want the report to include all sub-folders of the 
	path.  Must use $true or $false.
.PARAMETER ReportPath
	Specify where you want the html report to be stored.  Report will be called
	Get-FileOwner.html
.OUTPUTS
	Get-FileOwner.html in the specified report path ($ReportPath parameter).
.EXAMPLE
	.\Get-FileOwner.ps1 -path s:\accounting -ReportPath s:\it
	Will create a report of all files in s:\accounting, and all sub-folders and 
	place the HTML report in the s:\it folder.
.EXAMPLE
	.\Get-FileOwner.ps1 -path s:\accounting -SubFolders $false
	Will create a report of all files in the s:\accounting folder only and place
	the report in the default location, c:\utils.
.EXAMPLE
	.\Get-FileOwner.ps1 -path s:\accounting -FileExtension xls
	Will create a report of all xls files in s:\accounting and all sub-folders.
	HTML report will be saved in the default location, c:\utils
.NOTES
	Author:       Martin Pugh
	Twitter:      @thesurlyadm1n
	Spiceworks:   Martin9700
	Blog:         www.thesurlyadmin.com
	
	Changelog:
	   1.0        Initial release
.LINK
	http://community.spiceworks.com/scripts/show/1722-get-fileowner
.LINK
	http://community.spiceworks.com/topic/283850-how-to-find-out-who-is-putting-what-on-shared-drives
#>
Param (
	[Parameter(Mandatory=$true)]
	[string]$Path,
	[string]$FileExtension = "*",
	[bool]$SubFolders = $true,
	[string]$ReportPath = "c:\utils"
)

If ($SubFolders)
{	$SubFoldersText = "(including sub-folders)"
}
Else
{	$SubFoldersText = "(does <i>not</i> include sub-folders)"
}

$Header = @"
<style type='text/css'>
body { background-color:#DCDCDC;
}
table { border:1px solid gray;
  font:normal 12px verdana, arial, helvetica, sans-serif;
  border-collapse: collapse;
  padding-left:30px;
  padding-right:30px;
}
th { color:black;
  text-align:left;
  border: 1px solid black;
  font:normal 16px verdana, arial, helvetica, sans-serif;
  font-weight:bold;
  background-color: #6495ED;
  padding-left:6px;
  padding-right:6px;
}
td { border: 1px solid black;
  padding-left:6px;
  padding-right:6px;
}
</style>
<center>
<h1>Files by Owner</h1>
<h2>Path: $Path\*.$FileExtension $SubFoldersText</h2>
<br>
"@

If ($FileExtension -eq "*")
{	$GCIProperties = @{
		Path = $Path
		Recurse = $SubFolders
	}
}
Else
{	$GCIProperties = @{
		Path = "$Path\*"
		Include = "*.$FileExtension"
		Recurse = $SubFolders
	}
}

$Report = @()
Foreach ($File in (Get-ChildItem @GCIProperties | Where-Object { $_.PSisContainer -eq $false }))
{
	$Report += New-Object PSObject -Property @{
		Path = $File.FullName
		Size = "{0:N2} MB" -f ( $File.Length / 1mb )
		'Created on' = $File.CreationTime
		'Last Write Time' = $File.LastWriteTime
		Owner = (Get-Acl $File.FullName).Owner
	}
}

$Report | 
Select-Object Path,Size,'Created on','Last Write Time',Owner | 
Sort-Object Path | 
ConvertTo-Html -Head $Header | 
Out-File $ReportPath\Get-FileOwner.html

#This line will open your web browser and display the report.  Rem it out with a # if you don't want it to
Invoke-Item $ReportPath\Get-FileOwner.html