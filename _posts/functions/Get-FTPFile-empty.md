---
layout: post
title: Get-FTPFile-empty.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell

function Get-FTPFile ($Source, $Target, $UserName, $Password) {

    # Create a FTPWebRequest object to handle the connection to the ftp server
    $ftprequest = [System.Net.FtpWebRequest]::create($Source)

    # set the request's network credentials for an authenticated connection
    $ftprequest.Credentials =
    New-Object System.Net.NetworkCredential($username, $password)

    $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
    $ftprequest.UseBinary = $true
    $ftprequest.KeepAlive = $false

    # send the ftp request to the server
    $ftpresponse = $ftprequest.GetResponse()

    # get a download stream from the server response
    $responsestream = $ftpresponse.GetResponseStream()

    # create the target file on the local system and the download buffer
    $targetfile = New-Object IO.FileStream ($Target, [IO.FileMode]::Create)
    [byte[]]$readbuffer = New-Object byte[] 1024

    # loop through the download stream and send the data to the target file
    do {
        $readlength = $responsestream.Read($readbuffer, 0, 1024)
        $targetfile.Write($readbuffer, 0, $readlength)
    }
    while ($readlength -ne 0)

    $targetfile.close()
}

$sourceuri = "ftp://MyFtpServer/FolderPath\File.txt"
$targetpath = "C:\temp\MyFile.txt"
$user = "Username"
$pass = "Password"
Get-FTPFile $sourceuri $targetpath $user $pass
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-FTPFile-empty.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FTPFile-empty.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
