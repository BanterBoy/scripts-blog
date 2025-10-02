---
layout: post
title: Write-Log.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/logging/write-log/
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

**_@GitHub Copilot_** - The code is a PowerShell function called Write-Log. It is designed to add logging capability to other scripts. The function writes a message to a specified log file with the current time stamp. In addition to writing output and/or verbose, you can write to a log file for later debugging. The function has several parameters that allow you to customize the log message.

The Message parameter is the content that you wish to add to the log file. The Path parameter is the path to the log file to which you would like to write. By default, the function will create the path and file if it does not exist. The Level parameter specifies the criticality of the log information being written to the log (i.e. Error, Warning, Informational). The NoClobber parameter is used if you do not wish to overwrite an existing file.

The function has several examples that demonstrate how to use it. For example, you can use the Write-Log function to write a message to a log file with the default path and file name. You can also specify a custom path and file name. Additionally, you can specify the level of the log message (i.e. Error, Warning, Informational).

The function uses PowerShell's switch statement to write the log message to the appropriate pipeline (i.e. Error, Warning, Informational). The log message is formatted with the current date and time stamp, the level of the log message, and the message itself. The log message is then written to the specified log file.

To improve the code's readability, the function uses descriptive parameter names and comments to explain what each section of the code does. Additionally, the function uses PowerShell's cmdlet binding attribute to enable advanced parameter validation and pipeline support. Finally, the function uses PowerShell's verbose preference to display verbose messages.

To improve the code's performance, the function could be optimized to handle large log files more efficiently. For example, the function could use a buffered approach to write log messages to the log file. Additionally, the function could use a more efficient date and time stamp format.

**_@BanterBoy:_** -Can you provide an example of how to use the Write-Log function in a PowerShell script?

**_@GitHub Copilot_** - Certainly! Here's an example of how to use the Write-Log function in a PowerShell script:

```powershell
# Import the Write-Log function
. .\Write-Log.ps1

# Write a message to the log file
Write-Log -Message "Starting script" -Path "C:\Logs\Script.log"

# Do some work here...

# Write another message to the log file
Write-Log -Message "Script completed successfully" -Path "C:\Logs\Script.log"
```

In this example, we first import the Write-Log function into our script. We then use the function to write a message to the log file at the beginning of our script, and another message at the end of our script. The `-Message` parameter specifies the content of the log message, and the `-Path` parameter specifies the path to the log file.

You can also use the `-Level` parameter to specify the criticality of the log message (i.e. Error, Warning, Informational). For example:

```powershell
# Write an error message to the log file
Write-Log -Message "An error occurred" -Path "C:\Logs\Script.log" -Level Error
```

This will write an error message to the log file and also write the message to the error pipeline.

---

#### Script

<!-- BEGIN: FUNCTION CODE -->
```powershell
function Write-Log($Msg, [System.Boolean]$LogTime = $true) {
	#
	# 	 .SYNOPSIS
	# 	     Creates a log entry
	# 	 .DESCRIPTION
	# 	     By default a time stamp will be logged too. This can be
	#        disabled with the -LogTime $false parameter
	# 	 .NOTES
	#		 Author:    Axel Kara, axel.kara@gmx.de
	# 	 .EXAMPLE
	# 	     Write-Log -Msg 'Log entry created successfull.' [-LogTime $false]
	#
	if ($LogTime) {
		$date = Get-Date -format dd.MM.yyyy
		$time = Get-Date -format HH:mm:ss
		Add-Content -Path $LogFile -Value ($date + " " + $time + "   " + $Msg)
	}
	else {
		Add-Content -Path $LogFile -Value $Msg
	}
}
```

<!-- END: FUNCTION CODE -->

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Write-Log.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Write-Log.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
