---
layout: post
title: PermissionsTest.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to check the permissions of a specified user on a given folder. The script starts by defining the `$Folder` variable, which is set to the path of the folder to be checked. The user is then prompted to input the `sAMAccountName` of the user whose permissions are to be checked.

The script then uses the `Get-Acl` cmdlet to retrieve the access control list (ACL) for the specified folder. The `Access` property of the ACL object contains an array of `FileSystemAccessRule` objects, each of which represents a single access control entry (ACE) in the ACL. The script uses the `Where-Object` cmdlet to filter the array of ACEs to only those that match the specified user. The resulting ACE is then stored in the `$permission` variable.

If the `$permission` variable is not empty, the script uses a `ForEach-Object` loop to output a message to the console for each ACE that matches the specified user. The message includes the user's identity reference (i.e. their username) and the specific file system rights that they have on the folder. If the `$permission` variable is empty, the script outputs a message indicating that the specified user does not have any permissions on the specified folder.

Overall, this script is a simple and effective way to check the permissions of a specified user on a given folder. However, there are a few ways that the code could be improved for readability and performance. For example, the script could benefit from more descriptive variable names, and the `Where-Object` cmdlet could be replaced with the more efficient `-Filter` parameter of the `Get-Acl` cmdlet. Additionally, the script could be modified to accept the folder path and user name as command-line arguments, rather than prompting the user for input.

**_@BanterBoy:_** -Can you provide examples for using the script

**_@GitHub Copilot_** - Sure, here are a few examples of how you could use this script:

1. Suppose you want to check if the user "jdoe" has any permissions on the folder "C:\Users\Public". You could run the script and enter "jdoe" when prompted for the user's `sAMAccountName`. The script would then output a message indicating whether or not "jdoe" has any permissions on the folder.

2. Suppose you want to check the permissions of multiple users on the same folder. You could modify the script to prompt the user for a comma-separated list of `sAMAccountName` values, and then use a `ForEach-Object` loop to iterate over each user in the list and check their permissions on the folder.

3. Suppose you want to automate the process of checking permissions on a set of folders for a group of users. You could modify the script to accept the folder path and user name as command-line arguments, and then use a script or batch file to call the script with the appropriate arguments for each folder and user combination. The script could then output the results to a log file or other output destination for later analysis.

---

#### Script

```powershell
$Folder = "$HOME\desktop\testing"
$User = Read-Host "Input the sAMAccountName of user"
$permission = (Get-Acl $Folder).Access | Where-Object { $_.IdentityReference -match $User } | Select-Object IdentityReference, FileSystemRights
If ($permission) {
    $permission | ForEach-Object { Write-Host "User $($_.IdentityReference) has '$($_.FileSystemRights)' rights on folder $folder" }
}
Else {
    Write-Host "$User Doesn't have any permission on $Folder"
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/snippets/PermissionsTest.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=PermissionsTest.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
