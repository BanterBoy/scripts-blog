---
layout: post
title: Find-MissingFiles.ps1
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
<#Find-Missingfiles.ps1
#File/folder comparison tool to check a source and destination for missing files/folders
#Reports missing source files, ignores extra files on the destination

.EXAMPLE
Find-MissingFiles.ps1 | Out-File MissingSource.txt
#>

$SourcePath = '\\SERVERNAME\TVShows\Filed'
$DestPath = '\\DOMAINCONTROLLERNAME\d$\TVSeries'

#Equivalent cmd for 'dir /b /s'
$Source = (Get-ChildItem $SourcePath -Recurse).FullName
$Dest = (Get-ChildItem $DestPath -Recurse).FullName

#1/-1 - Different, 0 - Same
$Source[1].CompareTo($Dest[1])
$Source[1].CompareTo($Source[1])

#Cleanup to make the paths appear same
#Basically removing the uncommon source and destination paths portion
for ($i = 0; $i -lt $Source.Count; $i++) {
    $Source[$i] = $Source[$i].Replace($SourcePath, "")
}

for ($i = 0; $i -lt $Dest.Count; $i++) {
    $Dest[$i] = $Dest[$i].Replace($DestPath, "")
}

#Loop the Source files
foreach ($fileS in $Source) {
    #Counter for match
    $Found = $false

    #Loop destination files to Compare with each source
    foreach ($fileD in $Dest) {
        #Check Exact Match
        if ($fileD.CompareTo($fileS) -eq 0)
        { $Found = $true }

    }
    #Writeout missing files
    if (-not $Found)
    { "$SourcePath$fileS" }

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/fileManagement/Find-MissingFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Find-MissingFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
