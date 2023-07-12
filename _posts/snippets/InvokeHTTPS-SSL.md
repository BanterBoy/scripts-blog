---
layout: post
title: InvokeHTTPS-SSL.ps1
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

**_@GitHub Copilot_** - This code is a PowerShell script that sets up the necessary security protocols to use an HTTPS URL. The first line is a comment that explains the purpose of the script. The second line creates a variable called `$AllProtocols` and assigns it a value of `[Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'`. This value is a combination of the different security protocols that are needed to establish a secure connection with an HTTPS URL.

The third line sets the security protocol for the `ServicePointManager` class to the value of `$AllProtocols`. This is done using the static property `SecurityProtocol` of the `ServicePointManager` class. By setting this property to the value of `$AllProtocols`, the script ensures that all the necessary security protocols are enabled for the HTTPS URL.

Overall, this code is a simple and effective way to set up the necessary security protocols for using an HTTPS URL in PowerShell. It is important to note that this code only sets up the security protocols and does not actually establish a connection with an HTTPS URL.

Possible ways to improve the code with respect to readability and performance could include adding more comments to explain the purpose of each line of code, and using more descriptive variable names to make the code easier to understand. Additionally, the code could be optimized for performance by using a more efficient method for setting the security protocol, such as using the `TLS` constant instead of specifying each protocol individually.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Yes, of course! Once you have the script saved as a `.ps1` file, you can simply call it from within your PowerShell script or console session. Here's an example of how you could use this script to establish a secure connection with an HTTPS URL:

```powershell
# Import the script
. C:\Path\To\InvokeHTTPS-SSL.ps1

# Set the URL you want to connect to
$url = "https://www.example.com"

# Make the HTTPS request
$response = Invoke-WebRequest -Uri $url

# Display the response content
$response.Content
```

In this example, we first import the `InvokeHTTPS-SSL.ps1` script using the dot operator (`.`). We then set the URL we want to connect to and make an HTTPS request using the `Invoke-WebRequest` cmdlet. Finally, we display the content of the response using the `Content` property of the `$response` object.

This is just one example of how you could use this script. The script itself only sets up the necessary security protocols for using an HTTPS URL, so you would need to use other PowerShell cmdlets or functions to actually establish a connection and retrieve data from the URL.

---

#### Script

```powershell
# Needed in a script when trying to use an HTTPS URL

$AllProtocols = [Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[Net.ServicePointManager]::SecurityProtocol = $AllProtocols
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/InvokeHTTPS-SSL.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=InvokeHTTPS-SSL.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
