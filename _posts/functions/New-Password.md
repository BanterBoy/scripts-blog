---
layout: post
title: New-Password.ps1
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
<# API Usage
    It is possible to pass settings into the generator to set the initial values of the complexity settings.

    This is done simply by adding values into the URL.

    For instance, if you wish to have the initial passwords be numbers only that is just numbers between 6 and 9 and you want to make it 8 characters long and create 5 of these passwords you can use this URL for those results.

    https://passwordwolf.com/api/?length=10&upper=off&lower=off&special=off&exclude=012345&repeat=5

    The output from this request is returned simply in JSON data.

    If a value is omitted the default is used. The returned password will also be displayed phonetically.

    Variable	Possible Values	Default	Description
    upper	off	on	Turns the upper case characters on or off.
    lower	off	on	Turns the lower case characters on or off.
    numbers	off	on	Turns numbers on or off.
    special	off	on	Turns special characters on or off.
    length	1-128	15	Set the password length.
    exclude	[string]	?!<>li1I0OB8`	Indicates which characters to exclude.
    repeat	1-128	9	Indicates how many passwords to generate.

    $upper
    $lower
    $numbers
    $special
    $length
    [string]$exclude		?!<>li1I0OB8`	Indicates which characters to exclude.
    repeat	1-128	9	Indicates how many passwords to generate.
#>

function New-Password {
    [CmdletBinding()]
    $Alphas = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=8&upper=on&lower=on&numbers=off&special=off&repeat=1"
    $Special = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=1&upper=off&lower=off&numbers=off&special=on&exclude={}][<>~¬&repeat=1"
    $Numbers = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=3&upper=off&lower=off&numbers=on&special=off&repeat=1"
    $password = $Alphas.password + $Special.password + $Numbers.password
    $password
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/New-Password.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Password.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
