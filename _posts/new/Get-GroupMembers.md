---
layout: post
title: Blank-Page.ps1
---

### Description

GitHub Copilot: The code is a PowerShell script that defines a function called `Get-GroupMembers`. This function exports the users within Active Directory groups that match a specified search string.

The function takes a single parameter called `GroupName`, which is used to specify the name of the group to search for. This parameter supports wildcards, allowing for more flexible search criteria.

The function uses the `Get-ADGroup` cmdlet to retrieve a collection of groups that match the search string. It then uses a `ForEach-Object` loop to iterate over each group and retrieve its members using the `Get-ADGroupMember` cmdlet.

For each group member, the function uses the `Get-ADUser` cmdlet to retrieve detailed information about the user, including all available properties. The resulting user objects are output as a collection of `Object` objects.

Overall, this script is a useful tool for extracting information about users in Active Directory groups. It uses the `Get-ADGroup`, `Get-ADGroupMember`, and `Get-ADUser` cmdlets to perform the search and retrieve detailed information about each user.

To improve the readability of the code, the author could consider adding comments to explain the purpose of each section of the script. Additionally, they could use more descriptive variable names to make the code easier to understand. Finally, they could consider adding error handling to the script to handle cases where the search fails or returns unexpected results.

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

#### Script

```powershell

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Encrypt-Laptop.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Encrypt-Laptop.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
