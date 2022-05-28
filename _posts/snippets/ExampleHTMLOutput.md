---
layout: post
title: ExampleHTMLOutput.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

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
