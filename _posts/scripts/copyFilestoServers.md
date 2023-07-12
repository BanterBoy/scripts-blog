---
layout: post
title: copyFilestoServers.ps1
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
#Get list of servers to push new files to#
$servers = Get-Content "d:\test2\servers\servers.txt"

#Set where the new files are located and read them in as a variable#
$newfilepath = "d:\test2"
$newfiles = Get-ChildItem $newfilepath | Where-Object { $_.name -like "*.txt*" }

#Get Date and Time Information#
$date = Get-Date -format MM_dd_yyyy
$time = get-date -format HH:mm:ss

#Test to see if OUT directory and Log file Exist. If not create them#
if (!(Test-Path "d:\OUT")) {
	New-Item -Type Directory "d:\OUT\"
}
if (!(Test-Path "d:\OUT\rptmove.log")) {
	New-Item -Type File "d:\OUT\rptmove.log"
}
$log = "d:\OUT\rptmove.log"

#Start Checking each server to see if it has a file with the same name in the destination path#

foreach ($server in $servers) {
	Write-Output "########################################################################################" >> $log
	Write-Output "`n########################################################################################" >> $log
	Write-Output "Working with Server $server" >> $log
	# Ping server to make sure it is available for this task#
	$pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"

	if ($pingresult.statuscode -eq 0) {

		write-host $server is available -background "green" -foreground "black"
		Write-Output "$server is available" >> $log
		$prodfolderpath = "\\$server\d$\Reports"
		$oldfiles = Get-ChildItem $prodfolderpath | Where-Object { $_.name -like "*.txt*" }
		foreach ($newfile in $newfiles) {
			$found = 1
			$newrpt = $newfile.Name
			foreach ($oldfile in $oldfiles) {
				$oldrpt = $oldfile.name
				# If the server has a file with the same name, Rename file with datestamp, copy new file to destination#
				if ($newrpt -eq $oldrpt) {
					Write-Output "`nMatch found for $newrpt" >> $log
					Write-Output "Renaming $oldrpt to $oldrpt.$date" >> $log
					Rename-Item -path "$prodfolderpath\$oldrpt" -newName "$oldrpt.$date"
					Write-Output "copy $newrpt to $prodfolderpath\newrpt" >> $log
					copy-Item -path "$newfilepath\$newrpt" -destination "$prodfolderpath"
					Write-Output "moving of file $newrpt is complete on $date at $time" >> $log
					$found = 0
				}

			}
			# if server does not have a file with the same name then move the new file to the server. #
			if ($found -eq 1) {
				Write-Output "`n$newrpt not found in $prodfolderpath" >> $log
				copy-Item -path "$newfilepath\$newrpt" -destination "$prodfolderpath"
				Write-Output "moving of file $newrpt is complete on $date at $time" >> $log
				$found = 0
			}
		}
	}
	else {
		Write-Host $server is NOT available. Please check server and try again -background "red" -foreground "black"
		Write-Output "$server is not available for this operation. Please check server and try again!" >> $log
	}
	Write-Output "`nCompleted Working with $server" >> $log
}

Write-Output "########################################################################################" >> $log
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/fileManagement/copyFilestoServers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=copyFilestoServers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
