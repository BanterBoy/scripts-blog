---
layout: post
title: FileWatcher.ps1
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

**_@GitHub Copilot_** - This PowerShell script sets up a file watcher to monitor a specific folder and its subdirectories for any changes made to files. The script starts by creating a new instance of the `System.IO.FileSystemWatcher` class and assigning it to the `$filewatcher` variable. The folder to monitor is specified using the `Path` property, which is set to `"C:\Temp\"`. The `Filter` property is set to `"*.*"`, which means that all files in the folder will be monitored. The `IncludeSubdirectories` property is set to `$true`, which means that changes made to files in any subdirectories of the folder will also be monitored.

The script then defines an action to be taken when an event is detected by the file watcher. The action is defined as a script block assigned to the `$writeaction` variable. The script block retrieves the full path of the file that triggered the event, the type of change that was made, and the current date and time. It then creates a log line containing this information and appends it to a log file located at `"C:\Temp\FileWatcher_log.txt"` using the `Add-Content` cmdlet.

Next, the script uses the `Register-ObjectEvent` cmdlet to subscribe to four different types of events that can be raised by the file watcher: `Created`, `Changed`, `Deleted`, and `Renamed`. Each event is associated with the `$writeaction` script block, which means that the same action will be taken regardless of which event is raised.

Finally, the script enters an infinite loop using the `while` statement and the `$true` variable. This loop is necessary to keep the script running and monitoring the folder continuously. The `Start-Sleep` cmdlet is used to pause the script for 5 seconds between each iteration of the loop.

Overall, this script provides a simple and effective way to monitor a folder and its subdirectories for changes made to files. The script could be improved by adding error handling to handle any exceptions that might occur during the monitoring process. Additionally, the script could be made more efficient by using a more targeted approach to monitoring specific types of files or events.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you could use this script:

1. Monitoring a folder for changes to log files: Suppose you have a folder on your computer that contains log files for a web application. You want to monitor this folder for any changes made to the log files, such as new log entries being added or existing entries being modified. You could use this script to monitor the folder and write a log entry to a separate log file whenever a change is detected.

2. Monitoring a folder for changes to source code files: Suppose you are working on a software development project and you want to monitor a folder on your computer that contains the source code files for the project. You want to be notified whenever a change is made to any of the files in the folder, so that you can review the changes and ensure that they are correct. You could use this script to monitor the folder and write a log entry to a separate file whenever a change is detected.

3. Monitoring a folder for changes to configuration files: Suppose you have a folder on your computer that contains configuration files for a server application. You want to monitor this folder for any changes made to the configuration files, such as changes to server settings or updates to security policies. You could use this script to monitor the folder and write a log entry to a separate file whenever a change is detected.

In each of these examples, the script would be customized to monitor the specific folder and files of interest, and to write the log entries to a separate file that can be reviewed later. The script could be run in the background on your computer, and would continue to monitor the folder and write log entries as long as it is running.

---

#### Script

```powershell
# -------File Watcher-------
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$filewatcher = New-Object System.IO.FileSystemWatcher
#Mention the folder to monitor
$filewatcher.Path = "C:\Temp\"
$filewatcher.Filter = "*.*"
#include subdirectories $true/$false
$filewatcher.IncludeSubdirectories = $true
$filewatcher.EnableRaisingEvents = $true
### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
$writeaction = { $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $logline = "$(Get-Date), $changeType, $path"
    Add-Content "C:\Temp\FileWatcher_log.txt" -value $logline
}
### DECIDE WHICH EVENTS SHOULD BE WATCHED
#The Register-ObjectEvent cmdlet subscribes to events that are generated by .NET objects on the local computer or on a remote computer.
#When the subscribed event is raised, it is added to the event queue in your session. To get events in the event queue, use the Get-Event cmdlet.
Register-ObjectEvent $filewatcher "Created" -Action $writeaction
Register-ObjectEvent $filewatcher "Changed" -Action $writeaction
Register-ObjectEvent $filewatcher "Deleted" -Action $writeaction
Register-ObjectEvent $filewatcher "Renamed" -Action $writeaction
while ($true) { Start-Sleep 5 }

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/FileWatcher.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=FileWatcher.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
