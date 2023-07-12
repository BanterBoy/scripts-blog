---
layout: post
title: Enter-SecureSession.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to create a secure session with a remote server. The script prompts the user to enter their username and password, which are then used to create a PSCredential object. The PSCredential object is used to authenticate the user with the remote server.

On line 9, the script prompts the user to enter the server's fully qualified domain name (FQDN) or IP address. This information is then used to create a remote session with the server using the Enter-PSSession cmdlet on line 11. The -ComputerName parameter specifies the server to connect to, while the -Credential parameter specifies the PSCredential object to use for authentication. The -Authentication parameter specifies the authentication method to use, which in this case is Negotiate.

Overall, this script is a simple and effective way to establish a secure session with a remote server. However, there are a few ways to improve the code's readability and performance. For example, the script could benefit from additional error handling to ensure that the user enters valid credentials and server information. Additionally, the script could be optimized to reduce the number of prompts and streamline the authentication process.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are a few examples of how you might use this script:

1. Suppose you need to manage a remote server that is located in a different office or data center. You could use this script to establish a secure session with the server, allowing you to run commands and manage the server as if you were physically present.

2. If you are a system administrator, you might use this script to automate the process of connecting to remote servers. For example, you could create a script that prompts you for a list of servers and credentials, and then uses this script to establish a secure session with each server in turn.

3. If you are a developer, you might use this script to test your code on a remote server. For example, you could use this script to establish a secure session with a test server, and then run your code on the server to ensure that it works as expected.

Overall, this script is a useful tool for anyone who needs to manage or work with remote servers. By establishing a secure session with the server, you can perform a wide range of tasks without needing to physically be present at the server's location.

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

# Create Remote Session
Enter-PSSession -ComputerName $Server -Credential $Credentials -Authentication Negotiate
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/Enter-SecureSession.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enter-SecureSession.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
