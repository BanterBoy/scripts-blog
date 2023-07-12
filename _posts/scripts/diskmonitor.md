---
layout: post
title: diskmonitor.ps1
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
#*=============================================================================
#* Script Name: Diskmonitor.ps1
#* Created:     02-25-2009
#* Author:      Colin Smiht
#* Company:
#* Email:
#* Web:         http://sysadminsmith.com
#*=============================================================================
#* Purpose:  This script will gather disk information about all the servers listed in your computerlistall file. This is a csv file.
#*           It will also send out notifications via email to anyone you want based on low disk parameters that you provide
#*
#*=============================================================================

##########################################
###		Gather Disk Information	   ###
##########################################
Clear-Content "D:\Scripts\Powershell\PAC\lowdisk.txt"
$i = 0
$users = "some.email@address.com"
$computers = import-csv "D:\Scripts\computerlistall.txt"
Write-Output "ServerName		Drive Letter	Drive Size	Free Space	Percent Free" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
Write-Output "----------		------------	----------	----------	------------" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
foreach ($line in $computers) {
	$computer = $line.hostname
	$ip = $line.ip
	$computer
	$ip
}
$drives = Get-WmiObject -ComputerName $computer Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
foreach ($drive in $drives) {
	$size1 = $drive.size / 1GB
	$size1
	$size = "{0:N2}" -f $size1
	$size
	$free1 = $drive.freespace / 1GB
	$free = "{0:N2}" -f $free1
	$ID = $drive.DeviceID
	$a = $free1 / $size1 * 100
	$b = "{0:N2}" -f $a

	##############################################
	##	Determine if any disks low	##
	##############################################

	if (($ID -eq "D:") -or ($ID -eq "S:") -or ($ID -eq "T:") -or ($ID -eq "C:") -and ($free1 -lt 1)) {
		Write-Output "$computer		$ID			$size		$free		$b" >> "D:\Scripts\Powershell\PAC\lowdisk.txt"
		$i++
		#[char]10 | Out-File -append ./low.txt
	}
}


####################################################

##    Send Notification if alert $i is greater then 0         ##

####################################################

if ($i -gt 0) {
	foreach ($user in $users) {
		Write-Output "Sending Email notification ro $user"
		$smtpServer = "smtp server"
		$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
		$emailFrom = "fromuser@domain.com"
		$subject = "Email Subject"
		foreach ($line in Get-Content "D:\Scripts\lowdisk.txt")
		{
			$body += "$line `n"
		}
		$smtp.Send($EmailFrom, $user, $subject, $body)
		$body = ""
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/diskmonitor.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=diskmonitor.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
