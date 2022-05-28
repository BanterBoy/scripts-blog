---
layout: post
title: CreateADMXCentralStore.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Information

This PowerShell script will create the ADMX Central Store for you by copying the ADMX files from several source locations, such as a master source on an Administrative share and/or several management servers, including IT Pro workstations.

The script has 3 variables which you will need to configure:-

- `$MasterReferenceLocation` – This is the location where you may store your ADMX master files, or 3rd party ADMX files. If you use a relative path, the script will prepend the script path to create an absolute path.
- `$languages` – This is an array of languages you use so that we copy across the relevant ADML files, such as “en-us” for example. Setting this to an \* (asterix) will copy the ADML files from ALL language folders.
- `$SourceServers` – This is an array of servers and workstations that you want to use to build the ADMX Central Store. They are typically the servers and workstations that contain the latest versions of ADMX files, as well as the customised and 3rd party ones you’re currently referencing in any GPOs.

---

#### OutPut

The screen shot below shows the output from the script running for the first time

<div>
<a href="/assets/images/functions/CreateADMXCentralStore-Script-Output.png" data-lightbox="CreateADMXCentralStore" data-title="CreateADMXCentralStore"><img src="/assets/images/tools/CreateADMXCentralStore-Script-Output.png" alt="CreateADMXCentralStore" width="828" height="800"/></a>
</div>

More information can be found on the owners website - [jhouseconsulting.com][5]{:target="\_blank"}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

```powershell

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

<small><i>CreateADMXCentralStore.ps1</i></small>

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/CreateADMXCentralStore.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CreateADMXCentralStore.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/tools.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Tools
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
