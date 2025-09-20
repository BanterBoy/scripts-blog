---
layout: post
title: Get-EventsFromTimeframe.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-EventsFromTimeframe/
categories:
  - UserAdminModule
  - Logging
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

This script searches a Windows computer for all event log or text log entries between a specified start and end time.

#### Detailed Description

This script enumerates all event logs within a specified timeframe and all text logs that have a last write time in the timeframe or contains a line that has a date/time reference within the timeframe.  It records this information to a set of files and copies any interesting log file off for further analysis.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-EventsFromTimeframe -StartTimestamp '01-29-2014 13:25:00' -EndTimeStamp '01-29-2014 13:28:00' -ComputerName COMPUTERNAME
```

This example finds all event log entries between StartTimestamp and EndTimestamp and any file with an extension inside the $FileExtension param that either was last written within the timeframe or contains a line with a date/time reference within the timeframe.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-EventsFromTimeframe {

	<#
		.SYNOPSIS
		This script searches a Windows computer for all event log or text log entries between a specified start and end time.
		
		.DESCRIPTION
		This script enumerates all event logs within a specified timeframe and all text logs that have a last write time in the timeframe or contains a line that has a date/time reference within the timeframe.  It records this information to a set of files and copies
		any interesting log file off for further analysis.
		
		.EXAMPLE
		Get-EventsFromTimeframe -StartTimestamp '01-29-2014 13:25:00' -EndTimeStamp '01-29-2014 13:28:00' -ComputerName COMPUTERNAME
		
		This example finds all event log entries between StartTimestamp and EndTimestamp and any file with an extension inside the $FileExtension param that either was last written within the timeframe or contains a line with a date/time reference within the timeframe.
		
		.PARAMETER StartTimestamp
		The earliest date/time you'd like to begin searching for events.
		
		.PARAMETER EndTimestamp
		The latest date/time you'd like to begin searching for events.
		
		.PARAMETER Computername
		The name of the remote (or local) computer you'd like to search on.
		
		.PARAMETER OutputFolderPath
		The path of the folder that will contain the text files that will contain the events.
		
		.PARAMETER LogAuditFilPath
		The path to the text file that will document the log file, line number and match type to the logs that were matched.
		
		.PARAMETER EventLogsOnly
		Use this switch parameter if you only want to search in the event logs.
		
		.PARAMETER LogFilesOnly
		Use this parameter if you only want to search for logs on the file system.
		
		.PARAMETER ExcludeDirectory
		If searching on the file system, specify any folder paths you'd like to skip.
		
		.PARAMETER FileExtension
		Specify one or more comma-delimited set of file extensions you'd like to search for on the file system. This defaults to 'log,txt,wer' extensions.
	#>

	[CmdletBinding(DefaultParameterSetName = 'Neither')]
	param (
		[Parameter(Mandatory)]
		[datetime]$StartTimestamp,

		[Parameter(Mandatory)]
		[datetime]$EndTimestamp,

		[Parameter(ValueFromPipeline,
			ValueFromPipelineByPropertyName)]
		[string]$ComputerName = 'localhost',

		[Parameter()]
		[string]$OutputFolderPath = ".\$Computername",

		[Parameter(ParameterSetName = 'LogFiles')]
		[string]$LogAuditFilePath = "$OutputFolderPath\LogActivity.csv",

		[Parameter(ParameterSetName = 'EventLogs')]
		[switch]$EventLogsOnly,

		[Parameter(ParameterSetName = 'LogFiles')]
		[switch]$LogFilesOnly,

		[Parameter(ParameterSetName = 'LogFiles')]
		[string[]]$ExcludeDirectory,
		
		[Parameter(ParameterSetName = 'LogFiles')]
		[string[]]$FileExtension = @('log', 'txt', 'wer')
	)
 
	begin {
		if (!$EventLogsOnly.IsPresent) {
			## Create the local directory where to store any log files that matched the criteria
			$LogsFolderPath = "$OutputFolderPath\logs"
			if (!(Test-Path $LogsFolderPath)) {
				mkdir $LogsFolderPath | Out-Null
			}
		}
 
		function Add-ToLog($FilePath, $LineText, $LineNumber, $MatchType) {
			$Audit = @{
				'FilePath'   = $FilePath;
				'LineText'   = $LineText
				'LineNumber' = $LineNumber
				'MatchType'  = $MatchType
			}
			[pscustomobject]$Audit | Export-Csv -Path $LogAuditFilePath -Append -NoTypeInformation
		}
	}
 
	process {
 
		## Run only if the user wants to find event log entries
		if (!$LogFilesOnly.IsPresent) {
			## Find all of the event log names that contain at least 1 event
			$Logs = (Get-WinEvent -ListLog * -ComputerName $ComputerName | Where-Object { $_.RecordCount }).LogName
			$FilterTable = @{
				'StartTime' = $StartTimestamp
				'EndTime'   = $EndTimestamp
				'LogName'   = $Logs
			}
 
			## Find all of the events in all of the event logs that are between the start and ending timestamps
			$Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable -ea 'SilentlyContinue'
			Write-Verbose "Found $($Events.Count) total events"
 
			## Convert the properties to something friendlier and append each event into the event log text file
			$LogProps = @{ }
			[System.Collections.ArrayList]$MyEvents = @()
			foreach ($Event in $Events) {
				$LogProps.Time = $Event.TimeCreated
				$LogProps.Source = $Event.ProviderName
				$LogProps.EventId = $Event.Id
				if ($Event.Message) {
					$LogProps.Message = $Event.Message.Replace("<code>n", '|').Replace("</code>r", '|')
				}
				$LogProps.EventLog = $Event.LogName
				$MyEvents.Add([pscustomobject]$LogProps) | Out-Null
			}
			$MyEvents | Sort-Object Time | Export-Csv -Path "$OutputFolderPath\eventlogs.txt" -Append -NoTypeInformation
		}
 
		## Run only if the user wants to find log files
		if (!$EventLogsOnly.IsPresent) {
			## Enumerate all remote admin shares on the remote computer.  I do this instead of enumerating all phyiscal drives because
			## the drive may be there and the share may not which means I can't get to the drive anyway.
			$Shares = Get-WmiObject -ComputerName $ComputerName -Class Win32_Share | Where-Object { $_.Path -match '^\w{1}:\\$' }
			[System.Collections.ArrayList]$AccessibleShares = @()
			## Ensure I can get to all of the remote admin shares
			foreach ($Share in $Shares) {
				$Share = "\\$ComputerName\$($Share.Name)"
				if (!(Test-Path $Share)) {
					Write-Warning "Unable to access the '$Share' share on '$Computername'"
				}
				else {
					$AccessibleShares.Add($Share) | Out-Null 
				}
			}
 
			$AllFilesQueryParams = @{
				Path        = $AccessibleShares
				Recurse     = $true
				Force       = $true
				ErrorAction = 'SilentlyContinue'
				File        = $true
			}
			## Add any directories specified in $ExcludeDirectory param to not search for log files in
			if ($ExcludeDirectory) {
				$AllFilesQueryParams.ExcludeDirectory = $ExcludeDirectory 
			}
			## Create the crazy regex string that I use to search for a number of different date/time formats.
			## This is used in an attempt to search for date/time strings in each text file found
			##TODO: Add capability to match on Jan,Feb,Mar,etc
			$DateTimeRegex = "($($StartTimestamp.Month)[\\.\-/]?$($StartTimestamp.Day)[\\.\-/]?[\\.\-/]$($StartTimestamp.Year))|($($StartTimestamp.Year)[\\.\-/]?$($StartTimestamp.Month)[\\.\-/]?[\\.\-/]?$($StartTimestamp.Day))"
			## Enumerate all files matching the query params that have content
			Get-ChildItem @AllFilesQueryParams | Where-Object { $_.Length -ne 0 } | ForEach-Object {
				try {
					Write-Verbose "Processing file '$($_.Name)'"
					## Record the file if the last write time is within the timeframe.  This finds log files that may not record a 
					## date/time timestamp but may still be involved in whatever event the user is trying to find.
					if (($_.LastWriteTime -ge $StartTimestamp) -and ($_.LastWriteTime -le $EndTimestamp)) {
						Write-Verbose "Last write time within timeframe for file '$($_.Name)'"
						Add-ToLog -FilePath $_.FullName -MatchType 'LastWriteTime'
					}
					## If the file found matches the set of extensions I'm trying to find and it's actually a plain text file.
					## I use the Get-Content to just double-check it's plain text before parsing through it.
					if ($FileExtension -contains $_.Extension.Replace('.', '') -and !((Get-Content $_.FullName -Encoding Byte -TotalCount 1024) -contains 0)) {
						## Check the contents of text file to references to dates in the timeframe
						Write-Verbose "Checking log file '$($_.Name)' for date/time match in contents"
						$LineMatches = Select-String -Path $_.FullName -Pattern $DateTimeRegex
						if ($LineMatches) {
							Write-Verbose "Date/time match found in file '$($_.FullName)'"
							## Record all of the matching lines to the audit file.
							foreach ($Match in $LineMatches) {
								Add-ToLog -FilePath $_.FullName -LineNumber $Match.LineNumber -LineText $Match.Line -MatchType 'Contents'
							}
							## Create the same path to the log file on the remote computer inside the output log directory and 
							## copy the log file with an event inside the timeframe to that path.
							## This will not work if an file path above 255 characters is met.
							$Trim = $_.FullName.Replace("\\$Computername\", '')
							$Destination = "$OutputFolderPath\$Trim"
							if (!(Test-Path $Destination)) {
								##TODO: Remove the error action when long path support is implemented
								mkdir $Destination -ErrorAction SilentlyContinue | Out-Null
							}
							Copy-Item -Path $_.FullName -Destination $Destination -ErrorAction SilentlyContinue -Recurse
						}
					}
				}
				catch {
					Write-Warning $_.Exception.Message 
				}
			}
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/Get-EventsFromTimeframe.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-EventsFromTimeframe.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

