---
layout: post
title: chart-driveSpace.V2.ps1
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
# This script creates graphical Report by using logparser and WMI
# for a set of remote server and localhost

# usage :
# With a list of remote computers
# cmdline
#   get-content MyServerList.txt | chart-driveSpace.V2.ps1

# MyServerList.txt is a list of remote servers

# localhost
# cmdline
# run script like that : & .\chart-driveSpace.V2.ps1


#############
#pre-requist#
#############
# logparser version 2.2
# Micrososft office or Microsoft Office Web Components

begin {
	# function found on http://www.blkmtn.org/sepeck
	function Get-DriveSpace([string]$SystemName ) {
		$driveinfo = get-wmiobject win32_logicaldisk -filter "drivetype=3 or drivetype=4" -computer $SystemName
		$driveinfo | Select-Object deviceid, `
		@{Name = "FreeSpace"; Expression = { ($_.freespace / 1GB).tostring("0.00") } }, `
		@{Name = "DriveSize"; Expression = { ($_.size / 1GB).tostring("0.00") } }, `
		@{Name = "Percentfree"; Expression = { ((($_.freespace / 1GB) / ($_.size / 1GB)) * 100).tostring("0.00") } }
	}

}

Process {
	$logparser = "c:\Program Files\Log Parser 2.2\LogParser.exe"
	$serverName = $_

	if ($Null -eq $serverName) {
		$serverName = $env:COMPUTERNAME
	}

	Get-DriveSpace $serverName | Export-Csv $env:temp"\temp.csv" -NoTypeInformation
	& $logparser "select deviceid, TO_REAL (REPLACE_CHR (percentfree, ',', '.')) as purcentage into chart_$serverName.gif from $env:temp\temp.csv order by deviceID desc" "-o:chart" "-charttype:BarStacked" "-charttitle:Purcentage : FreeSpace by disk              Server:$serverName" "-values:ON" "-categories:ON" "-maxCategoryLabels:100"
	Invoke-Item .\"chart_"$serverName".gif"
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/chart-driveSpace.V2.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=chart-driveSpace.V2.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
