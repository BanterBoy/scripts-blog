---
layout: post
title: SyncFoldersScript.ps1
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
###############################################################################
##script:           Sync-Folders.ps1
##
##Description:      Syncs/copies contents of one dir to another. Uses MD5
#+                  checksums to verify the version of the files and if they
#+                  need to be synced.
##Created by:       Noam Wajnman
##Creation Date:    June 9, 2014
###############################################################################
#FUNCTIONS
function Get-FileMD5 {
    Param([string]$file)
    $md5 = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
    $IO = New-Object System.IO.FileStream($file, [System.IO.FileMode]::Open)
    $StringBuilder = New-Object System.Text.StringBuilder
    $md5.ComputeHash($IO) | ForEach-Object { [void] $StringBuilder.Append($_.ToString("x2")) }
    $hash = $StringBuilder.ToString()
    $IO.Dispose()
    return $hash
}
#VARIABLES
$DebugPreference = "continue"
#parameters
$SRC_DIR = 'FOLDERPATH'
$DST_DIR = 'FOLDERPATH'
#SCRIPT MAIN

Start-Transcript -Path 'TRANSCRIPTPATH\transcript.txt'
$SourceFiles = Get-ChildItem -Recurse $SRC_DIR | Where-Object { $_.PSIsContainer -eq $false } #get the files in the source dir.
$SourceFiles | ForEach-Object { # loop through the source dir files
    $src = $_.FullName #current source dir file
    Write-Debug $src
    $dest = $src -replace $SRC_DIR.Replace('\', '\\'), $DST_DIR #current destination dir file
    if (test-path $dest) {
        #if file exists in destination folder check MD5 hash
        $srcMD5 = Get-FileMD5 -file $src
        Write-Debug "Source file hash: $srcMD5"
        $destMD5 = Get-FileMD5 -file $dest
        Write-Debug "Destination file hash: $destMD5"
        if ($srcMD5 -eq $destMD5) {
            #if the MD5 hashes match then the files are the same
            Write-Debug "File hashes match. File already exists in destination folder and will be skipped."
            $cpy = $false
        }
        else {
            #if the MD5 hashes are different then copy the file and overwrite the older version in the destination dir
            $cpy = $true
            Write-Debug "File hashes don't match. File will be copied to destination folder."
        }
    }
    else {
        #if the file doesn't in the destination dir it will be copied.
        Write-Debug "File doesn't exist in destination folder and will be copied."
        $cpy = $true
    }
    Write-Debug "Copy is $cpy"
    if ($cpy -eq $true) {
        #copy the file if file version is newer or if it doesn't exist in the destination dir.
        Write-Debug "Copying $src to $dest"
        if (!(test-path $dest)) {
            New-Item -ItemType "File" -Path $dest -Force
        }
        Copy-Item -Path $src -Destination $dest -Force
    }
}
Stop-Transcript
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/fileManagement/SyncFoldersScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=SyncFoldersScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
