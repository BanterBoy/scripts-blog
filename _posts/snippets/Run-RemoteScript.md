---
layout: post
title: Run-RemoteScript.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to run a remote script on a specified server. The script prompts the user to enter their username and password, which are then used to create a PSCredential object. The PSCredential object is used to authenticate the user when connecting to the remote server.

The script then prompts the user to enter the server's fully qualified domain name (FQDN) or IP address. This information is stored in the $Server variable.

Finally, the Invoke-Command cmdlet is used to run the remote script on the specified server. The -ComputerName parameter specifies the server to connect to, while the -Credential parameter specifies the PSCredential object to use for authentication. The -Authentication parameter specifies the authentication method to use, in this case Negotiate. The -FilePath parameter specifies the path to the script file to run on the remote server.

Overall, this script provides a simple and secure way to run a PowerShell script on a remote server. It prompts the user for their credentials and the server information, ensuring that the user is authorized to access the remote server. The Invoke-Command cmdlet then executes the specified script file on the remote server.

To improve the readability of this code, it may be helpful to add comments explaining each section of the script. Additionally, the script could be modified to accept command-line arguments instead of prompting the user for input. This would make it easier to automate the script and integrate it into other scripts or workflows.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are a few examples of how you could use this script:

1. Run a script on a remote server: Suppose you have a PowerShell script that you want to run on a remote server. You could use this script to prompt you for your credentials and the server information, and then run the script on the remote server. For example, if your script is located at `C:\Scripts\MyScript.ps1` and the remote server's FQDN is `myserver.example.com`, you could run the following command:

```
.\Run-RemoteScript.ps1
```

This would prompt you for your credentials and the server information, and then run `MyScript.ps1` on `myserver.example.com`.

2. Automate a script on multiple servers: Suppose you have a PowerShell script that you want to run on multiple servers. You could modify this script to accept a list of servers as a parameter, and then use a loop to run the script on each server in the list. For example, you could modify the script to accept a parameter called `$Servers`, which is an array of server names. Then you could use a loop to run the script on each server in the array:

```
$Servers = @("server1.example.com", "server2.example.com", "server3.example.com")

foreach ($Server in $Servers) {
    .\Run-RemoteScript.ps1 -Server $Server
}
```

This would run the script on each server in the `$Servers` array.

3. Run a script as a scheduled task: Suppose you have a PowerShell script that you want to run as a scheduled task on a remote server. You could use this script to create the scheduled task and run the script on the remote server. For example, you could modify the script to accept a parameter called `$TaskName`, which is the name of the scheduled task to create. Then you could use the `New-ScheduledTask` cmdlet to create the scheduled task, and the `Invoke-ScheduledTask` cmdlet to run the script as the scheduled task:

```
$TaskName = "My Scheduled Task"

New-ScheduledTask -Action {
    .\Run-RemoteScript.ps1 -Server "myserver.example.com"
} -TaskName $TaskName

Invoke-ScheduledTask -TaskName $TaskName
```

This would create a scheduled task called "My Scheduled Task" that runs `Run-RemoteScript.ps1` on `myserver.example.com`.

---

#### Script

```powershell
# Create a secure string for the password
$Username = Read-Host "Enter Username (domain\username)"
$Password = Read-Host "Enter Password" -AsSecureString

# Create the PSCredential object
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Server Variable
$Server = Read-Host "Enter Server (FQDN or IP)"

Invoke-Command -ComputerName $Server -Credential $Credentials -Authentication Negotiate -FilePath "C:\Users\Luke Leigh\Documents\GitHub\PowerRepo\Scripts\SomeScriptFile.ps1"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Run-RemoteScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Run-RemoteScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
