---
layout: post
title: Elevate-ScriptPermissions.ps1
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

GitHub Copilot: This PowerShell script is designed to check if the current user is running the script with administrator privileges. If the user is not running the script as an administrator, the script will relaunch itself with elevated privileges. The script begins by getting the ID and security principal of the current user account. It then gets the security principal for the Administrator role. The script checks to see if the current user is running the script as an administrator by calling the IsInRole method on the WindowsPrincipal object with the Administrator role as an argument. If the user is running the script as an administrator, the script changes the title and background color of the console window to indicate that the script is running with elevated privileges.

If the user is not running the script as an administrator, the script creates a new process object that starts PowerShell. The script then specifies the current script path and name as a parameter for the new process object. The script sets the Verb property of the new process object to "runas" to indicate that the process should be elevated. The script then starts the new process with elevated privileges using the Start method of the Process class. Finally, the script exits from the current, unelevated, process.

After the elevation check, the script runs any code that needs to be elevated. In this case, the script prompts the user to press any key to continue and waits for the user to press a key by calling the ReadKey method of the RawUI property of the Host object.

To improve the readability of this script, the comments could be made more descriptive and the code could be broken up into smaller functions. To improve the performance of this script, the script could be optimized to reduce the number of calls to the Windows API.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use this script:

1. You have a PowerShell script that needs to modify system settings or files that require administrator privileges. You can use this script to automatically elevate the privileges of your script so that it can perform the necessary actions.

2. You have a PowerShell script that you want to distribute to other users who may not have administrator privileges on their machines. You can include this script with your script to ensure that it will run with elevated privileges on any machine.

3. You have a PowerShell script that you want to run as a scheduled task. You can use this script to ensure that the scheduled task will run with elevated privileges, even if the user who created the task does not have administrator privileges.

---

#### Script

```powershell
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    Clear-Host
}
else {
    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}

# Run your code that needs to be elevated here
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Elevate-ScriptPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Elevate-ScriptPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/snippets.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Snippets
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
