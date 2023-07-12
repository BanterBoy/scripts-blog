---
layout: post
title: AllSecurityProtocols.ps1
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

**_@GitHub Copilot_** - This PowerShell script sets the security protocols for a web request and then sends a request to the BBC website to retrieve its status code. The first line of the script creates a variable called `$AllProtocols` and sets it to the value of `[System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'`. This line specifies the security protocols that will be used for the web request. The protocols specified are SSL 3.0, TLS 1.0, TLS 1.1, and TLS 1.2.

The second line of the script sets the security protocol for the `System.Net.ServicePointManager` to the value of `$AllProtocols`. This line ensures that the web request will use the security protocols specified in the `$AllProtocols` variable.

The third line of the script sends a web request to the BBC website using the `Invoke-WebRequest` cmdlet. The `-Uri` parameter specifies the URL of the website to request. The `StatusCode` property of the web request is then retrieved and output to the console.

Overall, this script sets the security protocols for a web request and then sends a request to the BBC website to retrieve its status code. It is a simple example of how to use PowerShell to interact with web resources.

Possible ways to improve the code with respect to readability and performance include adding comments to explain the purpose of each line of code, using more descriptive variable names, and using a try-catch block to handle any errors that may occur during the web request. Additionally, the script could be optimized for performance by using asynchronous web requests or by caching the results of the web request to avoid unnecessary network traffic.

---

#### Script

```powershell
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
(Invoke-WebRequest -Uri "https://www.bbc.co.uk/").StatusCode
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/AllSecurityProtocols.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=AllSecurityProtocols.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
