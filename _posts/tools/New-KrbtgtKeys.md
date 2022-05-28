---
layout: post
title: New-KrbtgtKeys.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Information](#information)
  - [OutPut](#output)
  - [Script](#script)
  - [Download](#download)
  - [gist-it](#gist-it)
  - [Report Issues](#report-issues)

<small><i>[Table of contents generated with markdown-toc][1]{:target="\_blank"}</i></small>

---

#### Information

This is a Microsoft script and is maintained at at the following GitHub Repository - [https://github.com/microsoft/New-KrbtgtKeys.ps1][5]{:target="\_blank"}

---

#### OutPut

<div>
<a href="/assets/images/functions/New-KrbtgtKeys-example.png" data-lightbox="New-KrbtgtKeys" data-title="New-KrbtgtKeys"><img src="/assets/images/tools/New-KrbtgtKeys-example.png" alt="New-KrbtgtKeys" width="940" height="159"/></a>
</div>

---

#### Script

````powershell

```

This script will enable you to: (1) perform a single reset of the krbtgt account password hash and related keys (it can be run multiple times for subsequent resets), (2) immediately replicate the krbtgt account and its new keys to all writable DCs in the domain, and (3) validate that all writable DC's in the domain have successfully replicated the new keys, so they can decrypt any TGTs that are presented by clients and were encrypted with the new key(s). These capabilities help to perform the reset in a manner which minimizes the likelihood of Kerberos authentication issues due to the operation.

The script is designed to be self-documenting and includes an interactive menu and screen output that will guide you through its execution. Because it requires user input to select the execution mode and confirm before any changes are made, it is safe to begin by simply executing the script and reading the guidance throughout.

<script src="https://gist-it.appspot.com/github.com/BanterBoy/scripts-blog/blob/master/PowerShell/tools/New-KrbtgtKeys.ps1

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

This document is a supplemental guide to the interactive krbtgt reset script (New-KrbtgtKeys.ps1). This guide describes the operating modes of the script and how to execute each of them.

<small><i>Guide to Running New-CtmADKrbtgtKeys.docx</i></small>

<button class="btn" type="submit" onclick="window.open('/assets/files/Guide to Running New-CtmADKrbtgtKeys.docx')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

<small><i>New-KrbtgtKeys.ps1</i></small>

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/New-KrbtgtKeys.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes.

<!-- Place this tag where you want the button to render. -->
<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-KrbtgtKeys.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
````
