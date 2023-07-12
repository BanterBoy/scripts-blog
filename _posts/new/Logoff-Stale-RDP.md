---
layout: post
title: Blank-Page.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to log off stale Remote Desktop Protocol (RDP) sessions. The script begins by defining a new object called `$starters` with properties for session name, username, ID, state, type, and device. The script then loops through the results of a query to retrieve information about active RDP sessions. For each result, the script attempts to extract the session name, username, ID, state, type, and device information and create a new object with these properties. If an error occurs during this process, the script logs the error message.

After creating the new objects, the script calls a function called `Test-LogFilePath` to ensure that the log file path exists. The script then defines a variable called `$LogFile` to store the path to the log file. The script sets a regular expression pattern to match disconnected sessions with the state of "Disc" and a username that is not empty. The script then retrieves a list of disconnected sessions that match this pattern and selects the ID and username properties. The script then loops through the disconnected sessions and logs off each session using the `logoff` command. The script logs the username of each session that is logged off.

To improve the readability of this code, the variable names could be more descriptive. For example, `$starters` could be renamed to `$sessionProperties`. Additionally, the script could benefit from comments to explain the purpose of each section of code. To improve performance, the script could be optimized to reduce the number of queries to retrieve session information.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - The script is designed to log off stale Remote Desktop Protocol (RDP) sessions. To use the script, you can copy and paste the code into a PowerShell script file and save it with a .ps1 extension. You can then run the script by opening PowerShell and navigating to the directory where the script is saved. You can then run the script by typing the name of the script file and pressing Enter.

For example, if the script is saved as "Logoff-Stale-RDP.ps1" in the C:\Scripts directory, you can run the script by opening PowerShell and typing the following command:

```
cd C:\Scripts
.\Logoff-Stale-RDP.ps1
```

The script will then log off any stale RDP sessions and write the username of each session that is logged off to a log file.

It is important to note that this script should only be used on systems where it is necessary to log off stale RDP sessions. If you are unsure whether this script is appropriate for your system, you should consult with your system administrator before running the script. Additionally, you should always verify any generated code or suggestions before running them on your system.

---

#### Script

```powershell
<#
.SYNOPSIS
   Checks for disconnected sessions and logs off the disconnected user sessions.

.DESCRIPTION
   Checks for disconnected sessions and logs off the disconnected user sessions.

.NOTES
   File Name: Logoff-DisconnectedSession.ps1
   Author   : Bart Kuppens
   Version  : 1.1

.EXAMPLE
   PS > .\Logoff-DisconnectedSession.ps1
#>

function Test-LogFilePath([string]$LogFilePath) {
   if (!(Test-Path -Path $LogFilePath)) { New-Item $LogFilePath -ItemType directory >> $null }
}

function Write-Log([string]$message) {
   Out-File -InputObject $message -FilePath $LogFile -Append
}

function Get-Sessions {
   $queryResults = query session
   $starters = New-Object psobject -Property @{"SessionName" = 0; "UserName" = 0; "ID" = 0; "State" = 0; "Type" = 0; "Device" = 0; }
   foreach ($result in $queryResults) {
      try {
         if ($result.trim().substring(0, $result.trim().indexof(" ")) -eq "SESSIONNAME") {
            $starters.UserName = $result.indexof("USERNAME");
            $starters.ID = $result.indexof("ID");
            $starters.State = $result.indexof("STATE");
            $starters.Type = $result.indexof("TYPE");
            $starters.Device = $result.indexof("DEVICE");
            continue;
         }

         New-Object psobject -Property @{
            "SessionName" = $result.trim().substring(0, $result.trim().indexof(" ")).trim(">");
            "Username"    = $result.Substring($starters.Username, $result.IndexOf(" ", $starters.Username) - $starters.Username);
            "ID"          = $result.Substring($result.IndexOf(" ", $starters.Username), $starters.ID - $result.IndexOf(" ", $starters.Username) + 2).trim();
            "State"       = $result.Substring($starters.State, $result.IndexOf(" ", $starters.State) - $starters.State).trim();
            "Type"        = $result.Substring($starters.Type, $starters.Device - $starters.Type).trim();
            "Device"      = $result.Substring($starters.Device).trim()
         }
      }
      catch {
         $e = $_;
         Write-Log "ERROR: " + $e.PSMessageDetails
      }
   }
}

Test-LogFilePath($ENV:LOCALAPPDATA + "\DisconnectedSessions")
$LogFile = $ENV:LOCALAPPDATA + "\DisconnectedSessions\" + "sessions_" + $([DateTime]::Now.ToString('yyyyMMdd')) + ".log"

[string]$IncludeStates = '^(Disc)$'
Write-Log -Message "Disconnected Sessions CleanUp"
Write-Log -Message "============================="
$DisconnectedSessions = Get-Sessions | Where-Object -FilterScript { $_.State -match $IncludeStates -and $_.UserName -ne "" } | Select-Object -Property ID, UserName
Write-Log -Message "Logged off sessions"
Write-Log -Message "-------------------"
foreach ($session in $DisconnectedSessions) {
   logoff $session.ID
   Write-Log -Message $session.Username
}
Write-Log -Message " "
Write-Log -Message "Finished"

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Blank-Page.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Blank-Page.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
