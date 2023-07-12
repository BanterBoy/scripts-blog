---
layout: post
title: ExampleHTMLOutput.ps1
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

**_@GitHub Copilot_** - This PowerShell script generates an HTML report of the status of Windows services. The script starts by defining a CSS style for the HTML document. The style sets the font family, background color, and border styles for the table elements. The script also includes a JavaScript function that changes the background color of the table cells based on the value of the first column of the table.

The script then defines the header and title of the HTML document. The header is a level 1 heading that reads "Reporting Service Status". The title of the document is "Example HTML Output".

The script then uses the Get-Service cmdlet to retrieve the status, name, and display name of all Windows services. The output is piped to the ConvertTo-HTML cmdlet, which generates an HTML table with the service information. The -head parameter is used to include the CSS style defined earlier, and the -body parameter is used to include the header. The -title parameter is used to set the title of the HTML document.

Finally, the script saves the HTML document to a temporary file and opens it in the default web browser using the Invoke-Item cmdlet.

Overall, this script is a useful tool for generating an HTML report of the status of Windows services. The CSS style and JavaScript function add visual appeal and interactivity to the report. However, the script could be improved by adding comments to explain the purpose of each section of code and by using more descriptive variable names. Additionally, the script could be modified to accept command-line arguments to allow the user to specify which services to include in the report.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use this PowerShell script:

1. To generate an HTML report of all Windows services:

   ```
   .\service-status-report.ps1
   ```

   This will generate an HTML report of all Windows services and open it in your default web browser.

2. To generate an HTML report of only running services:

   ```
   Get-Service | Where-Object {$_.Status -eq "Running"} | .\service-status-report.ps1
   ```

   This will generate an HTML report of only running Windows services and open it in your default web browser.

3. To generate an HTML report of only specific services:

   ```
   Get-Service -Name "Spooler", "W32Time" | .\service-status-report.ps1
   ```

   This will generate an HTML report of only the "Spooler" and "W32Time" services and open it in your default web browser.

You can also modify the script to accept command-line arguments to allow for more flexibility in generating the report.

**_@BanterBoy:_** -How can I modify the script to accept command-line arguments?

**_@GitHub Copilot_** -
GitHub Copilot: To modify the script to accept command-line arguments, you can use the `$args` variable to retrieve the arguments passed to the script. Here's an example of how you can modify the script to accept a list of service names as an argument:

```powershell
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string[]]$ServiceNames
)

$head = '<style>
 BODY{font-family:Verdana; background-color:lightblue;}
 TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
 TH{font-size:1.3em; border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:#FFCCCC}
 TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:yellow}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript">
 $(function(){
  var linhas = $("table tr");
  $(linhas).each(function(){
   var Valor = $(this).find("td:first").html();
   if(Valor == "Stopped"){
    $(this).find("td").css("background-color","Red");
   }else if(Valor == "Running"){
    $(this).find("td").css("background-color","Green");
   }
  });
 });
</script>
'
$header = "<H1>Reporting Service Status</H1>"
$title = "Example HTML Output"

$services = Get-Service -Name $ServiceNames
$services | ConvertTo-Html -Head $head -Body $header -Title $title | Out-File -FilePath "service-status-report.html" -Encoding UTF8
Invoke-Item "service-status-report.html"
```

In this modified script, the `[CmdletBinding()]` attribute is used to define the script as a cmdlet, and the `$ServiceNames` parameter is defined as an array of strings. The `Get-Service` cmdlet is then used to retrieve the services with the names specified in the `$ServiceNames` parameter. The rest of the script is the same as the original script, except that the `-Name` parameter of `Get-Service` is replaced with `$ServiceNames`.

To use this modified script, you can pass a list of service names as an argument when running the script:

```
.\service-status-report.ps1 -ServiceNames "Spooler", "W32Time"
```

This will generate an HTML report of only the "Spooler" and "W32Time" services and open it in your default web browser.

---

#### Script

```powershell
$head = '<style>
 BODY{font-family:Verdana; background-color:lightblue;}
 TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
 TH{font-size:1.3em; border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:#FFCCCC}
 TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:yellow}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript">
 $(function(){
  var linhas = $("table tr");
  $(linhas).each(function(){
   var Valor = $(this).find("td:first").html();
   if(Valor == "Stopped"){
    $(this).find("td").css("background-color","Red");
   }else if(Valor == "Running"){
    $(this).find("td").css("background-color","Green");
   }
  });
 });
</script>
'
$header = "<H1>Reporting Service Status</H1>"
$title = "Example HTML Output"

Get-Service |
Select-Object Status, Name, DisplayName |
ConvertTo-HTML -head $head -body $header -title $title |
Out-File $env:temp\report.hta
Invoke-Item $env:temp\report.hta
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/ExampleHTMLOutput.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ExampleHTMLOutput.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
